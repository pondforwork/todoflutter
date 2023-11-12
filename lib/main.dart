import 'package:flutter/material.dart';
import 'tododescrip.dart';

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
        home: const MyHomePage(title: 'To Do List'));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
      body: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              tododescrip("name",  "Description Here"),
              SizedBox(height: 10,),
              tododescrip("name", "Description Here")
            ],
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () => null,
        child: const Icon(Icons.add),
      ),
    );
  }
}
