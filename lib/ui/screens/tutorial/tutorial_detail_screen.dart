import 'package:flutter/material.dart';
import 'package:wiimote_dsu/ui/screens/tutorial/tutorial_steps_content.dart';

/// Full-screen page that shows the Dolphin setup steps (used when user taps for details).
class TutorialDetailScreen extends StatelessWidget {
  const TutorialDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Step-by-step instructions'),
      ),
      body: SingleChildScrollView(
        child: const TutorialStepsContent(),
      ),
    );
  }
}
