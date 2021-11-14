import Foundation

enum MessageType {
    case input
    case value
    case debug
    case log
    case info
    case warn
    case error
}

struct ConsoleMessage {
    let id = UUID()
    let text: String
    let type: MessageType
}

extension ConsoleMessage: Identifiable {}
