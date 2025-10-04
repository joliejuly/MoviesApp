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
 - Dependencies for DI 
 - A separate target for the network layer
 - LRU cache for effective image caching
 - Background image rendering for fast scrolling 
 - Unit tests with mocks 

---

## 📱 To be implemented: 

  - Localization
  - More details and nicer UI for Movie details

