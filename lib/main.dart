import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for RawKeyboardListener

void main() {
  runApp(const ReInformApp());
}

class ReInformApp extends StatelessWidget {
  const ReInformApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: const ReInformHomePage(),
    );
  }
}

class UserInputOutput {
  final String input;
  final String output;

  UserInputOutput({
    required this.input,
    required this.output,
  });
}

class ReInformHomePage extends StatefulWidget {
  const ReInformHomePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ReInformHomePageState createState() => _ReInformHomePageState();
}

class _ReInformHomePageState extends State<ReInformHomePage>
    with TickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<UserInputOutput> _userInputOutputs = [];

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleSubmitted(String text) {
    if (text.trim().isEmpty) {
      // If input is empty, just clear the text field
      _textController.clear();
      return;
    }

    final userInputOutput = UserInputOutput(
      input: text,
      output: text.split('').reversed.join(),
    );

    setState(() {
      _userInputOutputs.add(userInputOutput);
      _textController.clear();
    });

    // Scroll to the end of the list
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );

    // Add animation to the newly added item
    _listKey.currentState!.insertItem(_userInputOutputs.length - 1);
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
            child: AnimatedList(
              key: _listKey,
              controller: _scrollController,
              initialItemCount: _userInputOutputs.length,
              itemBuilder: (context, index, animation) {
                final userInputOutput = _userInputOutputs[index];
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, -0.1),
                      end: Offset.zero,
                    ).animate(animation),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'User:',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              '>>> ${userInputOutput.input}',
                              style: const TextStyle(
                                fontSize: 16.0,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            const Text(
                              'Re-Inform:',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              '<<< ${userInputOutput.output}',
                              style: const TextStyle(
                                fontSize: 16.0,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
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
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      padding: const EdgeInsets.all(16.0),
                      // ignore: deprecated_member_use
                      child: RawKeyboardListener(
                        focusNode: FocusNode(), // Optional: manage focus
                        // ignore: deprecated_member_use
                        onKey: (RawKeyEvent event) {
                          if (event.logicalKey == LogicalKeyboardKey.enter) {
                            _handleSubmitted(_textController.text);
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
