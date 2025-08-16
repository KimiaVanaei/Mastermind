import Foundation

@main
struct Main {
    static func main() async {
        let io = ConsoleIO()
        io.printHeader()

        // Choose game mode
        let mode: GameMode
        if let modeInput = io.prompt("""
        Choose game mode:
        1️⃣  Local (Offline)
        2️⃣  Connect to server (Requires Internet Connection)\n
        """) {
            let trimmed = modeInput.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            if trimmed == "exit" {
                io.printInfo("Goodbye! 👋")
                return
            } else if trimmed == "2" {
                mode = .remote
            } else {
                mode = .local
            }
        } else {
            // if there's no input, default to local mode
            mode = .local
        }

        if mode == .local {
            await runLocal(io: io)
        } else {
            await runRemote(io: io)
        }
    }

    static func runLocal(io: ConsoleIO) async {
        io.printInfo("🔐 A secret code has been chosen. Let's start!")
        let engine = LocalMastermind()
        // io.printInfo("DEBUG secret: \(engine.revealSecret())")

        gameLoop: while true {
            let input = io.prompt("Enter your guess:")
            if io.shouldExit(input) { io.printInfo("Goodbye! 👋"); break }

            guard let guess = input?.trimmingCharacters(in: .whitespacesAndNewlines),
                  GuessValidator.isValid(guess) else {
                io.printError("Invalid input. Must be exactly 4 unique digits between 1 and 6.")
                continue
            }

            let fb = engine.evaluate(guess: guess)
            let b = String(repeating: "B", count: fb.black)
            let w = String(repeating: "W", count: fb.white)
            io.printInfo("Response: \(b)\(w)")
            if fb.black == 4 {
                io.printInfo("🎉 Congratulations! You guessed the code correctly.")
                break gameLoop
            }
        }
    }

    static func runRemote(io: ConsoleIO) async {
        let api = APIClient()
        io.printInfo("🌐 Connecting to server...")
        var gameId: String = ""
        do {
            gameId = try await api.createGame()
            io.printInfo("✅ New game created. Game ID: \(gameId)")
        } catch {
            io.printError("Unable to create game on the server. \(error.localizedDescription)")
            return
        }

        remoteLoop: while true {
            let input = io.prompt("Enter your guess:")
            if io.shouldExit(input) { io.printInfo("Goodbye! 👋"); break }

            guard let guess = input?.trimmingCharacters(in: .whitespacesAndNewlines),
                GuessValidator.isValid(guess) else {
                io.printError("Invalid input. Must be exactly 4 unique digits between 1 and 6.")
                continue
            }

            do {
                let resp = try await api.submitGuess(gameId: gameId, guess: guess)
                let b = String(repeating: "B", count: resp.black)
                let w = String(repeating: "W", count: resp.white)
                io.printInfo("Server response: \(b)\(w)")
                if resp.black == 4 {
                    io.printInfo("🎉 You won! You guessed the code correctly.")
                    break remoteLoop
                }
            } catch let apiErr as APIClientError {
                io.printError(apiErr.localizedDescription)
            } catch {
                io.printError("Unknown error: \(error.localizedDescription)")
            }
        }

        // cleanup after loop finishes
        do {
            try await api.deleteGame(gameId: gameId)
            io.printInfo("🧹 Game on server was deleted.")
        } catch {
            io.printError("Unable to delete the game: \(error.localizedDescription)")
        }
}

}