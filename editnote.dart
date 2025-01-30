import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'addingnote.dart';
//import 'editnote.dart';

class EditNote extends StatefulWidget {
  final String noteId; // ID to identify which note to edit
  const EditNote({super.key, required this.noteId});

  @override
  _EditNoteState createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadNoteData();
  }

  Future<void> _loadNoteData() async {
    try {
      // Get the note from Firestore using the noteId
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('notes')
          .doc(widget.noteId)
          .get();

      // Check if the document exists
      if (doc.exists) {
        _titleController.text = doc['title'];
        _contentController.text = doc['content'];
      }
    } catch (e) {
      print("Error loading note: $e");
    }
  }

  // Logic to update the note in Firestore
  Future<void> _updateNote() async {
    try {
      await FirebaseFirestore.instance
          .collection('notes')
          .doc(widget.noteId)
          .update({
        'title': _titleController.text,
        'content': _contentController.text,
      });
      // Navigate back after saving
      Navigator.pop(context);
    } catch (e) {
      print("Error updating note: $e");
    }
  }

  // Logic to delete a note from Firestore
  Future<void> _deleteNote(String noteId) async {
    try {
      await FirebaseFirestore.instance.collection('notes').doc(noteId).delete();
      // Show success message after deletion
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Note deleted')),
      );
    } catch (e) {
      // Show error message if deletion fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting note')),
      );
      print("Error deleting note: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Note'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _updateNote,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text fields for editing the current note
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _contentController,
              maxLines: 8,
              decoration: InputDecoration(
                labelText: 'Content',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 32),
            // Displaying the list of all notes
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('notes')
                    .orderBy('timestamp') // Optional: Sort by timestamp
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No notes available.'));
                  }

                  var notes = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      var note = notes[index];
                      String noteId = note.id;
                      String noteTitle =
                          note['title']; // Assuming the field is 'title'
                      String noteContent =
                          note['content']; // Assuming the field is 'content'

                      return ListTile(
                        title: Text(noteTitle),
                        subtitle: Text(noteContent),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Edit button
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EditNote(noteId: noteId),
                                  ),
                                );
                              },
                            ),
                            // Delete button
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => _deleteNote(noteId),
                            ),
                          ],
                        ),
                        onTap: () {
                          // Navigate to edit screen on tap
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditNote(noteId: noteId),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
