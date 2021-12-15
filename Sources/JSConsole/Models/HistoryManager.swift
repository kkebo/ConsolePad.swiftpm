import SwiftUI

final class HistoryManager {
    @Published private var index = 0
    @Published private var buffer = [""]
    private var history = [String]()

    var binding: Binding<String> {
        .init(
            get: { self.buffer[self.index] },
            set: { self.buffer[self.index] = $0 }
        )
    }

    var currentLine: String {
        self.buffer[self.index]
    }

    func commit() {
        self.history.append(self.currentLine)

        // Prepare for the next input
        self.buffer = self.history
        self.buffer.append("")
        self.index = self.buffer.endIndex - 1
    }

    func goBackword() {
        if self.index < self.history.endIndex,
            self.history[self.index] != self.currentLine
        {
            self.history[self.index] = self.currentLine
        }

        self.index = max(self.buffer.startIndex, self.index - 1)
    }

    func goForward() {
        if self.index < self.history.endIndex,
            self.history[self.index] != self.currentLine
        {
            self.history[self.index] = self.currentLine
        }

        self.index = min(self.buffer.endIndex - 1, self.index + 1)
    }
}

extension HistoryManager: ObservableObject {}
