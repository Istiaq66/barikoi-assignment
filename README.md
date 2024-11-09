# Barikoi Junior Flutter Developer Test

This Flutter application was developed as part of the Junior Flutter Developer assessment for Barikoi Technologies. The app displays a full-screen Barikoi map, shows the user’s current location, and enables interaction with the map for address information and directions using Barikoi’s APIs.

## Features

- **Location Permission**: Requests location permission upon app launch.
- **Current Location Display**: Centers the map on the user's current location.
- **Reverse Geolocation**: Allows users to tap on any location on the map to get address information using Barikoi's reverse geolocation API.
- **Address Info Panel**: Displays address details of the selected location, with a marker on the map.
- **Directions**: A button in the address info panel retrieves and displays route directions using Barikoi’s directions API as a GeoJSON line.

### Bonus Task
Implemented a button in the address info panel to display route directions.

## Demo

![Demo](demo.jfif)

## State Management
Implemented using **Getx** for efficient state handling.

## Getting Started

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/repositoryname.git
   ```
2. Add the necessary API keys in the appropriate files.
3. Run the app on an Android device/emulator with location services enabled.
