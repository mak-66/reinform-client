import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for RawKeyboardListener
import 'package:http/http.dart' as http;
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const ReInformApp());
}

class ReInformApp extends StatelessWidget {
  const ReInformApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ReInform',
      theme: ThemeData.dark(),
      home: const ReInformHomePage(),
    );
  }
}

class UserInputOutput {
  final String stmnt;
  final String answer;
  final String explanation;

  UserInputOutput({
    required this.stmnt,
    required this.answer,
    required this.explanation,
  });
}

class ReInformHomePage extends StatefulWidget {
  const ReInformHomePage({Key? key}) : super(key: key);

  @override
  _ReInformHomePageState createState() => _ReInformHomePageState();
}

class _ReInformHomePageState extends State<ReInformHomePage>
    with TickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<UserInputOutput> _userInputOutputs = [];
  bool _isLoading = false;

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

    setState(() {
      _isLoading = true;
    });

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      // Scroll to the end of the list after the new item has been inserted and animated
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });

    http
        .put(
      Uri.parse('http://153.106.93.49/'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "stmnt": text,
      }),
    )
        .then((value) {
      var data = jsonDecode(value.body);

      String links = "";
      for (var link in data["links"]) {
        links += link + "\n";
      }

      final userInputOutput = UserInputOutput(
        stmnt: text,
        answer: data["answer"],
        explanation: data["explanation"] + "\n\n" + links,
      );

      setState(() {
        _userInputOutputs.add(userInputOutput);
        _isLoading = false;
      });

      // Add animation to the newly added item
      _listKey.currentState!.insertItem(_userInputOutputs.length - 1);

      WidgetsBinding.instance!.addPostFrameCallback((_) {
        // Scroll to the end of the list after the new item has been inserted and animated
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }).catchError((error) {
      setState(() {
        _isLoading = false;
      });
      // Handle error here
      print("Error: $error");
    });

    // Clear text input after submission
    setState(() {
      _textController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    const icons = {
      "true": Icon(Icons.check_circle_outline, color: Colors.green, size: 20.0),
      "false": Icon(Icons.highlight_off, color: Colors.red, size: 20.0),
      "unknown": Icon(Icons.help_outline, color: Colors.blue, size: 20.0),
      "controversial":
          Icon(Icons.error_outline, color: Colors.yellow, size: 20.0),
    };

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
                              vertical: 10.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromARGB(255, 40, 40, 40),
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  child: Text(
                                    userInputOutput.stmnt,
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10.0),
                                Container(
                                  padding: const EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromARGB(255, 40, 40, 40),
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            icons[userInputOutput.answer] ??
                                                const Icon(
                                                    Icons.check_circle_outline),
                                            const SizedBox(width: 4.0),
                                            Text(
                                              userInputOutput.answer,
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                color: icons[
                                                        userInputOutput.answer]
                                                    ?.color,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ]),
                                      const SizedBox(height: 4.0),
                                      Linkify(
                                        onOpen: (link) async {
                                          if (!await launchUrl(Uri.parse(link.url))) {
                                            throw Exception('Could not launch ${link.url}');
                                          }
                                        },
                                        text: userInputOutput.explanation,
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.white,
                                        ),
                                        linkStyle: const TextStyle(
                                          fontSize: 12.0,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                (_isLoading && index == _userInputOutputs.length - 1)
                                ? const Positioned.fill(
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                : const SizedBox(height: 0.1)
                              ],
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
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 40, 40, 40),
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          padding: const EdgeInsets.all(16.0),
                          // ignore: deprecated_member_use
                          child: RawKeyboardListener(
                            focusNode: FocusNode(), // Optional: manage focus
                            // ignore: deprecated_member_use
                            onKey: (RawKeyEvent event) {
                              if (event.logicalKey ==
                                  LogicalKeyboardKey.enter) {
                                _handleSubmitted(_textController.text);
                              }
                            },
                            child: TextField(
                              controller: _textController,
                              maxLines: null, // Allow for multi-line input
                              decoration: const InputDecoration.collapsed(
                                hintText: 'Enter a statement',
                                hintStyle: TextStyle(
                                    color: Color.fromARGB(255, 103, 103, 103)),
                              ),
                              onSubmitted:
                                  _handleSubmitted, // Handle text submission
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.task_alt, size: 30.0),
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
