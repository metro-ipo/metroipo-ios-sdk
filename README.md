# metro-ipo-ios-sdk
Metro IPO's SDK for signature capture in Swift.

## 1. Platform Requirements

The SDK supports the following configurations:
- Supports iOS 10+
- Supports Xcode 11.5+
- Supports the following presentation styles:
    - Fullscreen for iPhones
    - Fullscreen and Form Sheet for iPads


## 2. Install as a CocoaPod

To install the SDK using CocoaPods, add the following to the application's podfile:

```
pod 'MetroIpoSdk'
```

Then run `pod install` to retrieve the sdk.

## 3. Configuring the SDK

The Metro IPO SDK uses a **verification code** that you can obtain from your ipo application dashboard. A sample implementation is shown below.

```swift
import MetroIpoSdk

let config = MetroIpoConfig().setDomain(url: "YOUR-METROIPO-SERVER").build() // Domain/Hostname should be added without "https://" or trailing slash e.g metroipo.com
do {
    let sdk = try MetroIpo(configuration: config)

    var presentationStyle: UIModalPresentationStyle = .fullScreen
            
    if UIDevice.current.userInterfaceIdiom == .pad {
        presentationStyle = .formSheet
    }
    
    try sdk.start(code: "VERIFICATION-CODE", origin: self, style: presentationStyle)
} catch let error {
    print("Flow not started. Error: \(error)")
}
```

## 4. SDK Responses

The Metro Ipo SDK exposes four callbacks to the mobile app. Each can be used to coordinate user feedback at various stages of the SDK's lifecycle.

```swift
sdk.with(responseHandler: {response in
        switch response {
        case .success(let result):
            // The mobile app user has completed all the required steps and is returned to the view that initiated the SDK.
           print("Signature was successfully added to the application: \(result)")
        case .failure(let error):
            // The mobile app user decided to not upload the signature.
            print("Signature was not added to the application: \(error)")
        case .start:
            // A new instance of the sdk was started by the user.
            print("Metro IPO Sdk was successfully initialized.")
        case .error(let error):
            // An error occured while the verification flow was in progress.
            switch error {
                case .exception(withMessage: let message):
                    self.showAlert(title: "Invalid Code", message: message)
                case .USER_CANCELLED:
                    print("Applicant cancelled verification.")
                case .API_NOT_AVAILABLE:
                    print("Server is unreachable.")
                case .UPLOAD_INVALID:
                    print("Upload data is corrupted.")
                case .CODE_MISSING:
                    print("Verification code is missing.")
                default:
                    print("An error occured. \(error.localizedDescription)")
                }
        break;
        }
    }
```

## 5. Customizing the Theme

To ensure that Metro Ipo fits in to your app's existing user experience, you can customize various colors by specifying a theme configuration.

```swift
let appearance = Theme(
    colorPrimary: <UIColor>,
    colorTextPrimary: <UIColor>,
    colorButtonPrimary: <UIColor>,
    colorButtonPrimaryText: <UIColor>,
    colorButtonPrimaryPressed: <UIColor>,
    imageNavCenterLogo: <UIImage>,
    imageNavBackground: <UIImage>,
    imageBottomLogo: <UIImage>,
    buttonBorderRadius: <CGFloat>,
    enableDarkMode: <true | false>)

let config = MetroIpoConfig().setAppearance(appearance).build()
```

```colorPrimary```: Defines the primary accent color.\
```colorTextPrimary```: Defines the color of the nav title text and back button.\
```colorButtonPrimary```: Defines the background color of Primary Buttons and the text color of Secondary Buttons.\
```colorButtonPrimaryText```: Defines the text color of Primary Buttons.\
```colorButtonPrimaryPressed```: Defines the background color of Primary Buttons when pressed.\
```imageNavCenterLogo```: Defines a center image of the signature page navigation bar.\
```imageNavBackground```: Defines the background image of the signature page navigation bar.\
```imageBottomLogo```: Defines the bottom logo image of the signature page.\
```buttonBorderRadius```: Defines the border radius of buttons.\
```enableDarkMode```: Defines the dark mode allowed setting for the SDK.

## Sample App
A sample app demonstrating the Metro Ipo SDK's implementation has been included. See the [SampleApp directory](https://github.com/metro-ipo/metro-ipo-ios-sdk/tree/main/SampleApp) for the Swift implementation.

## Support

Please post all issues through [Github](https://github.com/metro-ipo/metro-ipo-ios-sdk/issues). If your query involves sensitive information, you may contact us at dev@orba.io with the subject `IOS ISSUE: `.

Copyright 2021 Orba Technology Holdings Ltd. All rights reserved.
