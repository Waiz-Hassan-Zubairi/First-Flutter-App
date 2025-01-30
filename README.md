### README for Notepad Manager App

---

## Project Overview

**Notepad Manager** is a simple Flutter-based app integrated with Firebase for managing notes. Users can add, edit, view, and delete notes. The app is designed to offer a seamless experience for users to store, update, and manage their notes using Firebase Firestore for backend data storage and Firebase Authentication for secure login functionality.

### Features:
1. **User Authentication**:
   - Firebase Authentication is used for user login and authentication. Users can log in using their email and password.

2. **Notes Management**:
   - **Add Notes**: Users can create a new note by providing a title and content.
   - **Edit Notes**: Users can select a note from a list of their existing notes and edit the title and content.
   - **View Notes**: A user can view the list of available notes with their titles and IDs.
   - **Delete Notes**: Users can delete a selected note from the database.

3. **Real-time Sync**: Firebase Firestore is used to store and sync notes data in real-time.

4. **UI**: A clean and responsive UI design built using Flutter's Material components.

---

## Tech Stack

- **Flutter**: Frontend for building cross-platform mobile applications.
- **Firebase Authentication**: Handles user authentication for login.
- **Firebase Firestore**: Cloud NoSQL database used for storing and retrieving notes in real time.

---

## Requirements

- Flutter SDK: Latest stable version (2.10.0 or above)
- Firebase account with Firestore and Firebase Authentication enabled
- Android Studio or Visual Studio Code for development

### Dependencies:
You will need to add the following dependencies to your `pubspec.yaml` file:
```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: "^2.4.0"
  firebase_auth: "^4.1.0"
  cloud_firestore: "^4.1.0"
```

Make sure to run:
```bash
flutter pub get
```

---

## Firebase Setup

1. **Create a Firebase Project**:  
   Go to the [Firebase Console](https://console.firebase.google.com/) and create a new Firebase project.

2. **Enable Firebase Authentication**:
   - Navigate to the Firebase Console -> Authentication -> Sign-in method.
   - Enable the **Email/Password** sign-in provider.

3. **Enable Firestore Database**:
   - Go to Firebase Console -> Firestore Database.
   - Click on **Create Database** and start in **Test Mode** for development purposes.

4. **Add Firebase Configuration to Flutter**:
   - Download the `google-services.json` file (for Android) and add it to the `android/app` directory.
   - For iOS, follow the official [Firebase documentation](https://firebase.google.com/docs/flutter/setup?platform=ios) to integrate Firebase.

---

## How to Run

1. **Clone the repository**:
   ```bash
   git clone <repository-url>
   ```

2. **Open the project** in your preferred IDE (e.g., VS Code or Android Studio).

3. **Install dependencies**:
   ```bash
   flutter pub get
   ```

4. **Configure Firebase**:
   - Ensure you have added your `google-services.json` for Android (and configured for iOS).

5. **Run the app**:
   ```bash
   flutter run
   ```

---

## Folder Structure

```
/lib
│
├── /screens
│   ├── addingnote.dart           # Screen for adding a note
│   ├── editnote.dart             # Screen for editing a note
│   ├── deletenote.dart           # Screen for deleting a note
│   ├── noteslist.dart            # Screen for listing notes for selection
│   └── login_page.dart           # Screen for user login
│
├── /widgets
│   └── custom_widgets.dart       # Custom UI components/widgets (if any)
│
└── main.dart                     # Main entry point of the app
```

---

## Key Files and Their Purpose

### 1. `login_page.dart`
   - The login page allows users to authenticate using Firebase Authentication. Users are prompted for their email and password. Once successfully authenticated, they are navigated to the home screen where they can manage their notes.

### 2. `homescreen.dart`
   - Displays the main options to the user: Add, Edit, Delete, and View Notes. The user can choose what action to perform.

### 3. `addingnote.dart`
   - Contains the UI and logic to add a new note. When a user submits the note, it's saved to Firebase Firestore.

### 4. `editnote.dart`
   - The screen where users can edit the content of an existing note. The note ID is passed as a parameter, and data is fetched from Firestore.

### 5. `noteslist.dart`
   - Lists all the notes stored in Firestore, showing their titles and IDs. Users can select a note from the list to edit.

### 6. `deletenote.dart`
   - Enables the user to delete a selected note by interacting with the Firestore database.

---

## Code Snippets

### Authentication (Firebase Login)
```dart
void _login() async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );
    // Handle successful login
  } catch (e) {
    // Handle login error
  }
}
```

### Firestore Note Fetch and Display (NotesListScreen)
```dart
StreamBuilder<QuerySnapshot>(
  stream: FirebaseFirestore.instance.collection('notes').snapshots(),
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      final notes = snapshot.data!.docs;
      return ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];
          return ListTile(
            title: Text(note['title']),
            onTap: () {
              // Navigate to edit note screen
            },
          );
        },
      );
    }
    return CircularProgressIndicator();
  }
)
```

### Firestore Update Note (EditNote Screen)
```dart
Future<void> _updateNote() async {
  await FirebaseFirestore.instance.collection('notes').doc(widget.noteId).update({
    'title': _titleController.text,
    'content': _contentController.text,
  });
}
```

---

## Future Improvements

- **User Registration**: Add a registration screen for new users.
- **Note Categories**: Implement categories or labels for better note organization.
- **Rich Text Editing**: Add formatting options (bold, italic, etc.) for note content.
- **Search Feature**: Implement a search bar to find specific notes.

---

## Conclusion

The Notepad Manager app is a powerful yet simple tool for managing notes using Firebase. It showcases integration with Firebase Authentication for secure login and Firestore for real-time data storage. Feel free to modify and enhance the app based on your use case.
