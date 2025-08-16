import Foundation

public struct Feedback {
    public let black: Int
    public let white: Int
}

public final class LocalMastermind {
    private let secret: [Int] 

    public init(secret: [Int]? = nil) {
        if let s = secret, s.count == 4 {
            self.secret = s
        } else {
            self.secret = (0..<4).map { _ in Int.random(in: 1...6) }
        }
    }

    public func revealSecret() -> String {
        secret.map(String.init).joined()
    }

    public func evaluate(guess: String) -> Feedback {
        let g = guess.compactMap { Int(String($0)) }
        var blacks = 0
        var secretCounts = Array(repeating: 0, count: 7) 
        var guessCounts  = Array(repeating: 0, count: 7)

        for i in 0..<4 {
            if g[i] == secret[i] {
                blacks += 1
            } else {
                secretCounts[secret[i]] += 1
                guessCounts[g[i]] += 1
            }
        }
        var whites = 0
        for d in 1...6 {
            whites += min(secretCounts[d], guessCounts[d])
        }
        return Feedback(black: blacks, white: whites)
    }
}
