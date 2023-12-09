# Final Project

SDN final project

## Installing and Setting up flutter

Refer the following link to install and setup required tech stack for the application: https://docs.flutter.dev/get-started/install

After installing Flutter, we would also need to install Android-studio and command-line tools for Android SDK:

1) Install and setup android-studio from this link: https://developer.android.com/studio/install

NOTE: For Linux/Ubuntu, android-studio is already an application available on Ubun
tu Software. We can install it directly from there.

2) Download and setup the command-line-tools by following these steps:

    a) Open android-studio
    b) Click on "More Actions" option on the boot window. Select SDK Manager from the options it shows.
    c) In the "Android SDK" section, go to the SDK Tools section.
    d) Check the box for "Android SDK Command-line Tools (latest)" and click ok

3) Running "flutter doctor" would ask you to acccept some android-licenses. Run the following command to fix this:

 flutter doctor --android-licenses

4) Running the application: This can be done in two ways

    a) Setup an android emulator: https://developer.android.com/studio/run/managing-avds
    b) Running on your local android device: This requires for activating USB-debugging in the developer options. Follow this link to do so: https://developer.android.com/studio/run/device

This concludes the setup for Flutter.

## Clone the project

Clone the project from the repository: https://github.com/ishaanj0412/SDN_project

## Running the application

1) Start the emulator or connect or android mobile with your laptop and allow for USB debugging.
2) Run the application using command: "flutter run"
3) Select the device you want to run the application on.
