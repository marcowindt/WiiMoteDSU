import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class TutorialStep extends StatelessWidget {
  final int number;
  final String text;
  final TextStyle style;

  const TutorialStep({
    super.key,
    required this.number,
    required this.text,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 24,
            child: Text(
              '$number.',
              style: style.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(text, style: style)),
        ],
      ),
    );
  }
}

class TutorialPhoneIpStep extends StatelessWidget {
  final TextStyle bodyStyle;

  const TutorialPhoneIpStep({super.key, required this.bodyStyle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, bottom: 10.0),
      child: FutureBuilder<String?>(
        future: NetworkInfo().getWifiIP(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return Text(
              'Your IP: ${snapshot.data}',
              style: bodyStyle.copyWith(fontWeight: FontWeight.w600),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Row(
              children: [
                SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                const SizedBox(width: 8),
                Text('Getting your IP…', style: bodyStyle),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class TutorialLinkText extends StatelessWidget {
  final String text;
  final String url;
  final TextStyle style;

  const TutorialLinkText({
    super.key,
    required this.text,
    required this.url,
    required this.style,
  });

  Future<void> _openUrl() async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _openUrl,
      child: Text(text, style: style),
    );
  }
}

/// Repository URL: setup guide and controller profile download.
const String tutorialRepoUrl = 'https://github.com/marcowindt/WiiMoteDSU';

class TutorialStepsContent extends StatelessWidget {
  const TutorialStepsContent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bodyStyle =
        theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurface,
          height: 1.4,
        ) ??
        const TextStyle();
    final boldStyle = bodyStyle.copyWith(fontWeight: FontWeight.w600);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 8),
          Text(
            'Client setup steps',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TutorialStep(
                number: 1,
                text: 'Open Controller Settings.',
                style: bodyStyle,
              ),
              TutorialStep(
                number: 2,
                text:
                    'Look for alternative input sources or DSU client settings and enable them.',
                style: bodyStyle,
              ),
              TutorialStep(number: 3, text: 'Check Enable.', style: bodyStyle),
              TutorialStep(number: 4, text: 'Click Add.', style: bodyStyle),
              TutorialStep(
                number: 5,
                text: 'Add a new DSU server entry.',
                style: bodyStyle,
              ),
              TutorialPhoneIpStep(bodyStyle: bodyStyle),
              TutorialStep(
                number: 6,
                text:
                    'Enter your phone\'s IP address, port number 26760, and give it a description.',
                style: bodyStyle,
              ),
              TutorialPhoneIpStep(bodyStyle: bodyStyle),
              TutorialStep(
                number: 7,
                text:
                    'With this app open, select "DSUClient/0/[your_description]" (your phone) as the input device.',
                style: bodyStyle,
              ),
              const SizedBox(height: 8),
              Text(
                '8. Map the buttons in Dolphin, or download the controller profile:',
                style: boldStyle,
              ),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '• Map buttons manually in your client\'s controller config, or',
                      style: bodyStyle,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '• Download a controller profile from the repository:',
                      style: bodyStyle,
                    ),
                    const SizedBox(height: 6),
                    TutorialLinkText(
                      text:
                          'Open repository (setup guide and profile download)',
                      url: tutorialRepoUrl,
                      style: bodyStyle.copyWith(
                        color: theme.colorScheme.primary,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ],
      ),
    );
  }
}
