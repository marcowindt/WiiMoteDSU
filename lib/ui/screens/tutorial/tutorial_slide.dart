import 'package:flutter/material.dart';

/// Data for a single tutorial screen/slide.
class TutorialSlide {
  final IconData icon;
  final String title;
  final String body;

  /// When true, this slide uses [TutorialConfigurePageContent] (Configure Dolphin + tap for details).
  final bool isConfigurePage;

  const TutorialSlide({
    required this.icon,
    required this.title,
    required this.body,
    this.isConfigurePage = false,
  });
}
