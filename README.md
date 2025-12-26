# YES-App

<h1 align=center>
    <picture>
        <source srcset="assets/readme/logo-dark.png" media="(prefers-color-scheme: dark)" width="75%">
        <img src="assets/readme/logo-light.png" alt="Logo">
    </picture>
</h1>

> [!WARNING]
> This application will not be published on Google PLay Store or Apple App Store, since it 
> 1. Involves unnecessary fees I do not intend to spend
> 2. Requires inputting personal information such as address and phone number. I could set up a company account, but that also involves fees and additional bureaucracy that I can't go through at the moment.

---

This application is meant to allow easier article reading from the <live.iiseinaudiscarpa.edu.it/yes-site> school news website.

There is not yet an iPhone version, since i do not possess an appropriate testing device nor an Apple Developer Account.

The code uses Flutter 3 (with null safety) so it's safe to say that you can also compile it yourself without much trouble by using the latest version of the Flutter SDK.

## Installation instructions

### From an app store

The application is going to be available on F-Droid.

### Manually

1. Download the latest APK from the [Releases](https://github.com/Zac06/yes-app/releases) appropriate for your platform. If in doubt, download the "universal" APK.
2. Enable installation from unknown sources on your Android device.
3. Open the downloaded APK file and follow the instructions.
4. Enjoy!

## Compile it yourself

1. Clone this repository
2. Run
    ```
    flutter pub get
    ```
3. Sign your APK (**optional**)
4. Run
    ```
    flutter build apk --release
    ```

    This will compile every platform in ONE large APK. To compile platform-specific binaries:

    ```
    flutter build apk --release --split-per-abi
    ```

    And install the binary appropriate for your needs.