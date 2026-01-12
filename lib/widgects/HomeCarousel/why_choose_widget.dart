import 'package:flutter/material.dart';

class WhyChooseWidget extends StatelessWidget {
  const WhyChooseWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final items = [
      _WhyChooseItem(
        icon: Icons.verified,
        title: 'Original Products',
        description:
            'Only reliable parts from trusted aftermarket brands',
      ),
      _WhyChooseItem(
        icon: Icons.currency_rupee,
        title: 'Affordable Rates',
        description:
            'Cost-effective solutions without compromising quality',
      ),
      _WhyChooseItem(
        icon: Icons.local_shipping,
        title: 'Fast Delivery',
        description:
            'Quick and reliable delivery to your doorstep',
      ),
      _WhyChooseItem(
        icon: Icons.support_agent,
        title: 'Expert Support',
        description:
            'Dedicated support for all your vehicle needs',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: cs.onSurface,
              ),
              children: [
                const TextSpan(text: 'Why Choose\n'),
                TextSpan(
                  text: 'Aftermarket Products ?',
                  style: TextStyle(color: cs.primary),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        /// Cards
        GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.9,
          ),
          itemBuilder: (_, index) {
            final item = items[index];
            return Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: cs.outlineVariant),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: cs.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      item.icon,
                      color: cs.primary,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.description,
                    style: TextStyle(
                      fontSize: 13,
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _WhyChooseItem {
  final IconData icon;
  final String title;
  final String description;

  _WhyChooseItem({
    required this.icon,
    required this.title,
    required this.description,
  });
}
