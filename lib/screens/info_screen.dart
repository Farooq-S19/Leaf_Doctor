import 'package:flutter/material.dart';
import '../core/constants.dart';

class InfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBg,
      appBar: AppBar(title: const Text("System Info"), backgroundColor: AppColors.lightBg, elevation: 0),
      body: const Padding(
        padding: EdgeInsets.all(24.0),
        child: Text("LeafDoctor AI Research v3.1\n\nDeveloped for automated tomato leaf disease classification using EfficientNet architecture."),
      ),
    );
  }
}