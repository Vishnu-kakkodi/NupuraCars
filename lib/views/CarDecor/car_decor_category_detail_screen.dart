// import 'package:flutter/material.dart';
// import 'package:nupura_cars/providers/Decor/car_decor_provider.dart';
// import 'package:nupura_cars/views/CarDecor/car_decor_booking_screen.dart';
// import 'package:provider/provider.dart';
// import 'package:url_launcher/url_launcher.dart';

// class CarDecorCategoryDetailScreen extends StatefulWidget {
//   final String categoryId;
//   final String categoryName;

//   const CarDecorCategoryDetailScreen({
//     Key? key,
//     required this.categoryId,
//     required this.categoryName,
//   }) : super(key: key);

//   @override
//   State<CarDecorCategoryDetailScreen> createState() =>
//       _CarDecorCategoryDetailScreenState();
// }

// class _CarDecorCategoryDetailScreenState
//     extends State<CarDecorCategoryDetailScreen> {
//   final String _adminWhatsAppNumber = '919133905401';
//   final String _adminPhoneNumber = '9133905401';

//   String? _selectedType; // interior / exterior

//   @override
//   void initState() {
//     super.initState();
//     Future.microtask(() {
//       context.read<CarDecorProvider>().loadProducts(widget.categoryId);
//     });
//   }

//   Future<void> _callNow() async {
//     final uri = Uri.parse('tel:$_adminPhoneNumber');
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri);
//     }
//   }

//   Future<void> _openWhatsApp(dynamic product) async {
//     final msg = '''
// Hello, I'm interested in Car Decor

// Product: ${product.name}
// Category: ${widget.categoryName}
// Price: ₹${product.price}
// Type: ${_selectedType ?? '-'}

// Please share more details.
// ''';

//     final uri = Uri.parse(
//       'https://wa.me/$_adminWhatsAppNumber?text=${Uri.encodeComponent(msg)}',
//     );

//     if (await canLaunchUrl(uri)) {
//       launchUrl(uri, mode: LaunchMode.externalApplication);
//     }
//   }

//   /// ✅ ONLY NAVIGATION (NO PAYMENT HERE)
//   void _bookProduct(dynamic product) {
//     if (_selectedType == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please select Interior or Exterior')),
//       );
//       return;
//     }

//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => CarDecorBookingScreen(
//           washId: product.id,
//           washName: product.name,
//           price: 500,
//           imageUrl: product.image,
//           serviceType: _selectedType!, // ✅ PASS TYPE
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final decorProvider = context.watch<CarDecorProvider>();

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.categoryName),
//       ),
// body: decorProvider.loading
//     ? const Center(child: CircularProgressIndicator())
//     : decorProvider.products.isEmpty
//         ? _emptyUI()
//         : ListView.builder(
//             padding: const EdgeInsets.all(12),
//             itemCount: decorProvider.products.length,
//             itemBuilder: (_, index) {
//               final p = decorProvider.products[index];
//               return _buildProductCard(p);
//             },
//           ),

//     );
//   }


//   Widget _emptyUI() {
//   return Center(
//     child: Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Icon(
//           Icons.inventory_2_outlined,
//           size: 80,
//           color: Colors.grey[400],
//         ),
//         const SizedBox(height: 16),
//         Text(
//           'No car decors available',
//           style: TextStyle(
//             fontSize: 16,
//             color: Colors.grey[600],
//           ),
//         ),
//       ],
//     ),
//   );
// }


//   Widget _buildProductCard(dynamic product) {
//     final colorScheme = Theme.of(context).colorScheme;

//     return Card(
//       margin: const EdgeInsets.only(bottom: 12),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 Image.network(
//                   product.image,
//                   width: 90,
//                   height: 90,
//                   fit: BoxFit.cover,
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         product.name,
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
  
//                     ],
//                   ),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 12),

//             /// ✅ TYPE SELECTION
//             Row(
//               children: [
//                 Expanded(
//                   child: ChoiceChip(
//                     label: const Text('Interior'),
//                     selected: _selectedType == 'interior',
//                     onSelected: (_) =>
//                         setState(() => _selectedType = 'interior'),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: ChoiceChip(
//                     label: const Text('Exterior'),
//                     selected: _selectedType == 'exterior',
//                     onSelected: (_) =>
//                         setState(() => _selectedType = 'exterior'),
//                   ),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 12),
//             const Divider(),

//             Row(
//               children: [
//                 Expanded(
//                   child: OutlinedButton.icon(
//                     onPressed: _callNow,
//                     icon: const Icon(Icons.call),
//                     label: const Text('Call'),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: OutlinedButton.icon(
//                     onPressed: () => _openWhatsApp(product),
//                     icon: const Icon(Icons.chat),
//                     label: const Text('WhatsApp'),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () => _bookProduct(product),
//                     child: const Text('Book'),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }






















import 'package:flutter/material.dart';
import 'package:nupura_cars/providers/Decor/car_decor_provider.dart';
import 'package:nupura_cars/views/CarDecor/car_decor_booking_screen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class CarDecorCategoryDetailScreen extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  const CarDecorCategoryDetailScreen({
    Key? key,
    required this.categoryId,
    required this.categoryName,
  }) : super(key: key);

  @override
  State<CarDecorCategoryDetailScreen> createState() =>
      _CarDecorCategoryDetailScreenState();
}

class _CarDecorCategoryDetailScreenState
    extends State<CarDecorCategoryDetailScreen> {
  final String _adminWhatsAppNumber = '919133905401';
  final String _adminPhoneNumber = '9133905401';
  String _selectedType = 'exterior';

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<CarDecorProvider>().loadProducts(widget.categoryId);
    });
  }

  Future<void> _callNow() async {
    final uri = Uri.parse('tel:$_adminPhoneNumber');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _openWhatsApp(dynamic product) async {
    final msg = '''
Hello, I'm interested in Car Decor

Product: ${product.name}
Category: ${widget.categoryName}
Type: $_selectedType

Please share more details.
''';

    final uri = Uri.parse(
      'https://wa.me/$_adminWhatsAppNumber?text=${Uri.encodeComponent(msg)}',
    );

    if (await canLaunchUrl(uri)) {
      launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _bookProduct(dynamic product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CarDecorBookingScreen(
          washId: product.id,
          washName: product.name,
          price: 500,
          imageUrl: product.image,
          serviceType: _selectedType,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final decorProvider = context.watch<CarDecorProvider>();
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: Text(
          widget.categoryName,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: cs.surface,
        surfaceTintColor: Colors.transparent,
      ),
      body: decorProvider.loading
          ? const Center(child: CircularProgressIndicator())
          : decorProvider.products.isEmpty
              ? _emptyUI()
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  itemCount: decorProvider.products.length,
                  itemBuilder: (_, index) {
                    final p = decorProvider.products[index];
                    return _buildProductCard(p);
                  },
                ),
    );
  }

  Widget _emptyUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.directions_car_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'No Decors Available',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Check back later for new options',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(dynamic product) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Image.network(
                  product.image,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: double.infinity,
                    height: 200,
                    color: cs.surfaceVariant,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image_not_supported_outlined,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Image not available',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Category badge
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Text(
                    widget.categoryName,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: cs.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Content Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Name
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),
                
                const SizedBox(height: 16),

                // Type Selection
                Container(
                  decoration: BoxDecoration(
                    color: cs.surfaceVariant.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: cs.outline.withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    children: [
                      _buildTypeOption(
                        'interior',
                        'Interior Decor',
                        Icons.weekend_outlined,
                      ),
                      Divider(
                        height: 1,
                        indent: 16,
                        endIndent: 16,
                        color: cs.outline.withOpacity(0.2),
                      ),
                      _buildTypeOption(
                        'exterior',
                        'Exterior Decor',
                        Icons.directions_car_outlined,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: _buildActionButton(
                        icon: Icons.call_outlined,
                        label: 'Call',
                        onPressed: _callNow,
                        isPrimary: false,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildActionButton(
                        icon: Icons.chat_bubble_outline,
                        label: 'WhatsApp',
                        onPressed: () => _openWhatsApp(product),
                        isPrimary: false,
                        color: const Color(0xFF25D366),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: _buildActionButton(
                    icon: Icons.calendar_today_outlined,
                    label: 'Book Now',
                    onPressed: () => _bookProduct(product),
                    isPrimary: true,
                    color: cs.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeOption(String value, String label, IconData icon) {
    final isSelected = _selectedType == value;
    final cs = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () => setState(() => _selectedType = value),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected
                    ? cs.primary.withOpacity(0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 20,
                color: isSelected ? cs.primary : Colors.grey[600],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? cs.primary : Colors.grey[800],
                ),
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? cs.primary : Colors.grey[400]!,
                  width: 2,
                ),
                color: isSelected ? cs.primary : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      size: 14,
                      color: Colors.white,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required bool isPrimary,
    required Color color,
  }) {
    return Material(
      color: isPrimary ? color : Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            border: isPrimary ? null : Border.all(color: color, width: 1.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 20,
                color: isPrimary ? Colors.white : color,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isPrimary ? Colors.white : color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}