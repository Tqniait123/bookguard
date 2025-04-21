import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';
import '../../utils/common.dart';

class PaymentSuccessPage extends StatelessWidget {
  const PaymentSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8F6),
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      color: Color(0xFF4CAF50),
                      size: 100,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Payment Successful!',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Thank you for your payment.\nYour transaction was completed successfully.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF4E5D6A),
                      ),
                    ),

                  ],
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: rtlSupport.contains(appStore.selectedLanguageCode) ? null : 8,
              right: rtlSupport.contains(appStore.selectedLanguageCode) ? 8 : null,
              child: IconButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(Color(0xFFFFFFFF)),
                  backgroundColor: MaterialStateProperty.all(Color(0xFF876A48)), // Brown color
                  shape: MaterialStateProperty.all(
                    CircleBorder(),
                  ),
                  padding: MaterialStateProperty.all(EdgeInsets.all(12)), // Adjust size
                ),
                icon: Icon(Icons.arrow_back_outlined),
                onPressed: () {
                  finish(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}