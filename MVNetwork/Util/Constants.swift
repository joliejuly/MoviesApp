public enum Constants {
    
    static let defaultHeaders: [String: String] = [
        "Content-Type": "application/json"
    ]
    
    static let bundleIdentifier = "com.joliejuly.MovieApp"
    
    public static let baseURL = URL(string: "https://api.themoviedb.org/3")!
    public static let imagesBaseURL = URL(string: "https://image.tmdb.org/t/p/")!
}
