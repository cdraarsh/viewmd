# API Integration Handoff

Generated example for ViewMD launch screenshots.

## Context

The client wants a small service that imports customer records from a partner API once per hour, stores normalized records, and exposes a read-only endpoint for the internal dashboard.

The integration should be boring, observable, and safe to retry.

## Architecture

```text
Scheduler -> Import Worker -> Partner API
                    |
                    v
             Normalization Layer
                    |
                    v
              Customer Database
                    |
                    v
            Internal Read API
```

## Endpoint Summary

| Endpoint | Direction | Purpose | Auth |
|---|---|---|---|
| `GET /partner/customers` | External | Fetch updated customer records | Partner API key |
| `POST /jobs/customer-import` | Internal | Trigger manual import | Admin token |
| `GET /customers/:id` | Internal | Read normalized customer | Session auth |
| `GET /health/customer-import` | Internal | Check last import status | Service token |

## Data Handling Rules

- Treat partner data as untrusted until validated.
- Store the original partner ID for reconciliation.
- Do not overwrite local notes or internal tags from partner payloads.
- Keep failed payload samples for debugging, but redact emails in logs.

## Example Normalization

```json
{
  "partner_id": "cus_18429",
  "email": "casey@example.com",
  "name": "Casey Morgan",
  "status": "active",
  "source_updated_at": "2026-06-01T14:22:00Z"
}
```

## Retry Policy

1. Retry transient HTTP 429 and 5xx responses.
2. Use exponential backoff with jitter.
3. Stop after 5 attempts.
4. Mark the job as failed with the partner response code.
5. Alert only after two consecutive failed scheduled runs.

## Acceptance Checklist

- [ ] Import job can run manually.
- [ ] Scheduled job runs hourly.
- [ ] Duplicate partner records do not create duplicate customers.
- [ ] Invalid records are skipped and counted.
- [ ] Logs include job ID and partner request ID.
- [ ] Dashboard endpoint never exposes raw partner payloads.

## Open Questions

- Should inactive partner customers be hidden or shown with an inactive badge?
- How long should failed payload samples be retained?
- Should the import worker pause automatically after repeated 401 responses?

## Handoff Note

Build the smallest reliable version first. The critical path is validation, idempotency, and visibility into failures.
