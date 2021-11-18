import SwiftUI

struct CommandLine {
    @State var input = ""
    @State var isMultiline = false
    @FocusState var isTextFieldFocused

    let onSend: (String) -> Void 
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
                .focused(self.$isTextFieldFocused)
                .submitLabel(.send)
                .onSubmit {
                    self.isTextFieldFocused = true
                    self.onSend(self.input)
                    self.input = ""
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
    }
}

struct CommandLine_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            CommandLine { _ in }
        }
        .previewPresets()
    }
}
