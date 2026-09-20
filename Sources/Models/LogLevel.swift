enum LogLevel {
    case all
    case log
    case info
    case warn
    case error

    var systemImageName: String? {
        switch self {
        case .all: nil
        case .log: nil
        case .info: "i.circle"
        case .warn: "exclamationmark.triangle"
        case .error: "xmark.circle"
        }
    }

    func canShow(type: MessageType) -> Bool {
        guard type != .input && type != .value else { return true }
        return switch self {
        case .all: true
        case .log: [MessageType.log, .info, .warn, .error].contains(type)
        case .info: [MessageType.info, .warn, .error].contains(type)
        case .warn: [MessageType.warn, .error].contains(type)
        case .error: [MessageType.error].contains(type)
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
        case .all: "All"
        case .log: "Log"
        case .info: "Info"
        case .warn: "Warning"
        case .error: "Error"
        }
    }
}
