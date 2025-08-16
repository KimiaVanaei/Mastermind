import Foundation

public enum GameMode {
    case local
    case remote
}

public final class ConsoleIO {
    public init() {}

    public func printHeader() {
        print("""
        ---------------------------------------------------------
        🎯 Mastermind Game (Terminal Version)
            Rules: Each guess must be 4 digits from 1 to 6
                    You can type 'exit' to end the game anytime.
        ---------------------------------------------------------
        """)
    }

    public func prompt(_ text: String) -> String? {
        print(text, terminator: " ")
        return readLine()
    }

    public func printError(_ message: String) {
        fputs("⚠️  \(message)\n", stderr)
    }

    public func printInfo(_ message: String) {
        print(message)
    }

    public func shouldExit(_ input: String?) -> Bool {
        guard let s = input?.trimmingCharacters(in: .whitespacesAndNewlines) else { return false }
        return s.lowercased() == "exit"
    }
}
