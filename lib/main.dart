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
                Map<String, dynamic> newRow = {
                  'name': enteredText,
                  'description': enteredText2,
                };
                await _dbHelper.insert(newRow);
                textField1.clear();
                textField2.clear();
                setState(() {});

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
        future: _dbHelper.queryAll('id'),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // If there is data in the database, display it
            List<Map<String, dynamic>> todos = snapshot.data!;
            return ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(todos[index]['id'].toString()),
                  onDismissed: (direction) async {
                    await _dbHelper.delete(todos[index]['id']);
                    setState(() {});
                  },
                  background: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.red,
                      ),
                      child: const Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.only(right: 16.0),
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: GestureDetector(
                      onDoubleTap: () {
                        print("DoubleTap");
                      },
                      child: Column(
                        children: [
                          tododescrip(
                            todos[index]['name'],
                            todos[index]['description'],
                          ),
                        ],
                      ),
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
        onPressed: () {
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
