import SwiftUI

@MainActor
struct ConsoleView {
    @Environment(\.horizontalSizeClass) private var hSizeClass
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
            Toggle("Log Level", systemImage: "line.3.horizontal.decrease", isOn: self.$viewModel.isFiltered)
        }
        if self.viewModel.isFiltered {
            ToolbarItem(placement: .subtitle) {
                // FIXME: The button width may become too long.
                Button("Filtered By: \(self.viewModel.filter.map(\.description), format: .list(type: .and))") {
                    self.viewModel.isFilterVisible = true
                }
                .tint(.accentColor)
                // FIXME: Remove the hover effect.
                .popover(isPresented: self.$viewModel.isFilterVisible) {
                    self.filterView
                }
            }
        }
    }

    private var filterView: some View {
        NavigationStack {
            List {
                Section("Log Levels") {
                    ForEach(LogLevel.allCases) { level in
                        Button {
                            self.viewModel.toggleFilter(level)
                        } label: {
                            HStack {
                                Label(level.description, systemImage: level.systemImageName)
                                if self.viewModel.filter.contains(level) {
                                    Spacer()
                                    Image(systemName: "checkmark")
                                        .tint(.accentColor)
                                }
                            }
                        }
                        .tint(.primary)
                    }
                }
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done", systemImage: "checkmark", role: .confirm) {
                        self.viewModel.isFilterVisible = false
                    }
                }
            }
        }
        .frame(
            width: self.hSizeClass == .regular ? 420 : nil,
            height: self.hSizeClass == .regular ? 600 : nil
        )
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
