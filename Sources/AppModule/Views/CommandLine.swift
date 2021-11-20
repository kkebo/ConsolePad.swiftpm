import Introspect
import SwiftUI

struct CommandLine {
    @State var input = ""
    @State var isMultiline = false
    @State var coordinator: Self.Coordinator?
    let onSend: (String) -> Void

    init(onSend: @escaping (String) -> Void) {
        self.onSend = onSend
    }
}

extension CommandLine: View {
    var body: some View {
        HStack {
            Image(systemName: "chevron.right")
            if !self.isMultiline {
                TextField(
                    "Input here...",
                    text: self.$input 
                )
                .disableAutocorrection(true)
                .font(.body.monospaced())
                .submitLabel(.send)
                .introspectTextField { textField in
                    textField.delegate = self.coordinator
                }
            } else {
                TextEditor(text: self.$input)
                    .disableAutocorrection(true)
                    .font(.body.monospaced())
                    .frame(maxHeight: 100)
            }
            if self.isMultiline {
                Button("Send") {
                    self.onSend(self.input)
                    self.input = ""
                }
                .disabled(self.input.isEmpty)
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
            self.coordinator = Self.Coordinator(
                input: self.$input,
                onSend: self.onSend
            )
        }
    }
}

extension CommandLine {
    final class Coordinator: NSObject {
        @Binding var input: String
        let onSend: (String) -> Void

        init(input: Binding<String>, onSend: @escaping (String) -> Void) {
            self._input = input
            self.onSend = onSend
        }
    }
}

extension CommandLine.Coordinator: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.onSend(self.input)
        self.input = ""
        return false
    }
}

struct CommandLine_Previews: PreviewProvider {
    static var previews: some View {
        CommandLine { _ in }
            .previewPresets()
    }
}
