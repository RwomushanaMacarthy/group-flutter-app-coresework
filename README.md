

**Project Title:** AgroTrade Mobile Application
**Document Type:** Technical & Functional Documentation
**Platform:** Flutter (iOS & Android)

---

### 1. Project Overview
AgroTrade is a comprehensive mobile application built with Flutter that bridges the gap between local farmers and urban buyers. The platform provides a seamless digital marketplace for farmers to manage their agricultural inventory and for customers to browse, order, and track fresh produce. 

The application is built with a **local-first architecture**, ensuring robust offline capabilities. All user data, product inventories, and order histories are saved securely on the device using local storage, ensuring the app remains fully functional without an active internet connection.

---

### 2. Core Features

**Authentication and User Roles**
The app features a dual-role authentication system designed to cater to both sellers and buyers.
*   **Farmer Portal:** Empowers farmers to manage their daily operations, including inventory tracking, order fulfillment, and revenue monitoring.
*   **Customer Portal:** Provides a smooth shopping experience for buyers to browse categories, manage a shopping cart, and track their order history.
*   **Local Registration:** Users can create new accounts, with all credentials securely stored on the local device.
*   **Default Testing Accounts:** For immediate access and testing, default accounts are pre-filled on the login screen:
    *   Customer ID: `customer` | Password: `password`
    *   Farmer ID: `farmer` | Password: `password`

**Farmer Dashboard and Management**
Upon logging in as a farmer, the user gains access to a suite of management tools:
*   **Dashboard Summary:** A quick-glance overview of Total Products, Pending Orders, and Total Revenue.
*   **Inventory Control:** Farmers have full CRUD (Create, Read, Update, Delete) capabilities over their produce. They can add new items, edit existing listings, temporarily hide products from the marketplace, or delete them entirely.
*   **Media Handling:** Product images can be uploaded via the device camera, selected from the gallery, or linked via a web URL.
*   **Order Fulfillment:** Farmers receive orders in real-time and can update the status (Accept, Reject, or Mark as Delivered).
*   **Profile Management:** Farmers can update their farm details, contact information, and profile picture.

**Customer Experience**
The customer-facing interface is designed for ease of use and discovery:
*   **Marketplace:** Browse fresh produce categorized by Vegetables, Fruits, Grains, and Legumes. Product availability updates in real-time.
*   **Shopping Cart:** Add items to the cart, adjust quantities, and proceed to a streamlined checkout process.
*   **Order Tracking:** Customers can view their order history and monitor the status of their deliveries.
*   **Personal Profile:** Customers can manage their contact information, update their avatar, and log out securely.

**Connectivity and Offline Support**
*   **Local Persistence:** The app utilizes device memory to ensure that users, products, and orders are never lost when the app is closed or when the device loses internet connection.
*   **Dynamic Offline Banner:** The app actively monitors network connectivity. If the device goes offline, a red warning banner appears at the top of the screen, notifying the user that changes will be saved locally. The banner automatically dismisses when the connection is restored.

---

### 3. Technical Architecture

*   **Framework:** Flutter (Dart)
*   **State Management:** Utilizes `ChangeNotifier` and `AnimatedBuilder`. A global singleton `AppState` class manages all data mutations, ensuring that the UI updates reactively across all screens without requiring complex state management libraries.
*   **Database:** `shared_preferences` is used to serialize and store JSON data (Users, Products, Orders, and Reviews) directly on the device.
*   **Image Processing:** The application uses `image_picker` for device camera/gallery access and `cached_network_image` for efficient loading and caching of web-based images. Local file paths are stored and prioritized over network URLs.

---

### 4. System Architecture and File Structure

The application is modularized for maintainability. Below is the breakdown of the `lib` directory:

*   **main.dart:** The application entry point. It initializes the app, configures the global theme, and handles routing based on the authentication state.
*   **app_state.dart:** The core data controller. It defines the data models (AppUser, Product, CustomerOrder) and manages all read/write operations to the local database.
*   **splash_screen.dart:** The initial onboarding screen featuring the app logo and an auto-scrolling image carousel.
*   **auth_screen.dart:** The unified login and registration interface for both farmers and customers.
*   **connectivity_banner.dart:** A wrapper widget that listens for network changes and displays the offline warning.
*   **customer_home_screen.dart:** The primary interface for customers, containing the marketplace, cart, and order history.
*   **farmer_dashboard_screen.dart:** The main hub for farmers, displaying key metrics and quick navigation actions.
*   **farmer_manage_products_screen.dart:** The inventory management interface.
*   **farmer_add_product_screen.dart:** The form used for uploading new produce and images.
*   **farmer_orders_screen.dart:** The order fulfillment interface for farmers.
*   **farmer_profile_screen.dart:** The profile management screen for farmers.
*   **color_typography.dart:** The design system file containing all color palettes, typography styles, and UI constants for consistent theming.

---

### 5. Developer Setup Guide

To run the AgroTrade application locally, follow these steps:

1. Ensure the Flutter SDK is installed and configured on your machine.
2. Clone or open the project directory in your preferred IDE (VS Code or Android Studio).
3. Open the terminal and install the required dependencies:
   `flutter pub get`
4. Connect a physical device or launch an emulator.
5. Compile and run the app:
   `flutter run`

**Asset Requirements:**
Ensure that the `assets/` folder contains the required images (`logo.png` and splash screen images) and that they are correctly declared in the `pubspec.yaml` file.

---

### 6. Future Enhancements

While the current local-first version is highly robust, the following features represent the next phase of development:

1.  **Cloud Synchronization:** Integrating a backend service like Firebase to allow real-time data syncing across multiple devices.
2.  **Payment Gateway Integration:** Adding support for MTN Mobile Money and Airtel Money to process actual transactions.
3.  **Push Notifications:** Alerting farmers immediately when an order is placed, and notifying customers of status changes.
4.  **Location Services:** Integrating GPS and Google Maps to provide accurate delivery routing and live tracking.
