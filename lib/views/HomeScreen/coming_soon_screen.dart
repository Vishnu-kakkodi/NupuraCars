

// FILE: lib/views/ComingSoon/coming_soon_screen.dart

import 'package:flutter/material.dart';

class ComingSoonScreen extends StatelessWidget {
  final String title;
  const ComingSoonScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final textPrimary = Theme.of(context).colorScheme.onSurface;
    final textSecondary = Theme.of(context).colorScheme.onSurfaceVariant;

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: primary.withOpacity(0.12), shape: BoxShape.circle), child: Icon(Icons.hourglass_empty, size: 56, color: primary)),
            const SizedBox(height: 20),
            Text('Coming Soon', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textPrimary)),
            const SizedBox(height: 12),
            Text('$title service will be available soon.', textAlign: TextAlign.center, style: TextStyle(color: textSecondary)),
          ],
        ),
      ),
    );
  }
}


/*
  NOTES:
  - These files are skeletons and extracts of the original HomeScreen split into separate screens.
  - CarsRentScreen preserves core rental flows (date/time pickers, car list, checkout navigation). Adjust imports and paths to match your project structure.
  - ServicesScreen keeps the "select car for service" + services list logic.
  - Remaining categories open ComingSoonScreen by default.
  - You may move utility widgets (date selector, car card) into shared widgets to avoid duplication.
*/
