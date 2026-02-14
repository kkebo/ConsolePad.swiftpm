import SwiftUI

struct CommandLine {
    @State private var isMultiline = false
    @FocusState private var isFocused: Bool
    private let historyManager: HistoryManager
    private let onSend: (String) -> Void

    init(
        historyManager: HistoryManager,
        onSend: @escaping (String) -> Void
    ) {
        self.historyManager = historyManager
        self.onSend = onSend
    }

    @MainActor
    private func send() {
        let input = self.historyManager.currentLine
        guard !input.isEmpty else { return }

        self.historyManager.commit()
        self.onSend(input)
    }
}

extension CommandLine: View {
    var body: some View {
        HStack {
            Image(systemName: "chevron.right")
            if !self.isMultiline {
                TextField(
                    "Input here...",
                    text: self.historyManager.binding
                )
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .fontDesign(.monospaced)
                .submitLabel(.send)
                .onKeyPress(.return) {
                    self.send()
                    return .handled
                }
                .onKeyPress(.upArrow) {
                    self.historyManager.goBackword()
                    return .handled
                }
                .onKeyPress(keys: ["p"]) { press in
                    if press.modifiers.contains(.control) {
                        self.historyManager.goBackword()
                        return .handled
                    } else {
                        return .ignored
                    }
                }
                .onKeyPress(.downArrow) {
                    self.historyManager.goForward()
                    return .handled
                }
                .onKeyPress(keys: ["n"]) { press in
                    if press.modifiers.contains(.control) {
                        self.historyManager.goForward()
                        return .handled
                    } else {
                        return .ignored
                    }
                }
                .onSubmit {
                    self.send()
                }
                .focused(self.$isFocused)
            } else {
                TextEditor(text: self.historyManager.binding)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .fontDesign(.monospaced)
                    .frame(maxHeight: 100)
                    .scrollContentBackground(.hidden)
                    .focused(self.$isFocused)
            }
            if self.isMultiline {
                Button("Send") {
                    self.send()
                }
                .padding(10)
                .hoverEffect()
                .disabled(self.historyManager.currentLine.isEmpty)
            }
            Toggle(isOn: self.$isMultiline) {
                Image(systemName: "line.3.horizontal")
            }
            .toggleStyle(.button)
            .hoverEffect()
        }
        .onAppear {
            if !Bundle.main.isPlaygroundPreview {
                self.isFocused = true
            }
        }
    }
}

struct CommandLine_Previews: PreviewProvider {
    static var previews: some View {
        CommandLine(historyManager: HistoryManager()) { _ in }
            .previewPresets()
    }
}
