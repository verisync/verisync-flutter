# Verisync

## Introduction

The Verisync Identity Verification Button is a Flutter widget designed to simplify the process of integrating identity verification within your Flutter application. It wraps the complexity of initiating and handling identity verification flows into a simple, easy-to-use button widget.

## Features

- **Simple Integration**: Just drop the `VerisyncButton` into your widget tree to get started.
- **Customizable**: Supports customization of button appearance and behavior through parameters.
- **Permission Handling**: Automatically handles camera permission requests necessary for identity verification.
- **Callback Support**: Provides `onSuccess` and `onError` callbacks to handle the verification result.
- **Dialog Presentation**: Shows the identity verification process in a dialog for a seamless user experience.

## Getting Started

### Dependencies

Add the following dependencies to your `pubspec.yaml` file:

```yaml
dependencies:
  flutter:
    sdk: flutter
  verisync: ^latest_version
```

## Import

```dart
import 'package:your_package/verisync_button.dart'; // Adjust the import path based on your project structure
```

## Usage

To use the VerisyncButton, simply include it in your widget tree and provide the necessary parameters:

```dart
VerisyncButton(
  redirectUrl: 'https://example.com/redirect',
  flowId: 'your_flow_id',
  clientId: 'your_client_id',
  email: 'optional_email@example.com', // Optional
  metadata: {'key': 'value'}, // Optional
  onSuccess: (context) {
    // Optional Handle verification success
  },
  onError: (context) {
    // Optional Handle verification error
  },
  style: ButtonStyle(
    backgroundColor: MaterialStateProperty.all(Colors.blue),
  ),
  child: Text('Verify Identity'),  //Optional Customize button child widget
)
```

If you do not intend to customize the button, simply add only the required parameters like so:

```dart
VerisyncButton(
  redirectUrl: 'https://example.com/redirect',
  flowId: 'your_flow_id',
  clientId: 'your_client_id',
  ),
```

## Parameters

- redirectUrl: The URL to which the verification process will redirect upon completion.
- flowId: The flow ID for the verification process.
- clientId: Your client ID for the verification service.
- email: (Optional) The email address to prefill in the verification process.
- metadata: (Optional) Additional metadata to pass along with the verification request.
- onSuccess: (Optional) Callback function that is called upon successful verification.
- onError: (Optional) Callback function that is called upon a verification error.
- style: (Optional) Custom style for the button.
child: (Optional) Custom child widget to display inside the button.

## Handling Permissions

The VerisyncButton automatically handles camera permissions required for identity verification. If permissions are denied or not granted, it provides guidance to the user for enabling them through the app settings. It depend [permission_handler](https://pub.dev/packages/permission_handler) package. Please read the instructions on platform specific requirements from:  [permission_handler](https://pub.dev/packages/permission_handler).

## Customization

Customize the appearance and behavior of the VerisyncButton by providing custom values for the style and child parameters, as well as handling the onSuccess and onError events according to your application's needs.
