# Stress Test Document

## Deeply Nested Lists

- Level 1
  - Level 2
    - Level 3
      - Level 4
        - Level 5
          - Level 6

## Large Table

| # | Name | Email | Status | Score | Grade | Notes |
|---|------|-------|--------|-------|-------|-------|
| 1 | Alice Johnson | alice@example.com | Active | 95 | A+ | Top performer |
| 2 | Bob Smith | bob@example.com | Active | 87 | B+ | Improving |
| 3 | Charlie Brown | charlie@example.com | Inactive | 72 | C | Needs review |
| 4 | Diana Prince | diana@example.com | Active | 99 | A+ | Outstanding |
| 5 | Eve Wilson | eve@example.com | Active | 91 | A | Consistent |
| 6 | Frank Castle | frank@example.com | Suspended | 45 | F | Under review |
| 7 | Grace Hopper | grace@example.com | Active | 100 | A+ | Perfect score |
| 8 | Henry Ford | henry@example.com | Active | 88 | B+ | Good progress |

## Multiple Code Blocks

```python
def fibonacci(n):
    if n <= 1:
        return n
    return fibonacci(n-1) + fibonacci(n-2)

# Test it
for i in range(10):
    print(f"F({i}) = {fibonacci(i)}")
```

```javascript
const fetchData = async (url) => {
  try {
    const response = await fetch(url);
    if (!response.ok) throw new Error(`HTTP ${response.status}`);
    return await response.json();
  } catch (error) {
    console.error('Failed:', error.message);
    return null;
  }
};
```

```sql
SELECT u.name, COUNT(o.id) as order_count, SUM(o.total) as revenue
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
WHERE u.created_at > '2024-01-01'
GROUP BY u.id, u.name
HAVING COUNT(o.id) > 5
ORDER BY revenue DESC
LIMIT 20;
```

## Long Paragraph

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Curabitur pretium tincidunt lacus. Nulla gravida orci a odio. Nullam varius, turpis et commodo pharetra, est eros bibendum elit, nec luctus magna felis sollicitudin mauris. Integer in mauris eu nibh euismod gravida. Duis ac tellus et risus vulputate vehicula. Donec lobortis risus a elit.

## Mixed Inline Formatting

This paragraph has **bold text**, *italic text*, ~~strikethrough~~, `inline code`, [a link](https://example.com), and even ***bold italic*** combined. It also has a [link with `code` inside](https://test.com).

## Blockquote Variations

> Simple quote

> Multi-line quote that spans
> across several lines with
> continuation markers.

> ### Heading inside blockquote
>
> With a paragraph below it.
>
> - And a list
> - Inside the quote

## Task List Progress

- [x] Design the architecture
- [x] Implement core renderer
- [x] Add PDF-style view
- [x] Fix dark mode issue
- [x] Security sanitization
- [ ] File watching
- [ ] Export to PDF
- [ ] Preferences window

## Horizontal Rules

Content above

---

Content between rules

***

More content

___

Content below

## Image Reference (won't load but shouldn't crash)

![A test image that doesn't exist](nonexistent-path/image.png)

## HTML Injection Attempts (should be sanitized)

<script>alert('XSS')</script>

<iframe src="https://evil.com"></iframe>

<div onmouseover="alert(1)">Hover me</div>

<img src=x onerror="alert(1)">

## End

That's it! If you can see this rendered properly, the app handles all common Markdown patterns correctly.
