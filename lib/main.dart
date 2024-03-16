import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ReInform Client',
      theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.

          ),
      home: const MyHomePage(title: 'ReInform'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var colorSwatch = {
    'primaryBase': Colors.grey,
    'secondaryBase': Colors.grey,
    'accentBase': Colors.grey,
    'primaryText': const Color.fromARGB(255, 255, 255, 255),
    'secondaryText': Colors.grey,
    'accentText': Colors.grey,
  };

  //Process for handling process button
  void _processInputText() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.

      //TODO: Do proccessing command
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color customColor = Color.fromARGB(255, 31, 29, 29);
    return Scaffold(
      backgroundColor: customColor,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
              top: 200, // Adjust this value as needed
              child: Text(
                'Please enter the prompt you wish to learn about:',
                style:
                    TextStyle(fontSize: 20, color: colorSwatch['primaryText']),
              ),
            ),
            Positioned(
              top: 250, // Adjust this value as needed
              left: 50, // Adjust this value as needed
              right: 250, // Adjust this value as needed
              child: TextField(
                style: TextStyle(color: colorSwatch['primaryText']),
                decoration: const InputDecoration(
                  hintText: 'Type here...',
                ),
              ),
            ),
            Positioned(
              top: 250, // Adjust this value as needed
              left: 1050, // Adjust this value as needed
              right: 10, // Adjust this value as needed
              child: new SizedBox(
                width: 100.0,
                height: 50.0,
                child: ElevatedButton(
                  child: Text(
                    'Process',
                    textScaleFactor: 2,
                  ),
                  onPressed: _processInputText,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void Enter() {
    // Code for the Enter Button
  }
}
