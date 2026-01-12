import 'package:flutter/material.dart';

class BrandsWeTrustWidget extends StatelessWidget {
  const BrandsWeTrustWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    /// Network brand logos
    final brands = [
      'https://www.smartpartsexport.com/assets/img/product/mahindra-spare-parts/genuine-parts-mahindra.jpg',
      'https://www.arispl.in/img/dealership/tata-related-5.jpeg',
      'https://www.globalsuzuki.com/after_sales/about/img/img01.jpg',
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
                const TextSpan(text: 'Brands we '),
                TextSpan(
                  text: 'Trust',
                  style: TextStyle(color: cs.primary),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        /// Brand Logos
        SizedBox(
          height: 140,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, index) {
              return Container(
                width: 140,
                decoration: BoxDecoration(
                  color: cs.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: cs.outlineVariant),
                ),
                child: Image.network(
                  brands[index],
                  fit: BoxFit.fill,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.image_not_supported,
                      color: cs.onSurfaceVariant,
                    );
                  },
                ),
              );
            },
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemCount: brands.length,
          ),
        ),
      ],
    );
  }
}
