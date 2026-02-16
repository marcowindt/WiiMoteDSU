import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wiimote_dsu/models/acc_settings.dart';
import 'package:wiimote_dsu/models/device_settings.dart';
import 'package:wiimote_dsu/models/gyro_settings.dart';

class FAQItem {
  final String question;
  final List<Details> details;

  FAQItem({required this.question, required this.details});
}

class Details {
  // these names suck
  final String short;
  final String long;

  Details({required this.short, required this.long});
}

final List<FAQItem> faqData = [
  FAQItem(
    question: "How to setup a stable IP address",
    details: [
      Details(
        short: "iPhone",
        long:
            "In Wi-Fi settings, tap the (i) icon next to your Wi-Fi and then set 'Private Wi-Fi Address' to Fixed instead of Rotating.",
      ),
      Details(
        short: "Android",
        long:
            "Long tap on your Wi-Fi, then click 'Modify network'. Set 'IP settings' to Static.",
      ),
    ],
  ),
  FAQItem(
    question: "How to solve app crash when you leave app and return",
    details: [
      Details(
        short: "Fix",
        long:
            "Close and reopen the app. Then, reselect the slot you were using. You may need to reconfigure the controller in your DSU client.",
      ),
      Details(
        short: "Explanation",
        long:
            "This issue occurs due to a bug with subscriptions failing after the app is backgrounded.",
      ),
    ],
  ),
  FAQItem(
    question: "Could volume buttons be used as triggers or the B button?",
    details: [
      Details(
        short: "iPhone",
        long:
            "No. The App Store does not allow apps to intercept hardware buttons. However, you can build the app with this feature yourself and sideload it.",
      ),
    ],
  ),
];

class FaqScreen extends StatefulWidget {
  _FaqScreen createState() => _FaqScreen();
}

class _FaqScreen extends State<FaqScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('FAQ')),
      body: Consumer3<GyroSettings, AccSettings, DeviceSettings>(
        builder:
            (
              BuildContext context,
              GyroSettings gyroSettings,
              AccSettings accSettings,
              DeviceSettings deviceSettings,
              Widget? child,
            ) {
              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: faqData.length,
                itemBuilder: (context, sectionIndex) {
                  final section = faqData[sectionIndex];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      Text(
                        section.question,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 12),

                      ...section.details.map(
                        // https://stackoverflow.com/questions/62667990/how-to-remove-the-divider-lines-of-an-expansiontile-when-expanded-in-flutter
                        (exp) => Theme(
                          data: Theme.of(
                            context,
                          ).copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            title: Text(
                              exp.short,
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                child: Text(exp.long),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
      ),
    );
  }
}
