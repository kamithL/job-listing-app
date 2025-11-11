Job Listing App

A Flutter application for browsing and managing job listings. It follows a clean and organized architecture and uses the BLoC pattern for state management.

Features

View a list of jobs from an API

Search and filter jobs by title, location, and type

View detailed job information

Save favorite jobs locally

Light and dark mode support

Architecture

The app is built using Clean Architecture with clear separation of layers:

Presentation – UI screens and BLoC logic

Domain – Business logic, use cases, and entities

Data – API services, local storage, and repositories

This structure makes the app easy to maintain and extend.

State Management

Uses the BLoC pattern for managing app states.
It helps keep the UI and business logic separate, making the codebase cleaner and more testable.

Setup
Requirements

Flutter SDK 3.0.0 or higher

Dart SDK 3.0.0 or higher

Steps
git clone <repository-url>
cd job_listing_app
flutter pub get
flutter run

API

The app fetches job data from a REST API (MockAPI).
Base URL: https://69116a817686c0e9c20d5048.mockapi.io/api/v1/jobs

Local Storage

Favorites and theme preferences are saved using SharedPreferences, so data stays after app restarts.

Project Structure
lib/
├── core/
├── data/
├── domain/
└── presentation/

Time Taken

Estimated time: 16 hours

Setup and architecture: 2 hours

Data and domain layers: 4 hours

UI and BLoC setup: 7 hours

Testing and final adjustments: 2 hours

Documentation and polish: 1 hours