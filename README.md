# TicketLelo

Welcome to TicketLelo, a Flutter-based event management app! 🎟️ This app allows users to create and manage events, with features for both free and paid ticketing. Integrated with Firebase and JazzCash for backend and payment processing, TicketLelo provides a smooth experience for event organizers and attendees alike.

## Features

- **Event Creation:** Create and manage free and paid events.
- **Admin Approval:** Admins review and approve events before they go live.
- **Ticket Management:** View and manage purchased tickets.
- **Payment Integration:** Integrated with JazzCash for secure transactions.
- **State Management:** Utilizes Provider for efficient state management.

## Screenshots

![LoginScreen](https://github.com/user-attachments/assets/71322bd0-3137-4d97-8144-45956ac7897b)
![HomeScreen](https://github.com/user-attachments/assets/94705ef9-7685-4d7a-ba19-688a70bcc26e)
![EventDetails](https://github.com/user-attachments/assets/b1b332b5-93e1-45b6-ac8e-999d67bb4c1b)
![JazzCashPayment](https://github.com/user-attachments/assets/387f23e5-5cbb-446f-aa45-8bf56229ba50)
![Tickets](https://github.com/user-attachments/assets/bc90a67e-637a-481b-b358-dc5df8b82db5)
![TicketDetails](https://github.com/user-attachments/assets/b5aba369-9d27-4860-a375-7b10102de539)
![MyEvents](https://github.com/user-attachments/assets/399de337-51d0-4237-ada6-1fe02588a346)


## Technologies Used

- **Flutter:** For building the cross-platform mobile app.
- **Firebase:** For backend services, including authentication and database management.
- **JazzCash:** For payment processing.
- **Provider:** For state management.

## Getting Started

Follow these steps to set up and run TicketLelo on your local machine.

### Prerequisites

- Flutter SDK installed. If not, follow the [Flutter installation guide](https://flutter.dev/docs/get-started/install).
- An active Firebase project. Set up your Firebase project by following the [Firebase setup guide](https://firebase.google.com/docs/flutter/setup).
- JazzCash API credentials. Obtain these from [JazzCash API documentation](https://www.jazzcash.com.pk/).

### Setup

1. **Clone the Repository:**

   ```bash
   git clone https://github.com/yourusername/ticketlelo.git
   cd ticketlelo
   
2. **Install Dependencies:**

   ```bash
   flutter pub get

3. **Configure Firebase:**
  [Checkout Firebase Documentation to Install Firebase CLI](https://firebase.google.com/docs/cli#install-cli-windows)
Run the Following Command to Ensure that Firebase CLI is installed:
   ```bash
   flutterfire configure

4. **Configure JazzCash**:

Obtain your JazzCash API credentials from the JazzCash API documentation.
Add these credentials to the lib/services/payment/payment_service.dart file. This might involve updating environment variables or configuration files where API keys and secrets are stored.
Run the App/



## Build and Release

To build the app for release, use the following commands:

- **For Android:**

  ```bash
  flutter build apk --release


- **For Android:**

  ```bash
  flutter build ios --release


- Usage
Creating Events: Open the app and navigate to the 'Create Event' screen to set up new events. You can specify whether the event is free or paid, and provide details such as date, time, and description.
Viewing Tickets: Go to the 'My Tickets' section to view and manage tickets you’ve purchased for events.
Admin Approval: Admins can access the admin dashboard to review and approve or reject events before they are made live.
Contributing
Contributions are welcome! If you find a bug or have a feature request, please open an issue or submit a pull request. Follow these guidelines for contributions:

Fork the repository.
- Create a new branch (git checkout -b feature/YourFeature).
- Commit your changes (git commit -am 'Add new feature').
- Push to the branch (git push origin feature/YourFeature).
- Create a new Pull Request.

##License

This project is licensed under the MIT License - see the LICENSE file for details.

   
