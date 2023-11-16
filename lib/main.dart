import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'tododescrip.dart';
import 'DatabaseHelper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To Do List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.brown),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'To Do List'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  TextEditingController textField1 = TextEditingController();
  TextEditingController textField2 = TextEditingController();

  Future<void> showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New To Do'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: textField1,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter a Topic',
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: textField2,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter a Description',
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                textField1.clear();
                textField2.clear();
                // Perform any actions you want when the user presses Cancel
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () async {
                String enteredText = textField1.text;
                String enteredText2 = textField2.text;

                if (enteredText.length < 3 || enteredText2.length < 3) {
                  // Show an alert if the entered text is less than 3 characters
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Alert'),
                        content:
                            const Text('Text must be at least 3 characters.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  // Proceed with saving the data if the text is valid
                  Map<String, dynamic> newRow = {
                    'name': enteredText,
                    'description': enteredText2,
                  };
                  await _dbHelper.insert(newRow);
                  textField1.clear();
                  textField2.clear();
                  setState(() {});
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop(); // Close the dialog
                }
              },
            ),
          ],
        );
      },
    );
  }

  showDeleteDialog(BuildContext context, int index) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        _dbHelper.deleteByIndex(index);
        setState(() {});
        Navigator.pop(context);
      },
    );
    // set up the Cancel button
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Delete This To Do?"),
      content: Text("Are You Sure?"),
      actions: [
        cancelButton,
        okButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          widget.title,
          style: const TextStyle(
              fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _dbHelper.queryAll('id'),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // If there is data in the database, display it
            List<Map<String, dynamic>> todos = snapshot.data!;
            return ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final LongPressGestureRecognizer longPressGestureRecognizer =
                    LongPressGestureRecognizer()
                      ..onLongPress = () {
                        showDeleteDialog(context, index);
                        print("Index");
                        print(index);
                      };
                return Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: GestureDetector(
                    onDoubleTap: () {
                      showDeleteDialog(context, index);
                    },
                    onLongPress: longPressGestureRecognizer.onLongPress,
                    child: Column(
                      children: [
                        tododescrip(
                          todos[index]['name'],
                          todos[index]['description'],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            // If no data, display a loading indicator or an empty state
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          showMyDialog();
          // await _dbHelper.deleteAll();
          // setState(() {

          // });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
