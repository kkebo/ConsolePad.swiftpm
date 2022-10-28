import Introspect
import SwiftUI

struct CommandLine {
    @State private var isMultiline = false
    @State private var coordinator: Coordinator?
    @ObservedObject private var historyManager: HistoryManager
    @StateObject private var keyCommandBridge = KeyCommandBridge()
    private let onSend: (String) -> Void

    init(
        historyManager: HistoryManager,
        onSend: @escaping (String) -> Void
    ) {
        self.historyManager = historyManager
        self.onSend = onSend
    }

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
                .disableAutocorrection(true)
                .textInputAutocapitalization(.never)
                .font(.body.monospaced())
                .submitLabel(.send)
                .introspectTextField { textField in
                    object_setClass(textField, CommandLineTextField.self)
                    guard let textField = textField as? CommandLineTextField
                    else { return }
                    textField.delegate = self.coordinator
                    textField.keyCommandBridge = self.keyCommandBridge
                    textField.spellCheckingType = .no
                }
                .onReceive(self.keyCommandBridge.publisher) { key in
                    switch key {
                    case .upArrow:
                        self.historyManager.goBackword()
                    case .downArrow:
                        self.historyManager.goForward()
                    default:
                        break
                    }
                }
            } else {
                TextEditor(text: self.historyManager.binding)
                    .disableAutocorrection(true)
                    .textInputAutocapitalization(.never)
                    .font(.body.monospaced())
                    .frame(maxHeight: 100)
                    .introspectTextView { textView in
                        textView.spellCheckingType = .no
                    }
            }
            if self.isMultiline {
                Button("Send") {
                    self.send()
                }
                .disabled(self.historyManager.currentLine.isEmpty)
                .padding(10)
                .hoverEffect()
            }
            Toggle(isOn: self.$isMultiline) {
                Image(systemName: "line.3.horizontal")
            }
            .toggleStyle(.button)
            .hoverEffect()
        }
        .onAppear {
            self.coordinator = .init {
                self.send()
            }
        }
    }
}

fileprivate final class Coordinator: NSObject {
    private let onSend: () -> Void

    init(onSend: @escaping () -> Void) {
        self.onSend = onSend
    }
}

extension Coordinator: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.onSend()
        return false
    }
}

struct CommandLine_Previews: PreviewProvider {
    static var previews: some View {
        CommandLine(historyManager: HistoryManager()) { _ in }
            .previewPresets()
    }
}
