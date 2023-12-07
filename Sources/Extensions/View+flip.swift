import SwiftUI

extension View {
    func flip() -> some View {
        self.rotationEffect(.radians(.pi))
            .scaleEffect(x: -1, y: 1, anchor: .center)
    }
}
