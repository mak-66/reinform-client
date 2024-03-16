import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for RawKeyboardListener

void main() {
  runApp(const ReInformApp());
}

class ReInformApp extends StatelessWidget {
  const ReInformApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: const ReInformHomePage(),
    );
  }
}

class ReInformHomePage extends StatefulWidget {
  const ReInformHomePage({super.key});

  @override
  _ReInformHomePageState createState() => _ReInformHomePageState();
}

class _ReInformHomePageState extends State<ReInformHomePage> {
  final TextEditingController _textController = TextEditingController();
  String _outputText = "";
  bool output = false;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _handleSubmitted(String text) {
    if (text.trim().isEmpty) {
      // If input is empty, just clear the text field
      _textController.clear();
      return;
    }

    setState(() {
      _outputText +=
          'User:\n>>> $text\nRe-Inform:\n<<< ${text.split('').reversed.join()}\n\n';
      _textController.clear();
      output = false; // Reset output after submission
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ReInform'), // Title of the app
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: _outputText.isEmpty
                    ? null
                    : Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius:
                              const BorderRadius.all(Radius.circular(16.0)),
                        ),
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          _outputText,
                          style: const TextStyle(
                              fontSize: 16.0, color: Colors.white),
                        ),
                      ),
              ),
            ),
          ),
          Container(
            color: Theme.of(context).primaryColor,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius:
                            const BorderRadius.all(Radius.circular(16.0)),
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: RawKeyboardListener(
                        focusNode: FocusNode(), // Optional: manage focus
                        onKey: (RawKeyEvent event) {
                          if (event.logicalKey == LogicalKeyboardKey.enter) {
                            _handleSubmitted(_textController.text);
                            output = false; // Reset output on Enter press
                          }
                        },
                        child: TextField(
                          controller: _textController,
                          maxLines: null, // Allow for multi-line input
                          decoration: const InputDecoration.collapsed(
                            hintText: 'Enter your prompt',
                            hintStyle: TextStyle(color: Colors.white),
                          ),
                          onSubmitted:
                              _handleSubmitted, // Handle text submission
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () => _handleSubmitted(_textController.text),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
