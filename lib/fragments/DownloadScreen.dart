import 'package:flutter/material.dart';

class DownloadScreen extends StatelessWidget {
  const DownloadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Downloads",
          style: TextStyle(fontSize: 25),
        ),
      ),
      body: Center(
        child: Text(
          "This is download page",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
