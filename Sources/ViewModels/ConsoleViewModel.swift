private import JavaScriptCore
import Observation

@MainActor
@Observable
final class ConsoleViewModel {
    var messages: [ConsoleMessage] = []
    var isFilterVisible = false
    var filter = Set(LogLevel.allCases)
    let historyManager = HistoryManager()

    // swift-format-ignore: NeverForceUnwrap
    private let context = JSContext()!

    var filteredReversedMessages: [ConsoleMessage] {
        let whitelist = self.filter.map(\.messageType) + [.input, .value]
        return self.messages
            .lazy
            .filter { whitelist.contains($0.type) }
            .reversed()
    }

    var filterLabel: String {
        switch self.filter {
        case [.log]: "Logs Only"
        case [.info]: "Info Only"
        case [.warn]: "Warnings Only"
        case [.error]: "Errors Only"
        case Set(LogLevel.allCases): "All Levels"
        case _: "Custom Levels"
        }
    }

    init() {
        self.context.exceptionHandler = { _, exception in
            // swift-format-ignore: NeverForceUnwrap
            let string = exception!.toString()!
            self.messages.append(.init(text: string, type: .error))
        }

        let log = { type in
            {
                self.messages.append(.init(text: $0, type: type))
            } as @convention(block) (String) -> Void
        }
        // swift-format-ignore: NeverForceUnwrap
        let console = self.context
            .objectForKeyedSubscript("console")!

        for (k, v) in [
            "log": MessageType.log,
            "debug": .log,
            "error": .error,
            "info": .info,
            "warn": .warn,
        ] {
            console.setObject(log(v), forKeyedSubscript: k)
        }
        console.setObject(
            self.clear as @convention(block) () -> Void,
            forKeyedSubscript: "clear",
        )
    }

    func run(_ input: String) {
        self.messages.append(.init(text: input, type: .input))

        // swift-format-ignore: NeverForceUnwrap
        let result = self.context.evaluateScript(input).toString()!
        self.messages.append(.init(text: result, type: .value))
    }

    func clear() {
        self.messages.removeAll()
    }

    func toggleFilter(_ level: LogLevel) {
        if self.filter.contains(level) {
            self.filter.remove(level)
        } else {
            self.filter.insert(level)
        }
    }
}
