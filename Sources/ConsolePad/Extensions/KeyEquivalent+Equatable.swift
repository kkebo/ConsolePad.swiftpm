import SwiftUI

extension KeyEquivalent: Equatable {
    /// Returns a Boolean value indicating whether two values are equal.
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.character == rhs.character
    }
}
