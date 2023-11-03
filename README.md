# happy - Birthdays Reminder App

## Objective

Develop a personalized iOS application using Swift to help myself keep track of friends' birthdays, fostering closer connections by celebrating these special occasions.

## Features

- [x] **Birthday Viewing** Get notified & view upcoming birthdays in a minimalist, clean interface.
- [x] **Birthday Wishes** Pre-loaded or custom message templates for sending birthday wishes.
- [x] **Birthday Importing** Import birthdays from phone contacts
- [x] **Birthday Management** Update existing birthdays with an intuitive UI
- **Apple Watch Wallpaper** Show initials or profile pics on hour titles for upcoming birthdays
- **Birthday Sharing** Share a link to your profile; friends can choose to share their birthdays with you, which will then be automatically added to your calendar.
- **Widget** A home screen widget displaying the next upcoming birthday.


## Competitive Edge

The Birthday Reminder App is designed to carve a unique space in the app market by doing one thing exceptionally well - managing birthday reminders in a way that is intuitive, elegant, and enjoyable. Unlike other apps that may clutter the user experience with additional features, this app will focus solely on providing a superior user experience in birthday management. The minimalist, clean, and aesthetically pleasing UI/UX will not only make the app incredibly easy to use but also enjoyable. By reducing the cognitive load on the user and making the process of tracking and celebrating birthdays seamless, the app aims to stand out from the competition. This focused approach, coupled with a beautiful design, positions the Birthday Reminder App as a tool that elegantly solves a specific problem, which in turn, enhances its appeal and usability.

## Technical Details

We will use SwiftUI to ensure we get the most out of the iOS ecosystem. This app will be hyper-customized for Apple Devices making use of all the nice available little features. The first version will be optimized for use on iPhone with later versions targetting iPad and MacBook.

### Guidelines

#### Determining File Placement

- **Components**: If the file defines a reusable UI element that does not interact with any data fetching logic or network calls, it belongs in the `Components` folder. Examples include custom buttons, avatars, or other reusable UI elements.
- **Views**: Files in this category are primarily responsible for displaying data and user interfaces. If the file defines a view that requires data to be fetched or manipulated to present the user interface, it belongs in the `Views` folder. This folder is for larger screen layouts or views that aggregate data and user interactions on a single screen.
- **Models**: Model files define the data structures and objects that your application uses. If the file represents a data entity or object model, it belongs in the `Models` folder. These files should contain plain Swift structs or classes used to represent data and should not contain any business logic.
- **ViewModels**: ViewModel files are the bridge between Views and Models. They contain the logic for manipulating data to present to the Views. If the file is used to handle the manipulation and management of data for presentation, it belongs in the `ViewModels` folder.
- **Services**: Service files encapsulate specific functionality such as network requests, data fetching, or other utilities that are used across the application. If the file defines a service or utility function related to network calls, data fetching, or other core functionalities, it belongs in the `Services` folder.
- **Helpers**: Helper files provide utility functions or extensions that are used across the app. If the file defines functionality or extensions to existing types to provide utility across the app, it belongs in the `Helpers` folder.
- **Widgets**: Widgets are self-contained pieces of functionality that can be displayed outside of the main app UI. If the file defines a widget, it belongs in the `Widgets` folder.
- **Resources**: This folder should contain assets, storyboards, and other non-code resources necessary for the app.
- **SupportingFiles**: Files that are globally used or pertain to the app configuration, such as `Info.plist` or `Main.swift`, belong here.

#### Naming Conventions

- Use PascalCase for file names and folder names (e.g., `AvatarView.swift`, `Components`).
- Name files and folders descriptively to reflect their purpose within the app (e.g., `DateHelpers.swift` for helper functions related to date formatting).
