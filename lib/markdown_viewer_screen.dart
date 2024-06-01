import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MarkdownViewerScreen extends StatelessWidget {
  final String filePath;
  final String contents;

  const MarkdownViewerScreen(
      {required this.filePath, required this.contents, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(contents),
      ),
      body: FutureBuilder(
        future: rootBundle.loadString(filePath),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Markdown(data: snapshot.data!);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
