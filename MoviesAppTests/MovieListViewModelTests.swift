import XCTest
import Dependencies
@testable import MoviesApp

@MainActor
final class MovieListViewModelTests: XCTestCase {
    
    func testInitialLoadMovies_usesMockData() async {
        let vm = withDependencies {
            $0.movieService = MockMovieService()
        } operation: {
            MovieListViewModel()
        }
        
        await vm.initialLoadMovies()
        
        XCTAssertEqual(vm.moviesToShow.map(\.title), ["Mock Movie 1", "Mock Movie 2"])
        XCTAssertFalse(vm.showError)
    }
    
    func testLoadMoreIfNeeded_noOpWhenTotalPagesIsOne() async throws {
        let vm = withDependencies {
            $0.movieService = MockMovieService()
        } operation: {
            MovieListViewModel()
        }
        
        await vm.initialLoadMovies()
        let before = vm.moviesToShow
        
        try await vm.loadMoreIfNeeded(currentItem: before.last)
        XCTAssertEqual(vm.moviesToShow, before)
    }
    
    func testUpdateSuggestions_usesMockData() async {
        let vm = withDependencies {
            $0.movieService = MockMovieService()
        } operation: {
            MovieListViewModel()
        }
        
        await vm.updateSuggestions(for: "mo")
        
        XCTAssertEqual(vm.suggestions, ["Mock Movie 1", "Mock Movie 2"])
        XCTAssertTrue(vm.filteredMovies.isEmpty)
    }
    
    func testLoadSearchResults_usesMockData_andClearsSuggestions() async {
        let vm = withDependencies {
            $0.movieService = MockMovieService()
        } operation: {
            MovieListViewModel()
        }
        
        await vm.updateSuggestions(for: "m")
        XCTAssertFalse(vm.suggestions.isEmpty)
        
        vm.loadSearchResults(query: "mock")
        try? await Task.sleep(nanoseconds: 600_000_000)
        
        XCTAssertEqual(vm.filteredMovies.map(\.title), ["Mock Movie 1", "Mock Movie 2"])
        XCTAssertEqual(vm.suggestions, [])
    }
    
    func testInitialLoadMovies_failureSetsErrorFlag() async {
        let vm = withDependencies {
            $0.movieService = FailingMovieService()
        } operation: {
            MovieListViewModel()
        }
        
        await vm.initialLoadMovies()
        XCTAssertTrue(vm.showError)
        XCTAssertTrue(vm.moviesToShow.isEmpty)
        
    }
    
    func testRetryLoadingMovies_recoversAfterFailure() async {

        let vm = withDependencies {
            $0.movieService = FailingMovieService()
        } operation: {
            MovieListViewModel()
        }
        
        await vm.initialLoadMovies()
        XCTAssertTrue(vm.showError)
        
        withDependencies {
            $0.movieService = MockMovieService()
        } operation: {
            vm.retryLoadingMovies()
        }
        
        try? await Task.sleep(nanoseconds: 600_000_000)
        
        XCTAssertFalse(vm.showError)
        XCTAssertEqual(vm.moviesToShow.map(\.title), ["Mock Movie 1", "Mock Movie 2"])
    }
}
