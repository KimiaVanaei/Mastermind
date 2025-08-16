import Foundation

public enum GuessValidator {
    public static func isValid(_ guess: String) -> Bool {
        // Check if the string has exactly 4 characters
        guard guess.count == 4 else { return false }

        // Check if all characters are digits between 1 and 6
        guard guess.allSatisfy({ $0 >= "1" && $0 <= "6" }) else { return false }

        // Check for unique digits 
        let uniqueDigits = Set(guess)
        return uniqueDigits.count == guess.count
    }
}