# TM-ImageLoad Project

## Overview

TM-ImageLoad is an iOS application that handles the loading and display of images using a custom UI structure built with Swift. The project focuses on creating a collection view that efficiently loads and manages the state of images from URLs.

## Key Features

- **Custom UICollectionView Cells**: The project utilizes custom collection view cells (`FirstCell` and `ImageCell`) to display images and provide user interactions.
- **State Management**: The application uses view models (`ImageCollectionViewModel`, `ThumbnailImageViewModel`) and state objects (`ImageDisplayState`, `ImageLoadState`) to handle the image loading states and synchronize UI updates.
- **SwiftUI Integration**: SwiftUI components (`UIHostingConfiguration`, `ThumbnailImageView`) are embedded within the UIKit-based collection view cells, demonstrating a hybrid approach to UI development.

## Project Structure

### .gitignore
A `.gitignore` file is added to exclude user-specific data (`xcuserdata`) from the repository. This ensures that personal configurations do not interfere with the project version control.

### Xcode Project Configuration (`project.pbxproj`)
Several modifications were made to the Xcode project configuration to include new files and remove deprecated ones:
- Removed **Main.storyboard** in favor of programmatic UI setup.
- Added new Swift files related to the image loading and display logic (`ImageListScreen.swift`, `ImageLoader.swift`, etc.).
- Adjusted the build phases and file references to accommodate the new structure.

### New Swift Files

- **ImageCollectionViewController.swift**: A new `UICollectionViewController` that manages the display of images in a collection view. It uses custom cells to render images and a button, providing a seamless user experience.
- **ImageDisplayStorage.swift**: Handles the storage of image display states, ensuring that the UI reflects the correct state of each image.
- **ImageListViewModel.swift**: A view model that manages the image collection data and interacts with the `ImageDisplayStorage` to update the UI when necessary.
- **ThumbnailImageView.swift**: A custom SwiftUI view for rendering thumbnail images. It integrates with the `ImageLoader` to fetch and display images from URLs.

### State Synchronization
The project introduces a state synchronization mechanism through view models and state objects. The `ImageDisplayStorage` class centralizes the management of image states, while `ImageLoadState` and `ImageDisplayState` encapsulate the state of individual images. This allows the application to efficiently update the UI based on the image loading status.

## Getting Started

To run the project, clone the repository and open the `TM-ImageLoad.xcodeproj` in Xcode. Ensure you have the latest version of Xcode installed to avoid compatibility issues with Swift and SwiftUI components.

### Prerequisites
- Xcode 12 or later
- Swift 5.3 or later

### Building and Running
1. Clone the repository:
    ```sh
    git clone https://github.com/yourusername/TM-ImageLoad.git
    ```
2. Open the project in Xcode:
    ```sh
    cd TM-ImageLoad
    open TM-ImageLoad.xcodeproj
    ```
3. Build and run the project using the Xcode build button or `Cmd + R`.

## Contributing

Contributions to TM-ImageLoad are welcome. Please submit pull requests with a clear description of the changes and the rationale behind them. Ensure that your code follows the project's coding style and includes relevant tests.

## License

TM-ImageLoad is licensed under the MIT License. See the `LICENSE` file for more details.
