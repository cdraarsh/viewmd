import AppKit
import SwiftUI
import UniformTypeIdentifiers

private enum FeedbackLinks {
    static let feedback = URL(string: "https://github.com/cdraarsh/viewmd/issues/new?template=feedback.yml")!
    static let bugReport = URL(string: "https://github.com/cdraarsh/viewmd/issues/new?template=bug_report.yml")!
}

@main
struct ViewMDApp: App {
    var body: some Scene {
        DocumentGroup(viewing: MarkdownDocument.self) { file in
            ContentView(document: file.document, sourceURL: file.fileURL)
        }
        .defaultSize(width: 850, height: 1100)
        .commands {
            CommandGroup(after: .help) {
                Button("Send Public Beta Feedback") {
                    NSWorkspace.shared.open(FeedbackLinks.feedback)
                }
                Button("Report a Bug") {
                    NSWorkspace.shared.open(FeedbackLinks.bugReport)
                }
            }
        }
    }
}
