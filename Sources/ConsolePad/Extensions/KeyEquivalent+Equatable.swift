import SwiftUI

extension KeyEquivalent: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.character == rhs.character
    }
}
