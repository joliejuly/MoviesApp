import XCTest
@testable import MoviesApp

@MainActor
final class MovieCellViewModelTests: XCTestCase {
    func testFormatting_releaseYearAndRating() {
        let date = yyyyMMddDateFormatter.date(from: "2021-10-22")
        let movie = Movie(
            id: 42,
            title: "Dune",
            originalTitle: "",
            posterPath: "/abc.jpg",
            releaseDate: date,
            rating: 7.95
        )
        let vm = MovieCellViewModel()
        
        let releaseYear = vm.releaseYear(for: movie)
        let rating = vm.rating(for: movie)
        
        XCTAssertEqual(releaseYear, "Release year: 2021")
        XCTAssertEqual(rating, "Rating: 8.0")
    }
    
    func testFormatting_originalTitle() {
        let movie = Movie(
            id: 42,
            title: "The Moon",
            originalTitle: "La luna",
            posterPath: "/abc.jpg",
            releaseDate: nil,
            rating: 7.95
        )
        let vm = MovieCellViewModel()
        
        let originalTitle = vm.originalTitle(for: movie)
        
        XCTAssertEqual(originalTitle, "Original title: La luna")
    }
    
    func testFormatting_originalTitle_handlesSameTitle() {
        let movie = Movie(
            id: 42,
            title: "Dune",
            originalTitle: "Dune",
            posterPath: "/abc.jpg",
            releaseDate: nil,
            rating: 7.95
        )
        let vm = MovieCellViewModel()
        
        let originalTitle = vm.originalTitle(for: movie)
        
        XCTAssertNil(originalTitle)
    }
    
    func testFormatting_handlesBadDate() {
        let movie = Movie(
            id: 42,
            title: "Dune",
            originalTitle: "",
            posterPath: "/abc.jpg",
            releaseDate: nil,
            rating: 7.95
        )
        let vm = MovieCellViewModel()
        
        let releaseYear = vm.releaseYear(for: movie)
        
        XCTAssertNil(releaseYear)
    }
}

private let yyyyMMddDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    return formatter
}()
