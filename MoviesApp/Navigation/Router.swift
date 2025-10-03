import Combine

/// A router that holds navigation path and managers it
///
/// * One router per tab or flow.
final class Router<Route: Hashable>: ObservableObject {
    
    /// Current navigation **path**.
    /// – On iOS 16+ this binds straight to `NavigationStack`’s `path`.
    /// – On iOS 15 only the last element is used (depth 0 or 1), but keeping it an array means we change nothing when the legacy layer disappears.
    @Published var path: [Route] = []
    
    /// Push a new destination onto the stack.
    func push(_ route: Route) {
        path.append(route)
    }
    
    /// Pop the top destination (no-op if already at root).
    func pop() {
        _ = path.popLast()
    }
    
    /// Clear the whole stack and return to the root view.
    func popToRoot() {
        path.removeAll()
    }
}

