import Foundation
import FoundationNetworking

public final class APIClient {
    private let baseURL = URL(string: "https://mastermind.darkube.app")!
    private let session: URLSession

    public init(session: URLSession = .shared) {
        self.session = session
    }

    public func createGame() async throws -> String {
        let url = baseURL.appendingPathComponent("/game")
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Accept")

        do {
            let (data, resp) = try await session.data(for: req)
            guard let http = resp as? HTTPURLResponse else { throw APIClientError.invalidStatus(-1) }
            if http.statusCode == 200 {
                if let decoded = try? JSONDecoder().decode(CreateGameResponse.self, from: data) {
                    return decoded.game_id
                } else {
                    throw APIClientError.decoding
                }
            } else {
                if let err = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                    throw APIClientError.server(err.error)
                }
                throw APIClientError.invalidStatus(http.statusCode)
            }
        } catch {
            throw APIClientError.transport(error)
        }
    }

    public func submitGuess(gameId: String, guess: String) async throws -> GuessResponse {
        let url = baseURL.appendingPathComponent("/guess")
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue("application/json", forHTTPHeaderField: "Accept")

        let body = GuessRequest(game_id: gameId, guess: guess)
        req.httpBody = try JSONEncoder().encode(body)

        do {
            let (data, resp) = try await session.data(for: req)
            guard let http = resp as? HTTPURLResponse else { throw APIClientError.invalidStatus(-1) }
            if http.statusCode == 200 {
                if let decoded = try? JSONDecoder().decode(GuessResponse.self, from: data) {
                    return decoded
                } else {
                    throw APIClientError.decoding
                }
            } else {
                if let err = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                    throw APIClientError.server(err.error)
                }
                throw APIClientError.invalidStatus(http.statusCode)
            }
        } catch {
            throw APIClientError.transport(error)
        }
    }

    public func deleteGame(gameId: String) async throws {
        let url = baseURL.appendingPathComponent("/game/\(gameId)")
        var req = URLRequest(url: url)
        req.httpMethod = "DELETE"

        do {
            let (_, resp) = try await session.data(for: req)
            guard let http = resp as? HTTPURLResponse else { throw APIClientError.invalidStatus(-1) }
            switch http.statusCode {
            case 204: return
            case 404: throw APIClientError.server("Game Not Found")
            default: throw APIClientError.invalidStatus(http.statusCode)
            }
        } catch {
            throw APIClientError.transport(error)
        }
    }
}
