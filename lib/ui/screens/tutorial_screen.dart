import 'package:flutter/material.dart';
import 'package:wiimote_dsu/ui/screens/tutorial/tutorial_configure_page_content.dart';
import 'package:wiimote_dsu/ui/screens/tutorial/tutorial_detail_screen.dart';
import 'package:wiimote_dsu/ui/screens/tutorial/tutorial_page_content.dart';
import 'package:wiimote_dsu/ui/screens/tutorial/tutorial_slide.dart';

class TutorialScreen extends StatefulWidget {
  final void Function(BuildContext context) onComplete;

  const TutorialScreen({Key? key, required this.onComplete}) : super(key: key);

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  static const _slides = <TutorialSlide>[
    TutorialSlide(
      icon: Icons.wifi,
      title: 'DSU server on your network',
      body:
          'This app acts as a DSU protocol server, sending controller and motion input over Wi-Fi to any compatible application on your network.',
    ),
    TutorialSlide(
      icon: Icons.info_outline,
      title: 'Not for a real game console',
      body:
          'Designed for compatible emulators only—not for an actual game console.',
    ),
    TutorialSlide(
      icon: Icons.settings,
      title: 'Configure your client',
      body:
          'In your DSU client application, add this device as an input source. Use your phone\'s IP and port 26760.',
      isConfigurePage: true,
    ),
  ];

  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _pushDetailScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const TutorialDetailScreen()),
    );
  }

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      final page = _pageController.page?.round() ?? 0;
      if (page != _currentPage) setState(() => _currentPage = page);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onComplete() => widget.onComplete(context);

  void _onNext() {
    if (_currentPage >= _slides.length - 1) {
      _onComplete();
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = _currentPage == _slides.length - 1;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _onComplete,
                child: const Text('Skip'),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _slides.length,
                itemBuilder: (context, index) {
                  final slide = _slides[index];
                  if (slide.isConfigurePage) {
                    return TutorialConfigurePageContent(
                      isActive: index == _currentPage,
                      onShowDetails: () => _pushDetailScreen(context),
                      slide: slide,
                    );
                  }
                  return TutorialPageContent(
                    isActive: index == _currentPage,
                    slide: slide,
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _slides.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == i ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == i
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _onNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(isLastPage ? 'Get started' : 'Next'),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
