# 🎬 MoviesApp

Welcome to **MoviesApp** – a simple SwiftUI-based movie browser built with Swift Concurrency and MVVM+CCoordinator architecture.

This app fetches and displays movie data from [The Movie Database (TMDb)](https://www.themoviedb.org/) using their public API.

---

## 🚀 Getting Started

To run the app on your machine, clone this repo: ```git clone git@github.com:joliejuly/MoviesApp.git```. 

> [!IMPORTANT]
> **If you have a ```Secrets.xcconfig``` file provided by me, just drag it to the folder MoviesApp just near the ```SecretsExample.xcconfig``` and run.**


If you don't have a ```Secrets.xcconfig``` file, you can create your own in 2 simple steps: 

1.	**Create your Access Token**:
You’ll need a TMDb access token to fetch movie data. You can get one for free by creating an account at TMDb and generating a personal API token.

2.	**Create your Secrets.xcconfig file**:

In the root of the project (alongside SecretsExample.xcconfig), create a file called ```Secrets.xcconfig```. You can copy ```SecretsExample.xcconfig``` that is committed to the repo.
Make sure it contains ```TMDB_ACCESS_TOKEN = <YOUR_TMDB_TOKEN_HERE>``` line.

Alternatively, you can just paste your token in ```Auth -> Bundle+Extension.swift``` file under ```var tmdbAccessToken``` value. 

---

## 📱 Features

- Browse the most popular movies with infinite scroll
- Search movies by name with autocomplete
- Tap movie to see details

--- 

## 📱 Project highlights 

 - SwiftUI-powered UI
 - MVVM for presentation
 - Coordinator navigation
 - Supports iOS 15+
 - Dependency injection via swift-dependencies
 - Separate Networking target
 - LRU cache for effective image caching
 - Background image rendering for fast scrolling 
 - Unit tests with mocks (≈71 % coverage network layer, ≈28 % presentation)

---

## 📱 Why this project uses the [swift‐dependencies](https://github.com/pointfreeco/swift-dependencies) package as the only 3rd party library

Dependency management is the only cross-cutting concern in this codebase that isn’t already handled well by the standard library or SwiftUI. I chose [swift-dependencies](https://github.com/pointfreeco/swift-dependencies) as the single third-party package because it solves that problem cleanly while keeping the overall solution simple and test-friendly. 

**Key points**:
 • Replaces repetitive “pass this service down” boilerplate with a single @Dependency per use site.
	•	Makes testing trivial: withDependencies { $0.service = Mock() } instead of hand-building graphs.
	•	Lazy and cached by default, so start-up stays fast.


## 📱 Next steps: 

  - Localization
  - Snapshot and/or UI-tests
  - More details and nice UI for Movie details page

