import 'package:flutter/material.dart';
import 'tododescrip.dart';
import 'DatabaseHelper.dart'; // Import the DatabaseHelper class

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
  TextEditingController _textFieldController = TextEditingController();

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
                  controller: _textFieldController, // Assign the controller
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter a Topic',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                String enteredText = _textFieldController.text;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
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
        future: _dbHelper.queryAll(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // If there is data in the database, display it
            List<Map<String, dynamic>> todos = snapshot.data!;
            return ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Column(
                    children: [
                      tododescrip(
                          todos[index]['name'], todos[index]['description']),
                    ],
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
          // Dummy data for demonstration purposes
          // Map<String, dynamic> newRow = {
          //   'name': 'New Task 2',
          //   'description': 'Description for the new task',
          // };
          // Insert the new task into the database
          // await _dbHelper.insert(newRow);
          // await _dbHelper.deleteAll();
          // Retrieve all data from the database
          showMyDialog();
          setState(() {});
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
