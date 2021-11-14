import SwiftUI

struct ClearAllButton {
    @State var isClearConfirmationPresented = false
    let action: () -> Void
}

extension ClearAllButton: View {
    var body: some View {
        Button(role: .destructive) {
            self.isClearConfirmationPresented = true
        } label: {
            Image(systemName: "trash")
        }
        .confirmationDialog(
            "Clear all logs?",
            isPresented: self.$isClearConfirmationPresented
        ) {
            Button("Clear All", role: .destructive, action: self.action)
        }
    }
}
