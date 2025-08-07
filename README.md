# ecommerce

# E-commerce Flutter Project

This project implements an e-commerce application using Flutter and adheres to Clean Architecture principles for better separation of concerns, maintainability, and testability.

## Architecture Overview

The project is structured around the principles of Clean Architecture, dividing the application into distinct layers:

- **Presentation Layer**: Handles the UI and user interactions. (Not yet fully implemented in this initial setup)
- **Domain Layer**: Contains the business logic and entities, independent of any framework. This includes:
  - `lib/features/product/domain/entities`: Defines core business objects like `Product`.

  - `lib/features/product/domain/repositories`: Abstract definitions of data contracts (e.g., `ProductRepository`). 
  - `lib/features/product/domain/usecases`: Encapsulates specific business rules and operations (e.g., `CreateProduct`, `GetAllProducts`).

- **Data Layer**: Implements the contracts defined in the Domain Layer, handling data sources (e.g., APIs, databases).
  - `lib/features/product/data/models`: Data models (e.g., `ProductModel`) for serialization/deserialization.

## Project Structure

- `lib/core`: Contains shared core components, error handling logic, and common utilities.
- `lib/features`: Houses feature-specific modules. Each feature (e.g., `product`) has its own dedicated directory.
  - `lib/features/product`:
    - `data`: Data-related implementations for the product feature.
      - `models`: Data models for product entities.
- `test`: Contains all unit and widget tests, mirroring the `lib` directory structure.

## Data Flow

1. **UI Interaction**: User interacts with the UI (Presentation Layer).
2. **Usecase Execution**: The UI dispatches an action that triggers a usecase (Domain Layer).
3. **Repository Call**: The usecase calls an abstract method on a repository interface (Domain Layer).
4. **Data Retrieval/Manipulation**: The concrete implementation of the repository (Data Layer) interacts with data sources (e.g., network, local database) to retrieve or manipulate data.
5. **Data Conversion**: Data models from the Data Layer are converted into domain entities before being passed back to the Domain Layer.
6. **Result to UI**: The usecase returns the result (either success or failure) to the Presentation Layer, which then updates the UI accordingly.

## Getting Started

This project is a starting point for a Flutter application.

To run this project:

1. Clone the repository.
2. Navigate to the project directory.
3. Run `flutter pub get` to install dependencies.
4. Run `flutter run` to launch the application.

## Testing

Unit tests are located in the `test` directory. To run all tests, execute:

```bash
flutter test
```

## Resources

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
