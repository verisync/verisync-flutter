
# Verisync

This package is for the **verisync** KYC service that helps simply the **KYC** process.

## Features

This package uses flutter_inappwebview to display the verisync KYC process. It as simple widget that takes in the following argument: `redirectUrl`, `flowId`, `clientId`, optional `email`, a function `callbackSuccess` to handle your success case, and an optional function `callbackError` to handle your error case, optional `metaData` in case extra data is needed.

## Getting started

Create your Verisync account *here* if you do not already have one. Grab your flowId, and clientId  from *here*.

### Next install the package by running

```dart
flutter pub add verisync
```

## Usage

Here is an Example

https://github.com/verisync/verisync-flutter/assets/16627656/e730f150-b43d-4193-9fe8-d3a997855ddf

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
                      email: "provide email",
                      metadata:"< A map of additional data to be sent to the server example(Map<dynamic, dynamic>? metadata)>"
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

## Author
![author](https://github.com/verisync/verisync-flutter/assets/16627656/61b3da21-7950-4f20-808a-e26a20f13c2a =50)

[Abdulbasit Said Ibrahim (codesahir)](https://github.com/AbdulbasitSaid)

## Contributors

...
