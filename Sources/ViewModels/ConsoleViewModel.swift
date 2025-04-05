import JavaScriptCore
import Observation

@MainActor
@Observable
final class ConsoleViewModel {
    var messages: [ConsoleMessage] = []
    var logLevel = LogLevel.all
    let historyManager = HistoryManager()

    // swift-format-ignore: NeverForceUnwrap
    private let context = JSContext()!

    var filteredReversedMessages: [ConsoleMessage] {
        self.messages
            .lazy
            .filter { self.logLevel.canShow(type: $0.type) }
            .reversed()
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
            "debug": .debug,
            "error": .error,
            "info": .info,
            "table": .log,
            "warn": .warn,
        ] {
            console.setObject(log(v), forKeyedSubscript: k)
        }
        console.setObject(
            self.clear as @convention(block) () -> Void,
            forKeyedSubscript: "clear"
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
}
