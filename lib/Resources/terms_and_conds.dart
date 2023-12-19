import 'package:flutter/material.dart';

class TermsAndConds{

  static void showTermsAndConditionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text('VAIA Terms and Conditions'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section 1: Acceptance of Terms
                Text(
                  '1. Acceptance of Terms:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('By using the VAIA application and the measuring device, you agree to abide by these terms and conditions.'),

                SizedBox(height: 10),

                // Section 2: Proper Use
                Text(
                  '2. Proper Use:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('The VAIA application and measuring device are intended solely for monitoring contractions during pregnancy. They are not a substitute for professional medical advice. Users acknowledge their responsibility to seek medical advice for health concerns.'),

                SizedBox(height: 10),

                // Section 3: Privacy and Data Protection
                Text(
                  '3. Privacy and Data Protection:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('User personal data will be treated with the utmost confidentiality. By accepting these terms, the user consents to the processing of their personal data for the purpose of contraction monitoring and service improvement.'),

                SizedBox(height: 10),

                // Section 4: Intellectual Property
                Text(
                  '4. Intellectual Property:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('All intellectual property rights associated with the VAIA application and measuring device, including but not limited to copyrights, trademarks, and patents, are the exclusive property of VAIA. Users agree not to copy, modify, distribute, transmit, display, perform, reproduce, or create derivative works without the express authorization of VAIA.'),

                SizedBox(height: 10),

                // Section 5: Security of Information
                Text(
                  '5. Security of Information:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('Users are responsible for maintaining the confidentiality of their login information and must immediately report any unauthorized use of their account.'),


              ],
            ),
          ),
        );
      },
    );
  }
}