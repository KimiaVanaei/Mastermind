import Foundation

public struct CreateGameResponse: Codable {
    public let game_id: String
}

public struct GuessRequest: Codable {
    public let game_id: String
    public let guess: String
}

public struct GuessResponse: Codable {
    public let black: Int
    public let white: Int
}

public struct ErrorResponse: Codable, Error {
    public let error: String
}
