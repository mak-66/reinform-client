import 'package:flutter/material.dart';

void main() {
  runApp(ReInformApp());
}

class ReInformApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: ReInformHomePage(),
    );
  }
}

class ReInformHomePage extends StatefulWidget {
  @override
  _ReInformHomePageState createState() => _ReInformHomePageState();
}

class _ReInformHomePageState extends State<ReInformHomePage> {
  final TextEditingController _textController = TextEditingController();
  String _outputText = "";

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _handleSubmitted(String text) {
    setState(() {
      _outputText +=
          '\n\nUser:\n>>> $text\n\nRe-Inform:\n<<< ${text.split('').reversed.join()}';
      _textController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ReInform'), // Re-added title
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                // Only show output container if _outputText is not empty
                child: _outputText.isEmpty
                    ? null // Conditionally render the output container
                    : Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[700],
                          borderRadius: BorderRadius.all(Radius.circular(16.0)),
                        ),
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          _outputText,
                          style: TextStyle(fontSize: 16.0, color: Colors.white),
                        ),
                      ),
              ),
            ),
          ),
          Container(
            color: Theme.of(context).primaryColor,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[700],
                        borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      ),
                      padding: EdgeInsets.all(16.0),
                      child: TextField(
                        controller: _textController,
                        maxLines: null,
                        decoration: InputDecoration.collapsed(
                          hintText: 'Enter your prompt',
                          hintStyle: TextStyle(color: Colors.white70),
                        ),
                        onSubmitted: _handleSubmitted,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
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
