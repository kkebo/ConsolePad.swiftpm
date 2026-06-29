enum LogLevel {
    case debug
    case log
    case info
    case warn
    case error

    var systemImageName: String {
        switch self {
        case .debug: "ladybug"
        case .log: "text.alignleft"
        case .info: "i.circle"
        case .warn: "exclamationmark.triangle"
        case .error: "xmark.octagon"
        }
    }

    var messageType: MessageType {
        switch self {
        case .debug: .debug
        case .log: .log
        case .info: .info
        case .warn: .warn
        case .error: .error
        }
    }
}

extension LogLevel: CaseIterable {}

extension LogLevel: Identifiable {
    var id: Self { self }
}

extension LogLevel: CustomStringConvertible {
    var description: String {
        switch self {
        case .debug: "Debug"
        case .log: "Log"
        case .info: "Info"
        case .warn: "Warning"
        case .error: "Error"
        }
    }
}
