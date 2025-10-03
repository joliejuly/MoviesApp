import SwiftUI

struct CommonNavigationView<Route: Hashable, Root: View, Destination: View>: View {
    
    @ObservedObject var router: Router<Route>
    /// Root screen of the flow
    private let root: () -> Root
    /// Factory that converts a Route into a destination view
    private let destination: (Route) -> Destination
    
    init(
        router: Router<Route>,
        @ViewBuilder root: @escaping () -> Root,
        @ViewBuilder destination: @escaping (Route) -> Destination
    ) {
        self.router = router
        self.root = root
        self.destination = destination
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
                        root: root,
                        destination: destination
                    )
                }
                .navigationViewStyle(.stack)
            }
        }
    }
}
