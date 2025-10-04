# 🎬 MoviesApp

Welcome to **MoviesApp** – a simple SwiftUI-based movie browser built using modern Swift Concurrency and MVVM+C architecture.

This app fetches and displays movie data from [The Movie Database (TMDb)](https://www.themoviedb.org/) using their public API.

---

## 🚀 Getting Started

To run the app on your machine after cloning the repo ```git@github.com:joliejuly/MoviesApp.git```:

1.	**Create your Access Token**:
You’ll need a TMDb access token to fetch movie data. You can get one for free by creating an account at TMDb and generating a personal API token.

2.	**Create your Secrets.xcconfig file**:

In the root of the project (alongside SecretsExample.xcconfig), create a file called ```Secrets.xcconfig```. You can copy ```SecretsExample.xcconfig``` that is commited to the repo.
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
 - MVVM for Presentation layer
 - Coordinator pattern for navigation
 - swift-dependencies for DI (explained below) 
 - A separate target for the network layer
 - LRU cache for effective image caching
 - Background image rendering for fast scrolling 
 - Unit tests with mocks 

---

## 📱 Why this project uses the [swift‐dependencies](https://github.com/pointfreeco/swift-dependencies) package as the only 3rd party library

Dependency management is the only cross-cutting concern in this codebase that isn’t already handled well by the standard library or SwiftUI. I chose [swift-dependencies](https://github.com/pointfreeco/swift-dependencies) as the single third-party package because it solves that problem cleanly while keeping the overall solution simple and test-friendly. 

**Key points**:
- Eliminates boiler-plate. Without a helper the same “pass this service down the chain” code would repeat in every view and view-model initializer. The package replaces that with one @Dependency line per use site, so the domain logic stays readable.
- Testability built in. Unit tests can swap concrete implementations with the one-liner
```withDependencies```, which is dramatically shorter and less error-prone than re-creating the object graph by hand.
- Lazy and cached by default. Each service is constructed only on first access and then reused, so start-up work stays near zero even as the feature set grows.
- Actively maintained and MIT-licensed. It is written by the authors of The Composable Architecture, widely used in production apps, and adds only ~30 KB to the binary.


## 📱 To be implemented: 

  - Localization
  - More details and nicer UI for Movie details

