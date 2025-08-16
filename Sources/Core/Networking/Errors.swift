import FoundationNetworking
import Foundation

public enum APIClientError: Error, LocalizedError {
    case invalidURL
    case invalidStatus(Int)
    case decoding
    case server(String)
    case transport(Error)

    public var errorDescription: String? {
        switch self {
            case .invalidURL: return "The server URL is invalid."
            case .invalidStatus(let code): return "Invalid status code from the server: \(code)"
            case .decoding: return "Unable to process the server response."
            case .server(let msg): return "Server error: \(msg)"
            case .transport(let e): return "Network communication error: \(e.localizedDescription)"
        }
    }
}