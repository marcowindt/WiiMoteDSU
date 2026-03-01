import 'package:flutter/material.dart';
import 'package:wiimote_dsu/ui/screens/tutorial/tutorial_slide.dart';

/// Tutorial content for a single page. [isActive] drives enter animation.
class TutorialPageContent extends StatelessWidget {
  final bool isActive;
  final TutorialSlide slide;

  const TutorialPageContent({
    super.key,
    required this.isActive,
    required this.slide,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isActive ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 280),
      child: AnimatedSlide(
        offset: isActive ? Offset.zero : const Offset(0, 0.08),
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(slide.icon, size: 72, color: Theme.of(context).primaryColor),
              const SizedBox(height: 24),
              Text(
                slide.title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              Text(
                slide.body,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[700],
                      height: 1.4,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
