import 'package:flutter/material.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
// import 'dart:developer';
import 'sqldb.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NotesPage(),
    );
  }
}

class NotesPage extends StatefulWidget {
  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final SqlDB sqlDB = SqlDB();

  //عشان اخد الداتا من ال sqldb
  final TextEditingController titleController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  List<Map> notes = []; //عشان اخزن الداتا اللي جايه من ال sqldb

  @override
  void initState() {
    super.initState();
    _loadNotes(); // Fetch notes when the widget is initialized
  }

  // عشان اعرض الداتا اللي جايه من ال sqldb
  void _loadNotes() async {
    List<Map> response = await read('notes'); // Read notes from the database
    setState(() {
      notes = response; // Update the state with the fetched notes
    });
  }

  void _addNote() async {
    if (titleController.text.isNotEmpty) {
      await insert(
        'notes',
        {'title': titleController.text, 'note': noteController.text}
      );
      titleController.clear();
      noteController.clear();
      _loadNotes(); // اعادة تحميل الملاحظات بعد الإضافة
    }
  }

  //تحديث الملاحظة
  void _updateNote(int id) async {
    await update(
      'notes', 
      {'title': titleController.text, 'note': noteController.text},
      'id = ?', [id] // منعرفش انهي مكان اللي هيتحدث فهنعمل ؟ و الماب هبقي اعرف منها مين اللي اتغير بعدين
    );
    _loadNotes(); // اعادة تحميل الملاحظات بعد التحديث
  }

  //حذف الملاحظة
  void _deleteNote(int id) async {
    await delete('notes', 'id = $id' , );
    _loadNotes(); // اعادة تحميل الملاحظات بعد الحذف
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Notes'),
        titleTextStyle: TextStyle(
          color: Colors.purpleAccent,
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: noteController,
              decoration: InputDecoration(labelText: 'Note'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  _addNote();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purpleAccent,
              ), 
              child: Text(
                'Add Note' , 
                style: TextStyle(
                  fontSize: 20 , 
                  fontWeight: FontWeight.bold , 
                  color: Colors.white 
                  ),
              ),
            ),
            Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context , index) {
                  return Card(
                    child: ListTile(
                      title: Text(notes[index]['title']),
                      subtitle: Text(notes[index]['note'] ?? ''), // Handle null note لو الملاحظة فاضية رجع " "
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min, // هياخد مساحه ع قد النوت فقط
                        children: [
                          //to update note
                          IconButton(
                            onPressed: ()=> _updateNote(notes[index]['id']),
                            icon: Icon(Icons.edit, color: Colors.purple[200]),
                          ), 
                          //to delete note
                          IconButton(
                            onPressed: ()=> _deleteNote(notes[index]['id']),
                            icon: Icon(Icons.delete, color: Colors.purple[200]),
                          ),
                        ],
                      ),
                    ),
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

