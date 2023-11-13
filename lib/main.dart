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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          widget.title,
          style: const TextStyle(fontSize: 25, color: Colors.white),
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
                return tododescrip(
                  todos[index]['name'],
                  todos[index]['description'],
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
          Map<String, dynamic> newRow = {
            'name': 'New Task',
            'description': 'Description for the new task',
          };
          // Insert the new task into the database
          await _dbHelper.insert(newRow);
          // Retrieve all data from the database
          List<Map<String, dynamic>> allData = await _dbHelper.queryAll();
          // Print the data as a log
          print('Database Datas: $allData');
          
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
