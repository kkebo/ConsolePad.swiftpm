enum LogLevel {
    case all
    case debug
    case log
    case info
    case warn
    case error

    var systemImageName: String? {
        switch self {
        case .all: return nil
        case .debug: return nil
        case .log: return nil
        case .info: return "i.circle"
        case .warn: return "exclamationmark.triangle"
        case .error: return "xmark.circle"
        }
    }

    func canShow(type: MessageType) -> Bool {
        guard type != .input && type != .value else { return true }
        switch self {
        case .all:
            return true
        case .debug:
            return [MessageType.debug, .log, .info, .warn, .error]
                .contains(type)
        case .log:
            return [MessageType.log, .info, .warn, .error].contains(type)
        case .info:
            return [MessageType.info, .warn, .error].contains(type)
        case .warn:
            return [MessageType.warn, .error].contains(type)
        case .error:
            return [MessageType.error].contains(type)
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
        case .all: return "All"
        case .debug: return "Debug"
        case .log: return "Log"
        case .info: return "Info"
        case .warn: return "Warning"
        case .error: return "Error"
        }
    }
}
