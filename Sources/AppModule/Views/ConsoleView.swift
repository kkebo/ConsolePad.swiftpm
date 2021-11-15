import SwiftUI

struct ConsoleView {
    @StateObject var viewModel = ConsoleViewModel()
}

extension ConsoleView: View {
    var body: some View {
        VStack {
            List(self.viewModel.filteredReversedMessages) {
                ConsoleMessageCell(message: $0).flip()
            }
            .listStyle(.plain)
            .flip()
            CommandLine(onSend: self.viewModel.run)
                .padding()
                .background(.regularMaterial)
        }
        .navigationTitle("Console")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                ClearAllButton(action: self.viewModel.clear)
                    .foregroundColor(
                        self.viewModel.messages.isEmpty
                            ? .secondary.opacity(0.5)
                            : .red
                    )
                    .disabled(self.viewModel.messages.isEmpty)
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
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    } else {
                        Image(systemName: "line.3.horizontal.decrease.circle.fill")
                    }
                }
            }
        }
    }
}
