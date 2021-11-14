import SwiftUI

struct ConsoleMessageCell {
    let message: ConsoleMessage
}

extension ConsoleMessageCell: View {
    var body: some View {
        switch self.message.type {
        case .input:
            Label(self.message.text, systemImage: "chevron.right")
                .font(.body.monospaced())
                .foregroundColor(.primary)
        case .value:
            Label(self.message.text, systemImage: "arrow.left")
                .font(.body.monospaced())
                .foregroundColor(.gray)
        case .debug, .log:
            Text(self.message.text)
                .font(.body.monospaced())
        case .info:
            Label {
                Text(self.message.text)
                    .font(.body.monospaced())
            } icon: {
                Image(systemName: "i.circle.fill")
                    .foregroundColor(.blue)
            }
        case .warn:
            Label {
                Text(self.message.text)
                    .font(.body.monospaced())
            } icon: {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.yellow)
            }
            .listRowBackground(Color.yellow.opacity(0.2))
        case .error:
            Label(self.message.text, systemImage: "xmark.circle.fill")
                .font(.body.monospaced())
                .foregroundColor(.red)
                .listRowBackground(Color.red.opacity(0.2))
        }
    }
}
