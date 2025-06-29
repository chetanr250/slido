import 'package:flutter/material.dart';

class PastResultsScreen extends StatelessWidget {
  const PastResultsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Past Results'),
      ),
      body: const Center(
        child: Text('Past results will be shown here.'),
      ),
    );
  }
}
