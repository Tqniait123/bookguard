import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../configs.dart';

class CallUsButton extends StatelessWidget {
  final String phoneNumber; // e.g., "+201234567890"

  const CallUsButton({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: AppButton(
        enableScaleAnimation: false,
        color: defaultPrimaryColor,
        width: context.width(),
        onTap: () => _showContactOptions(context),
        child: Marquee(
          child: Text(
            'Call Us',
            style: boldTextStyle(size: 14, color: whiteColor),
          ),
        ),

      ),
    );
  }

  void _showContactOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.call, color: Colors.green),
              title: Text("Call"),
              onTap: () => _launchPhone(),
            ),
            ListTile(
              leading: Icon(Icons.message, color: Colors.teal),
              title: Text("WhatsApp"),
              onTap: () => _launchWhatsApp(),
            ),
          ],
        ),
      ),
    );
  }

  void _launchPhone() async {
    final uri = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _launchWhatsApp() async {
    final whatsappUrl = Uri.parse('https://wa.me/${phoneNumber.replaceAll('+', '')}');
    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
    }
  }
}