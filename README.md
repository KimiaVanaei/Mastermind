# Mastermind (Swift Implementation)

A Swift-based implementation of the classic **Mastermind** game, supporting both local gameplay and API integration for remote play. This project uses a modular architecture separating CLI interface, game logic, models, and networking.

---

## 📂 Project Structure
```
Sources/
├── CLI/
│   └── MainGame.swift              # Entry point for the CLI game loop
├── Core/
│   ├── GameLogic/
│   │   ├── GuessValidator.swift    # Validates player guesses for correctness and format
│   │   └── LocalMastermind.swift   # Core local game logic: secret code generation, feedback
│   ├── IO/
│   │   └── ConsoleIO.swift         # Handles input/output for console-based gameplay
│   ├── Models/
│   │   └── APIModels.swift         # Data models for API-based game sessions
│   └── Networking/
│       ├── APIClient.swift         # Handles HTTP requests to a Mastermind API
│       └── Errors.swift            # Custom error definitions for networking
```
---

## 🎯 Features

- **Local Game Mode**  
  - Generates a random secret code.
  - Validates guesses and provides feedback (correct position & correct color).
  - Tracks win/lose conditions.
  
- **Console UI**  
  - User-friendly command-line interface for interactive play.
  
- **Networking Ready**  
  - `APIClient.swift` provides the foundation for integrating with a [remote Mastermind API](https://mastermind.darkube.app/docs/index.html).
  - API models (`APIModels.swift`) for easy request/response handling.
  
- **Error Handling**  
  - Custom error types for networking failures.

---

## 🛠 Requirements

- **Swift** 5.5 or later

---

## 🚀 Running the Game

1. Clone the repository.
   ```bash
   git clone https://github.com/KimiaVanaei/Mastermind.git
2. Navigate to the project directory.
   ```bash
   cd Mastermind/
3. Compile and run:
   ```bash
   swift build
   swift run
4. Follow on-screen instructions to start guessing.
