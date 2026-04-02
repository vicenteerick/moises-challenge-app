# Moises Challenge App

iOS music library explorer built with SwiftUI, modular Swift packages, and CarPlay support for the in-car Now Playing experience.

## How to run

1. Open the **workspace** (not the `.xcodeproj` alone):  
   `moises-challenge.xcworkspace`  
   The workspace pulls in the main app target and the local Swift packages (`MCAudioPlayer`, `MCDependencyContainer`, `MCDesignSystem`, `MCNetwork`).

2. Select the **MoisesChallengeApp** scheme and a simulator or device (iOS **18**+).

3. Build and run (**⌘R**).  
   Dependencies are registered at launch in `AppSetup.registerDependencies()` (network client, library repository, audio `Player`).

4. **Unit tests**: choose the **MoisesChallengeApp** (or package) scheme and run tests (**⌘U**).  
   **UI tests** live in the `MoisesChallengeAppUITests` target.

5. **CarPlay**: the app declares a `CPTemplateApplicationScene` in `Info.plist` with `CarPlaySceneDelegate`. To run CarPlay, use Xcode’s CarPlay simulator or a physical CarPlay environment; playback uses **audio** background mode.

## Tech stack

| Area | Technology |
|------|------------|
| UI | **SwiftUI** (`@Observable` view models, navigation stacks) |
| Tests | **Swift Testing** (`import Testing`, `@Test`, `#expect`) in the app and package test targets |
| Audio | **AVFoundation**, **MediaPlayer** (Now Playing / remote commands) |
| In-car | **CarPlay** (`CPNowPlayingTemplate`, list templates, `CarPlaySceneDelegate`) |
| Networking | Custom **MCNetwork** package (`URLSession`-based client) |
| Playback abstraction | **MCAudioPlayer** (`Player` protocol, `AudioPlayer`, progress streams) |
| DI | **MCDependencyContainer** (`DependencyContainer`, `@Dependencies`, task-local overrides) |
| Visual design | **MCDesignSystem** (tokens, typography, icons, shared components) |

Swift tools version for packages: **6.2**. Minimum platform: **iOS 18**.

## Project structure and module responsibilities

### `MoisesChallengeApp/` (application target)

- **`AppSetup/`** — Registers production dependencies (`NetworkClient`, `NetworkLibraryRepository`, `Player`) when the app (and CarPlay scene) starts.
- **`CarPlay/`** — `CarPlaySceneDelegate` connects the CarPlay scene; `CarPlayTemplateManager` observes Now Playing, loads album data via `NetworkLibraryRepository`, and pushes `CPListTemplate` for track lists.
- **`Repository/Library/`** — Data access: endpoints, DTOs (`LibraryResponse`), `LibraryRepository` implementation, and **DEBUG** test doubles (`LibraryRepositoryMock`, `LibraryResponse+Mock`).
- **`Scene/Library/`** — Feature modules by screen:
  - **`Songs/`** — Search/list UI, `SongsViewModel`, `Song` / `Artwork` models.
  - **`Album/`** — Album UI, `AlbumViewModel`, `Album` model.
  - **`SongPlayer/`** — Player UI, `SongPlayerViewModel`, slider and controls.
  - **`Menu/`**, **`Navigation/`** — Shared navigation and menus.
- **`ViewInfrastructure/`** — Reusable UI helpers (e.g. `ViewState`, debounced modifiers).

### Swift packages (added to the workspace)

- **`MCNetwork`** — HTTP client, request building, decoding; includes **`MCNetworkTests`** with stubs/mocks (e.g. `URLSessionMock`, `EndpointMock`).
- **`MCAudioPlayer`** — Playback stack and Now Playing integration; ships **`PlayerMock`** for tests and previews; **`MCAudioPlayerTests`** for the module.
- **`MCDependencyContainer`** — Service locator + `@Dependencies` property wrapper; **`withDependency`** (DEBUG) swaps the task-local `DependencyContainer` for isolated tests/previews; **`MCDependencyContainerTests`**.
- **`MCDesignSystem`** — Design tokens and SwiftUI building blocks; **`MCDesignSystemTests`**.

## Architecture: MVVM

- **Model** — Types such as `Song`, `Album`, and repository DTOs (`LibraryResponse`) represent domain/API data.
- **View** — SwiftUI views (`SongsView`, `AlbumView`, `SongPlayerView`, …) render state and forward user actions; they stay thin and depend on view models or injected callbacks.
- **ViewModel** — Types like `SongsViewModel`, `AlbumViewModel`, and `SongPlayerViewModel` are `@MainActor` and use **`@Observable`** (with `@ObservationIgnored` on injected services). They call repositories or `Player` through **`@Dependencies`**, map results into **`ViewState`** (loading / content / empty / error), and expose methods for the views to call.

CarPlay’s `CarPlayTemplateManager` acts as a **presentation coordinator** for the CarPlay UI: it uses the same repository abstraction as the rest of the app rather than duplicating networking details.

## Unit tests and mocks

### App target (`MoisesChallengeAppTests`)

Tests are grouped to mirror the feature tree, under **`Scene/Library/ViewModel/`**:

- `SongsViewModelTests.swift`
- `AlbumViewModelTests.swift`
- `SongPlayerViewModelTests.swift`

They use **Swift Testing** and **`withDependency(type:dependency:)`** to register a fresh `DependencyContainer` for each test so view models resolve **mock** implementations instead of production services.

### Package targets

Each package keeps tests next to its code (e.g. `MCNetwork/Tests/MCNetworkTests/`) with focused mocks/stubs for that layer.

### Same mocks for previews

Preview providers use the **same doubles** as the unit tests, wrapped in `withDependency`:

- **`LibraryRepositoryMock`** — Implements `NetworkLibraryRepository` (DEBUG in the app). Used in **`#Preview`** for `SongsView`, `AlbumView`, `LibraryNavigationView`, and in **`SongsViewModelTests` / `AlbumViewModelTests`**.
- **`PlayerMock`** — Lives in **MCAudioPlayer** and implements `Player`. Used in **`SongPlayerViewModelTests`** and in **`SongPlayerView`’s `#Preview`** (together with `Song.mock` sample data).

That way, canvas previews and tests stay aligned with the same fake behavior and avoid hitting the network or real audio hardware.
