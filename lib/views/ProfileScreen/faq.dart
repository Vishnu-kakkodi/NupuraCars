
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:url_launcher/url_launcher.dart';

// class FAQScreen extends StatefulWidget {
//   const FAQScreen({Key? key}) : super(key: key);

//   @override
//   State<FAQScreen> createState() => _FAQScreenState();
// }

// class _FAQScreenState extends State<FAQScreen> {
//   final List<FAQItem> faqItems = [
//     FAQItem(
//       question: "How do I book a car?",
//       answer:
//           "Select your desired car, choose pickup and return dates/times, upload required documents, select security deposit, and confirm your booking.",
//     ),
//     FAQItem(
//       question: "What documents do I need?",
//       answer:
//           "You need a valid Aadhar Card and Driving License. Make sure all documents are clear and valid.",
//     ),
//     FAQItem(
//       question: "Can I extend my booking?",
//       answer:
//           "Yes, you can extend your booking from the booking details page. Additional charges will apply based on hourly or daily rates.",
//     ),
//     FAQItem(
//       question: "What are the security deposit options?",
//       answer:
//           "We accept Bike, Laptop, or Cash as security deposit. The deposit will be returned after successful completion of your trip.",
//     ),
//     FAQItem(
//       question: "How do I cancel a booking?",
//       answer:
//           "You can cancel your booking from the booking details page. Cancellation charges may apply based on the timing of cancellation.",
//     ),
//     FAQItem(
//       question: "What if I'm late for pickup?",
//       answer:
//           "Please contact our customer support immediately. Late pickup may result in additional charges or booking cancellation.",
//     ),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: AppBar(
//         title: const Text('FAQ'),
//         elevation: 0,
//         centerTitle: true,
//         backgroundColor: Colors.deepPurple,
//         systemOverlayStyle: SystemUiOverlayStyle.light,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Contact Support Section
//             // const SizedBox(height: 12),
//             // Row(
//             //   children: [
//             //     Expanded(
//             //       child: _buildContactCard(
//             //         icon: Icons.phone_in_talk,
//             //         title: 'Call Us',
//             //         subtitle: '+91 6303092897',
//             //         color: Colors.deepPurple,
//             //         onTap: () => _makePhoneCall('+916303092897'),
//             //       ),
//             //     ),
//             //     const SizedBox(width: 12),
//             //     Expanded(
//             //       child: _buildContactCard(
//             //         icon: Icons.email_outlined,
//             //         title: 'Email Us',
//             //         subtitle: 'automotives23@gmail.com',
//             //         color: Colors.green,
//             //         onTap: () =>
//             //             _sendEmail('automotives23@gmail.com'),
//             //       ),
//             //     ),
//             //   ],
//             // ),
//             // const SizedBox(height: 24),

//             // FAQ Section
//             _buildSectionHeader('Frequently Asked Questions'),
//             const SizedBox(height: 12),
//             _buildFAQList(),

//             const SizedBox(height: 24),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSectionHeader(String title) {
//     return Text(
//       title,
//       style: const TextStyle(
//         fontSize: 20,
//         fontWeight: FontWeight.bold,
//         color: Colors.black87,
//       ),
//     );
//   }

//   Widget _buildContactCard({
//     required IconData icon,
//     required String title,
//     required String subtitle,
//     required Color color,
//     required VoidCallback onTap,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(16),
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: color.withOpacity(0.1),
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black12,
//               blurRadius: 6,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Column(
//           children: [
//             Icon(icon, size: 32, color: color),
//             const SizedBox(height: 8),
//             Text(
//               title,
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: color,
//               ),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               subtitle,
//               style: const TextStyle(fontSize: 12, color: Colors.black54),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildFAQList() {
//     return ListView.separated(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       itemCount: faqItems.length,
//       separatorBuilder: (context, index) => const SizedBox(height: 8),
//       itemBuilder: (context, index) {
//         return Card(
//           elevation: 2,
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//           child: ExpansionTile(
//             tilePadding:
//                 const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             title: Text(
//               faqItems[index].question,
//               style:
//                   const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
//             ),
//             children: [
//               Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                 child: Text(
//                   faqItems[index].answer,
//                   style: const TextStyle(color: Colors.black87),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   // Action Methods
//   Future<void> _makePhoneCall(String phoneNumber) async {
//     final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    
//     try {
//       if (await canLaunchUrl(phoneUri)) {
//         await launchUrl(phoneUri);
//       } else {
//         // Fallback: Copy to clipboard if phone dialer can't be launched
//         await Clipboard.setData(ClipboardData(text: phoneNumber));
//         if (mounted) {
//           _showContactDialog(
//             title: 'Call Support',
//             content:
//                 'Unable to open phone dialer. Number copied to clipboard: $phoneNumber',
//           );
//         }
//       }
//     } catch (e) {
//       if (mounted) {
//         _showErrorSnackBar('Failed to make call: ${e.toString()}');
//       }
//     }
//   }

// Future<void> _sendEmail(String email) async {
//     final Uri emailUri = Uri(
//       scheme: 'mailto',
//       path: email,
//       query: _encodeQueryParameters({
//         'subject': 'Support Request - Self Drive Cars',
//         'body': 'Hello,\n\nI need assistance with:\n\n',
//       }),
//     );

//     try {
//       await launchUrl(
//         emailUri,
//         mode: LaunchMode.externalApplication,
//       );
//     } catch (e) {
//       // Fallback: Copy to clipboard if email app can't be launched
//       await Clipboard.setData(ClipboardData(text: email));
//       if (mounted) {
//         _showContactDialog(
//           title: 'Email Support',
//           content:
//               'Unable to open email app. Email address copied to clipboard: $email',
//         );
//       }
//     }
//   }

//   String? _encodeQueryParameters(Map<String, String> params) {
//     return params.entries
//         .map((e) =>
//             '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
//         .join('&');
//   }

//   void _showContactDialog({required String title, required String content}) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text(title),
//         content: Text(content),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showInfoSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         duration: const Duration(seconds: 2),
//       ),
//     );
//   }

//   void _showErrorSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Colors.red,
//         duration: const Duration(seconds: 2),
//       ),
//     );
//   }
// }

// class FAQItem {
//   final String question;
//   final String answer;

//   FAQItem({
//     required this.question,
//     required this.answer,
//   });
// }





















import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({Key? key}) : super(key: key);

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  final List<FAQItem> faqItems = [
    FAQItem(
      question: "How do I book a car?",
      answer:
          "Select your desired car, choose pickup and return dates/times, upload required documents, select security deposit, and confirm your booking.",
    ),
    FAQItem(
      question: "What documents do I need?",
      answer:
          "You need a valid Aadhar Card and Driving License. Make sure all documents are clear and valid.",
    ),
    FAQItem(
      question: "Can I extend my booking?",
      answer:
          "Yes, you can extend your booking from the booking details page. Additional charges will apply based on hourly or daily rates.",
    ),
    FAQItem(
      question: "What are the security deposit options?",
      answer:
          "We accept Bike, Laptop, or Cash as security deposit. The deposit will be returned after successful completion of your trip.",
    ),
    FAQItem(
      question: "How do I cancel a booking?",
      answer:
          "You can cancel your booking from the booking details page. Cancellation charges may apply based on the timing of cancellation.",
    ),
    FAQItem(
      question: "What if I'm late for pickup?",
      answer:
          "Please contact our customer support immediately. Late pickup may result in additional charges or booking cancellation.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Frequently Asked Questions'),
        elevation: 0,
        centerTitle: true,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: colorScheme.primary,
          statusBarIconBrightness: colorScheme.brightness == Brightness.dark 
              ? Brightness.light 
              : Brightness.dark,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            _buildHeaderSection(theme, colorScheme),
            const SizedBox(height: 32),

            // Contact Support Section (Commented but themed)
            // _buildContactSection(theme, colorScheme),
            // const SizedBox(height: 32),

            // FAQ Section
            _buildFAQSection(theme, colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How can we help you?',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Find answers to commonly asked questions about our car rental service',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildContactSection(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contact Support',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildContactCard(
                theme,
                colorScheme,
                icon: Icons.phone_in_talk_rounded,
                title: 'Call Support',
                subtitle: '+91 6303092897',
                onTap: () => _makePhoneCall('+916303092897'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildContactCard(
                theme,
                colorScheme,
                icon: Icons.email_rounded,
                title: 'Email Support',
                subtitle: 'automotives23@gmail.com',
                onTap: () => _sendEmail('automotives23@gmail.com'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContactCard(
    ThemeData theme,
    ColorScheme colorScheme, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: colorScheme.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: colorScheme.primary.withOpacity(0.2),
            ),
          ),
          child: Column(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 24,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFAQSection(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Frequently Asked Questions',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Get quick answers to common questions',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 20),
        _buildFAQList(theme, colorScheme),
      ],
    );
  }

  Widget _buildFAQList(ThemeData theme, ColorScheme colorScheme) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: faqItems.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return _buildFAQItem(
          theme,
          colorScheme,
          faqItems[index],
          index,
        );
      },
    );
  }

  Widget _buildFAQItem(ThemeData theme, ColorScheme colorScheme, FAQItem item, int index) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: theme.cardColor,
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        leading: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: colorScheme.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '${index + 1}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
                fontSize: 14,
              ),
            ),
          ),
        ),
        title: Text(
          item.question,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.surfaceVariant.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.lightbulb_outline_rounded,
                    size: 20,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item.answer,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.8),
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        iconColor: colorScheme.primary,
        collapsedIconColor: colorScheme.onSurface.withOpacity(0.6),
      ),
    );
  }

  // Action Methods
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    
    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        // Fallback: Copy to clipboard if phone dialer can't be launched
        await Clipboard.setData(ClipboardData(text: phoneNumber));
        if (mounted) {
          _showContactDialog(
            title: 'Call Support',
            content:
                'Unable to open phone dialer. Number copied to clipboard: $phoneNumber',
          );
        }
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Failed to make call: ${e.toString()}');
      }
    }
  }

  Future<void> _sendEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: _encodeQueryParameters({
        'subject': 'Support Request - Self Drive Cars',
        'body': 'Hello,\n\nI need assistance with:\n\n',
      }),
    );

    try {
      await launchUrl(
        emailUri,
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      // Fallback: Copy to clipboard if email app can't be launched
      await Clipboard.setData(ClipboardData(text: email));
      if (mounted) {
        _showContactDialog(
          title: 'Email Support',
          content:
              'Unable to open email app. Email address copied to clipboard: $email',
        );
      }
    }
  }

  String? _encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  void _showContactDialog({required String title, required String content}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
        content: Text(
          content,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.8),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'OK',
              style: TextStyle(color: colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }

  void _showInfoSnackBar(String message) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onPrimary,
          ),
        ),
        backgroundColor: colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onError,
          ),
        ),
        backgroundColor: colorScheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class FAQItem {
  final String question;
  final String answer;

  FAQItem({
    required this.question,
    required this.answer,
  });
}