import Introspect
import SwiftUI

struct CommandLine {
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
            TextField(
                "Input here...",
                text: self.historyManager.binding,
                axis: .vertical
            )
            .lineLimit(10)
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            .fontDesign(.monospaced)
            .submitLabel(.send)
            .introspectTextField { textField in
                object_setClass(textField, CommandLineTextField.self)
                guard let textField = textField as? CommandLineTextField
                else { return }
                textField.delegate = self.coordinator
                textField.keyCommandBridge = self.keyCommandBridge
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
