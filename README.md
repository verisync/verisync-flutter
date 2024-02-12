
# Verisync

This package is for the **verisync** KYC service that helps simply the **KYC** process.

## Features

This package uses flutter_inappwebview to display the verisync KYC process. It as simple widget that takes in the following argument: `redirectUrl`, `flowId`, `clientId`, optional `email`, a function `callbackSuccess` to handle your success case, and an optional function `callbackError` to handle your error case.

## Getting started

Create your verisync account *here* if you do no already have one. Grab your flowId, and clientId  from *here* .

### next install the package by running

```dart
flutter pub add verisync
```

## Usage

A simple example

```dart
ElevatedButton(
                onPressed: () {
                  showAdaptiveDialog(
                    context: context,
                    builder: (BuildContext dialogContext) => VerisyncWidget(
                      flowId: "<provide your call flowID>",
                      redirectUrl: "<provide your redirectUrl>",
                      clientId: "provide your clientID",
                      callbackSuccess: (dialogContext) {
                        ScaffoldMessenger.of(dialogContext).showSnackBar(
                          const SnackBar(
                            content: Text("Verification successful"),
                            duration: Duration(seconds: 3),
                          ),
                        );
                      },
                    ),
                  );
                },
                child: const Text('Verify your identity'),
              ),
```

## Additional information

TODO: Tell users more about the package: where to find more information, how to
contribute to the package, how to file issues, what response they can expect
from the package authors, and more.
