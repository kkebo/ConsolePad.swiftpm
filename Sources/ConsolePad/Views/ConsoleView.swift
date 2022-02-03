import SwiftUI

struct ConsoleView {
    @StateObject var viewModel = ConsoleViewModel()
}

extension ConsoleView: View {
    var body: some View {
        List(self.viewModel.filteredReversedMessages) {
            ConsoleMessageCell(message: $0).flip()
        }
        .textSelection(.enabled)
        .listStyle(.plain)
        .flip()
        .safeAreaInset(edge: .bottom) {
            CommandLine(
                historyManager: self.viewModel.historyManager,
                onSend: self.viewModel.run
            )
            .padding()
            .background(.regularMaterial)
        }
        .navigationTitle("Console")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(role: .destructive, action: self.viewModel.clear) {
                    Image(systemName: "trash")
                }
                .foregroundColor(
                    self.viewModel.messages.isEmpty
                        ? .secondary.opacity(0.5)
                        : .red
                )
                .disabled(self.viewModel.messages.isEmpty)
                .keyboardShortcut("K", modifiers: [.command])
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Picker(
                        "Log Level",
                        selection: self.$viewModel.logLevel
                    ) {
                        ForEach(LogLevel.allCases) {
                            if let name = $0.systemImageName {
                                Label($0.description, systemImage: name)
                            } else {
                                Text($0.description)
                            }
                        }
                    }
                } label: {
                    if self.viewModel.logLevel == .all {
                        Label(
                            self.viewModel.logLevel.description,
                            systemImage: "line.3.horizontal.decrease.circle"
                        )
                    } else {
                        Label(
                            self.viewModel.logLevel.description,
                            systemImage: "line.3.horizontal.decrease.circle.fill"
                        )
                    }
                }
                .labelStyle(.titleAndIcon)
            }
        }
    }
}

struct ConsoleView_Previews: PreviewProvider {
    static var previews: some View {
        ConsoleView().previewPresets()
    }
}
