import Combine
import Observation

import struct SwiftUI.KeyEquivalent

@Observable final class KeyCommandBridge {
    private let _publisher = PassthroughSubject<KeyEquivalent, Never>()

    var publisher: AnyPublisher<KeyEquivalent, Never> {
        self._publisher.eraseToAnyPublisher()
    }

    func send(_ key: KeyEquivalent) {
        self._publisher.send(key)
    }
}
