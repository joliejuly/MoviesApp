import SwiftUI

/// iOS-15 navigation helper
@available(iOS, introduced: 15, deprecated: 16)
private struct LegacyRootWrapper<Route: Hashable, Root: View, Destination: View>: View {
    
    @ObservedObject var router: Router<Route>
    let root: () -> Root
    let destination: (Route) -> Destination
    
    var body: some View {
        root()
            .background(
                NavigationLink(
                    destination: router.path.last.map(destination),
                    isActive: Binding(
                        get: { router.path.isEmpty == false },
                        set: { $0 ? () : router.pop() })
                ) {
                    EmptyView()
                }
                .hidden()
            )
    }
}
