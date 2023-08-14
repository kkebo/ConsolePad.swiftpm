import JavaScriptCore
import Observation

@Observable final class ConsoleViewModel {
    var messages = [ConsoleMessage]()
    var logLevel = LogLevel.all
    let historyManager = HistoryManager()

    private let context = JSContext()!

    var filteredReversedMessages: [ConsoleMessage] {
        self.messages
            .lazy
            .filter { self.logLevel.canShow(type: $0.type) }
            .reversed()
    }

    init() {
        self.context.exceptionHandler = { _, exception in
            let string = exception!.toString()!
            self.messages.append(.init(text: string, type: .error))
        }

        let log = { type in
            {
                self.messages.append(.init(text: $0, type: type))
            } as @convention(block) (String) -> Void
        }
        let console = self.context
            .objectForKeyedSubscript("console")!

        [
            "log": MessageType.log,
            "debug": .debug,
            "error": .error,
            "info": .info,
            "table": .log,
            "warn": .warn,
        ]
        .forEach { k, v in console.setObject(log(v), forKeyedSubscript: k) }
        console.setObject(
            self.clear as @convention(block) () -> Void,
            forKeyedSubscript: "clear"
        )
    }

    func run(_ input: String) {
        self.messages.append(.init(text: input, type: .input))

        let result = self.context.evaluateScript(input).toString()!
        self.messages.append(.init(text: result, type: .value))
    }

    func clear() {
        self.messages.removeAll()
    }
}
