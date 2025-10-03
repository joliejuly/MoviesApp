import SwiftUI

struct CommonNavigationView<Route: Hashable, Root: View, Destination: View>: View {
    
    @ObservedObject var router: Router<Route>
    /// Factory that converts a Route into a destination view
    private let destination: (Route) -> Destination
    /// Root screen of the flow
    private let root: () -> Root
    
    init(
        router: Router<Route>,
        @ViewBuilder destination: @escaping (Route) -> Destination,
        @ViewBuilder root: @escaping () -> Root
    ) {
        self.router = router
        self.destination = destination
        self.root = root
    }
    
    var body: some View {
        Group {
            if #available(iOS 16, *) {
                NavigationStack(path: $router.path) {
                    root()
                        .navigationDestination(for: Route.self, destination: destination)
                }
            } else {
                NavigationView {
                    LegacyRootWrapper(
                        router: router,
                        destination: destination,
                        root: root
                    )
                }
                .navigationViewStyle(.stack)
            }
        }
    }
}
