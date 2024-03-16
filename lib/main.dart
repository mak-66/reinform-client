import 'package:flutter/material.dart';

void main() {
  runApp(ReInformApp());
}

class ReInformApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ReInform',
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
  final TextEditingController textController = TextEditingController();
  var outputs = <Map<String, String>>{};
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleSubmitted(String text) {
    setState(() {
      outputs.add({"input": text, "answer": "", "explanation": "", "links": ""});
      textController.clear();
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ReInform'), // Re-added title
      ),
      body: Column(
        children: [
          Expanded(
            child: outputs.isEmpty
                ? const Center(child: Text('No conversations yet'))
                : ListView.builder(
                    itemCount: outputs.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.all(8.0),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 40, 40, 40),
                            borderRadius: BorderRadius.all(Radius.circular(16.0)),
                          ),
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            outputs.elementAt(index)["input"] ?? '',
                            style: const TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    },
                    // Add the key and controller for ListView
                    key: ValueKey(outputs.length),
                    controller: _scrollController,
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
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 40, 40, 40),
                        borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        controller: textController,
                        maxLines: null,
                        decoration: InputDecoration.collapsed(
                          hintText: 'Enter a statement',
                          hintStyle: TextStyle(color: Colors.grey[500]),
                        ),
                        onSubmitted: _handleSubmitted,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () => _handleSubmitted(textController.text),
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
