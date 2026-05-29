# Gold Prices Mobile App

## Structure
- `lib/core`: Shared resources (networking, error handling, models, utilities).
- `lib/features`: Application features using Feature-First architecture.
    - `prices`: Gold prices display feature.
    - `calculator`: Gold price calculator feature.
    - `bullions`: Bullions and coins display feature.

## Setup Instructions
To complete the setup, run the following command in the `mobile/` directory once you have Flutter installed:
```bash
flutter create .
```
Then, ensure all necessary dependencies are added to `pubspec.yaml` (e.g., `flutter_riverpod` for state management, `hive` for local storage, `dio` for API calls).
