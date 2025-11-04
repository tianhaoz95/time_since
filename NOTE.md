=== Completed ===

Your task is to build on top of the empty Flutter app to build a maintenance tracking app. The goal is to build an all-in-one app to help track maintenance schedules. For example, when I change the water filter for my house, I should be able to log an entry and I will be able to always check when was the last time I changed the filter and how long it has been. The app should have a sign in screen. For now, it will show a text input field for email and another for password, and the user will successfully log in regardless of the email and password for now when click on the sign in button. When the user successfully sign in, it should navigate to the home screen which consists of 3 subscreen (item status screen, item management screen and settings screen) with bottom navigator. The item management screen should show a list of tracking items, for example, AC filter, water filter, etc and a button to add a new item, and for each item in the list, it should show a button to edit it and a button to delete it. In the item status screem, it should show a list of tracking items, for example, AC filter, water filter, etc and for each item in the list, it should show a button to log now as the last action or add a custom date as the last action, it should also show a button to check a list of full action history. In the settings page, it should show a button to sign out. Always use `flutter build apk` to validate the change and fix any issues.

Your task is to continue on the existing code to finish the UI for the app. The goal is to build an all-in-one app to help track maintenance schedules. For example, when I change the water filter for my house, I should be able to log an entry and I will be able to always check when was the last time I changed the filter and how long it has been. The item management screen should show a list of tracking items, for example, AC filter, water filter, etc and a button to add a new item, and for each item in the list, it should show a button to edit it and a button to delete it. In the item status screem, it should show a list of tracking items, for example, AC filter, water filter, etc and for each item in the list, it should show a button to log now as the last action or add a custom date as the last action, it should also show a button to check a list of full action history. Always use `flutter build apk` to validate the change and fix any issues.

Your task is to rename the app from `com.example.time_since` to `com.hejitech.timesince` for all platforms.

Your task is to implement a pop up window when user clicks on the "add" button on the manage tab, and the pop up window should let user input the name of the item and add the item to the list once user tap on "add" button and cancel the pop up window when user tap on "cancel" button.

Your task is add a sign up screen to the app which can be access by tapping on newly added "register" button from the login screen.

Your task is to add a email and password field to the sign up screen.

Your task is to use Firebase auth to implement the user sign up and login with email and password.

When I tap on the "sign out" button, it will show a black screen with a circular progress bar forever, your task is to fix this. The progress bar should be shown right next to the "sign out" button and the rest of the content on the settings page should remain the same.

Your task is to show the login screen when the user was not previously logged in.

Your task is to use Firebase Firestore to save the information for items and status. Each user should have an entry using their UID as the key and the app should store the items information (e.g., name, last date, etc) under the UID entry in the database. The app should read the information corresponding to the user's UID from Firestore when the user login, and when the user edit or delete the items, data in the Firestore database should change accordingly.

Your task is to show the time since last log on each of the items showing in status tab.

Your task is to add a forgot password button which the user can tap to trigger password reset using Firebase auth API. It will use the email from the login email text field as the email to reset the password.

When the app resumes login status from a previous session, tapping on the sign out button will lead to a black screen with a circular progress bar forever. Your task is to fix this and make sure it navigates to the sign in screen.

Your task is to change the screen title for the sign in screen from "Sign in" to "Time Since".

Your task is to generate a privacy notice for the app in `PRIVACY.md` file.

Your task is to use `branding/Gemini_Generated_Image_t7ux3xt7ux3xt7ux.png` as the new logo for the app. It should relace the current icon for ios, android app, favicon for web, and macos, linux and windows as well. Resize the image as needed.

Your task is to modify the current firebase firestore configuration so that only signed in users can access the path `/{uid}` where the uid is the uid of the signed in user.

Your task is to add a "upgrade" button to the settings screen which is used to navigate to the upgrade screen where user can use in-store purchase to subscribe to the premium version of the app.

Your task is to add a logic to limit the number of total items free tier user can add to 5, if a free tier user attemtps to add the 6th item, prompt the user to the upgrade screen.

Your task is to add config for building signed Android package.

Your task is to remove the "DEBUG" label on the top right corner of the screen.

Your task is to generate a feature graphics for google play store listing for my app with name "Time Since" which is an app that help keep track of the last occurence of things like changing HVAC filter, changing fridge filter, etc, all in one place. The style should follow the app icon uploaded.

Your task is to add a `short-description.md` and `full-description.md` under `branding/description` which should be the short and full description for the app in google store listing.

Your task is to add a text notice to the upgrade screen to say that the app is currently in beta testing phase and subscription is not yet available. Make this text an alert box.

Your task is to modify the bottom nav bar to make it have the same style as the example shown in `prototype/navbar_example.png`. The style includes the shape of the nav bar, the border and the shade.

Your task is change the currently slightly purple color in the theme to be white.

Your task is to modify the UI for the items in status screen to look like shown in @prototype/navbar_example.png more specifically, it should no longer be a card, but a list with dividers between each item. The functionalities should remain the same. The 2 buttons, and the last logged information and the name should remain the same.

Your task is to modify the buttons in status screen according the the style shown in @prototype/button_example.png where the "log now" button should take the style of "Done" button in the example, and "custom date" button should take on the style of "cancel" button in the example.

Your task is to make the 2 button stlyes in the status screen a reusable widget and use the button style widget that "custom date" uses for all other buttons in the app.

Your task is to modify the login screen UI to make it look like @prototype/login-screen-sample.png, use @assets/images/login-screen-pattern.png as the asset for the pattern for the background.

Your task is to update the sign up screen UI to match the login screen UI.

Your task is to add a password confirmation in the sign up screen, the sign up api should only be called if the password and confirmation password matches, otherwise, show a warning to let the user know the password does not match the password confirmation.

Your task is to show the user's email address in the settings screen.

Your task is to make the "sign out" and "upgrade" button fill 80% of the width of the screen.

Your task is to change the color of the add button on the manage screen to be the same color as the buttons.

Your task is to fix the visible toggle for password input in sign up screen and sign in screen to toggle the visibility of password.

Your task is to make sure the content of sign in screen and sign up screen shift upwards when the virtual keyboard is shown to let the user see the input.

Your task is to make sure the "logged in as" message in the settings screen is centered to the screen and have a 10% margin on each side, and wrap around to another line if necessary.

Your task is to change the user visible Android app name from "time_since" to "TimeSince".

your task is to modify the items in the management screen to make each item have 3 rows where 1st row is the item name, 2nd row is the item note and the 3rd row is the 2 buttons for delete and modify.

your task is to modify the sign in screen and sign up screen so that the auto fill in Android and iOS can recognize that this is credential and prompt the user to save passwords upon successful sign up or sign in and prompt user to choose to choose from saved credentials when the user wants to sign in.

Your task is to add a "delete account" button in the settings screen which should first open a pop up alert to inform the user of the consequence of the action, and then prompt the user to type in "DELETE" and tap on confirm button to confirm the deletion, and then delete all user data from the database and then delete the user from the authentication system.

Your task is to support internationalization for the app, only English and Chinese support is needed. Add a selector in the settings page to switch between Chinese, English, and system default.

your task is to fix the issue that when i tap on the add button on the manage screen, the title of the item is not editable where it should be editable.

=== Backlog ===

Your task is to use in_app_purchase package (https://pub.dev/packages/in_app_purchase#upgrading-or-downgrading-an-existing-in-app-subscription) to bring up in app purchase when the user tap on subscribe button on the upgrade screen. Here is an example code for using the package:
```
final PurchaseDetails oldPurchaseDetails = ...;
PurchaseParam purchaseParam = GooglePlayPurchaseParam(
    productDetails: productDetails,
    changeSubscriptionParam: ChangeSubscriptionParam(
        oldPurchaseDetails: oldPurchaseDetails,
        replacementMode: ReplacementMode.withTimeProration));
InAppPurchase.instance
    .buyNonConsumable(purchaseParam: purchaseParam);
```

=== TODO ===

your task is to make the border of the "delete account" button in the settings page have the same color as the button fill color which is red.
