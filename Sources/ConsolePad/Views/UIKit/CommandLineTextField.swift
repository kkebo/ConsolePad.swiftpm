import UIKit

final class CommandLineTextField: UITextField {
    weak var keyCommandBridge: KeyCommandBridge?

    /// key commands.
    override var keyCommands: [UIKeyCommand]? {
        let commands = [
            UIKeyCommand(
                input: "p",
                modifierFlags: .control,
                action: #selector(self.handleKeyCommand)
            ),
            UIKeyCommand(
                input: UIKeyCommand.inputUpArrow,
                modifierFlags: [],
                action: #selector(self.handleKeyCommand)
            ),
            UIKeyCommand(
                input: "n",
                modifierFlags: .control,
                action: #selector(self.handleKeyCommand)
            ),
            UIKeyCommand(
                input: UIKeyCommand.inputDownArrow,
                modifierFlags: [],
                action: #selector(self.handleKeyCommand)
            ),
        ]

        for command in commands {
            command.wantsPriorityOverSystemBehavior = true
        }

        return commands
    }

    @objc func handleKeyCommand(sender: UIKeyCommand) {
        switch (sender.input, sender.modifierFlags) {
        case ("p", .control), (UIKeyCommand.inputUpArrow, []):
            self.keyCommandBridge?.send(.upArrow)
        case ("n", .control), (UIKeyCommand.inputDownArrow, []):
            self.keyCommandBridge?.send(.downArrow)
        default:
            break
        }
    }
}
