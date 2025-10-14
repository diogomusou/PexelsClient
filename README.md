# PexelsClient

Uses Pexels API to show and search photos.

Some features:
- Show curated photos by default (Pexels API)
- Search bar to search (Pexels API)
- Tap photo to see in original size
- Zoom in and pane to explore the photo (as in the iOS Photos app)
- Tap the info button to see more information about the photo (WIP)

Some details about the codebase:
- All code is in modules
- API module uses protocol whitness instead of traditional protocols: this allows for easier switching of stubs and better customization of stubs on the spot
- The live implementation of API lives in a different module, so that the client module can stay light
- App uses swift concurrency 
- App uses "Dependencies" 3rd-party library for easy and safe dependency injection
- App uses "Concurrency Extras" 3rd-party library in the unit test to make tests less flaky

Note: API key is not currently included in the code
