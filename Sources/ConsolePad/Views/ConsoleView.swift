import SwiftUI

struct ConsoleView {
    @State private var viewModel = ConsoleViewModel()
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
        .toolbar { self.toolbar }
    }

    @ToolbarContentBuilder private var toolbar: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button(role: .destructive, action: self.viewModel.clear) {
                Image(systemName: "trash")
            }
            .tint(.red)
            .disabled(self.viewModel.messages.isEmpty)
            .keyboardShortcut("K", modifiers: [.command])
        }
        ToolbarItem(placement: .topBarTrailing) {
            Menu {
                Picker(
                    "Log Level",
                    selection: self.$viewModel.logLevel
                ) {
                    ForEach(LogLevel.allCases) {
                        if case .all = $0 {
                            Text(LocalizedStringKey($0.description))
                        } else if let name = $0.systemImageName {
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

struct ConsoleView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ConsoleView()
        }
        .previewPresets()
    }
}
