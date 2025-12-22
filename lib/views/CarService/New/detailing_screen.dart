
// // lib/views/CarService/New/service_detail_with_cart.dart
// import 'package:flutter/material.dart';
// import 'package:nupura_cars/views/CartScreen/cart_screen.dart';
// import 'package:video_player/video_player.dart';

// class ServiceDetailSinglePageScreen extends StatefulWidget {
//   const ServiceDetailSinglePageScreen({Key? key}) : super(key: key);

//   @override
//   State<ServiceDetailSinglePageScreen> createState() =>
//       _ServiceDetailSinglePageScreenState();
// }

// class _ServiceDetailSinglePageScreenState
//     extends State<ServiceDetailSinglePageScreen> {
//   // Sections (Video removed so video is handled separately)
//   final List<String> sections = [
//     'Brake Maintenance',
//     'Value Services',
//     'Interior Care',
//     'Exterior Care',
//   ];

//   // GlobalKeys for scroll-to-section
//   final Map<String, GlobalKey> _sectionKeys = {};

//   // Scroll controller for the main body
//   final ScrollController _scrollController = ScrollController();

//   // Active index for top bar highlight (index into `sections`)
//   int _activeIndex = 0;

//   // Video player controller
//   late VideoPlayerController _videoController;
//   final String videoUrl =
//       'https://cdn.pixabay.com/video/2016/09/21/5497-184226939_medium.mp4'; // replace with your URL

//   // Static demo data per section (note: added 'id' and 'image' & 'price' fields)
//   final Map<String, List<Map<String, dynamic>>> sectionItems = {
//     'Brake Maintenance': [
//       {
//         'id': 'front_brake',
//         'title': 'Front Brake Pads',
//         'image': 'https://www.shutterstock.com/image-photo/car-ventilated-front-brake-disc-600nw-2607745303.jpg',
//         'price': '₹1,299',
//         'bullets': [
//           'Takes 3 Hours',
//           '1 Month warranty',
//           'For Both Front wheels',
//         ],
//       },
//       {
//         'id': 'rear_brake',
//         'title': 'Rear Brake Pads',
//         'image': 'https://5.imimg.com/data5/SELLER/Default/2023/3/296518111/QP/KJ/ZY/151899626/5-500x500.png',
//         'price': '₹1,099',
//         'bullets': [
//           'Takes 2.5 Hours',
//           '1 Month warranty',
//           'For Both Rear wheels',
//         ],
//       },
//       {
//         'id': 'disc_replace',
//         'title': 'Brake Disc Replacement',
//         'image': 'https://cdn.shopify.com/s/files/1/0697/6746/3162/files/blog_What_are_brake_discs_143323591.jpg',
//         'price': '₹2,499',
//         'bullets': ['Takes 4 Hours', '3 Months warranty', 'Per Axle'],
//       },
//     ],
//     'Value Services': [
//       {
//         'id': 'quick_wash',
//         'title': 'Quick Wash + Vacuum',
//         'image': 'https://cdn-icons-png.flaticon.com/512/150/150523.png',
//         'price': '₹399',
//         'bullets': ['Takes 45 mins', 'No warranty', 'Exterior + Vacuum'],
//       },
//       {
//         'id': 'engine_bay',
//         'title': 'Engine Bay Clean',
//         'image': 'https://cdn-icons-png.flaticon.com/512/190/190411.png',
//         'price': '₹699',
//         'bullets': ['Takes 1.5 Hours', '7 Days warranty', 'Degrease & Rinse'],
//       },
//     ],
//     'Interior Care': [
//       {
//         'id': 'deep_shampoo',
//         'title': 'Deep Shampoo',
//         'image': 'https://cdn-icons-png.flaticon.com/512/2917/2917995.png',
//         'price': '₹899',
//         'bullets': ['Takes 2 Hours', '14 Days warranty', 'Seats + Carpets'],
//       },
//     ],
//     'Exterior Care': [
//       {
//         'id': 'paint_sealant',
//         'title': 'Paint Sealant',
//         'image': 'https://cdn-icons-png.flaticon.com/512/3097/3097089.png',
//         'price': '₹1,499',
//         'bullets': ['Takes 3 Hours', '3 Months warranty', 'Surface protection'],
//       },
//     ],
//   };

//   // in-memory cart: list of item maps (id,title,price,image,...)
//   final List<Map<String, dynamic>> _cart = [];

//   @override
//   void initState() {
//     super.initState();

//     for (final s in sections) {
//       _sectionKeys[s] = GlobalKey();
//     }

//     // ignore: deprecated_member_use
//     _videoController = VideoPlayerController.network(videoUrl)
//       ..setLooping(true)
//       ..setVolume(0)
//       ..initialize().then((_) {
//         if (mounted) {
//           setState(() {});
//           _videoController.play();
//         }
//       });

//     _scrollController.addListener(_handleScrollForVideo);
//   }

//   void _handleScrollForVideo() {
//     if (!mounted) return;
//     if (!_videoController.value.isInitialized) return;

//     final width = MediaQuery.of(context).size.width;
//     final videoHeight = (width * 9 / 16).clamp(160.0, 320.0);

//     final offset = _scrollController.offset;
//     final threshold = videoHeight - 40;

//     if (offset > threshold) {
//       if (_videoController.value.isPlaying) _videoController.pause();
//     } else {
//       if (!_videoController.value.isPlaying) _videoController.play();
//     }
//   }

//   @override
//   void dispose() {
//     _videoController.dispose();
//     _scrollController.removeListener(_handleScrollForVideo);
//     _scrollController.dispose();
//     super.dispose();
//   }

//   Future<void> _scrollToSection(String section) async {
//     final key = _sectionKeys[section];
//     if (key == null) return;
//     final ctx = key.currentContext;
//     if (ctx == null) return;

//     if (_videoController.value.isInitialized && _videoController.value.isPlaying) {
//       _videoController.pause();
//     }

//     await Scrollable.ensureVisible(
//       ctx,
//       duration: const Duration(milliseconds: 450),
//       curve: Curves.easeInOut,
//       alignment: 0.0,
//     );

//     setState(() {
//       _activeIndex = sections.indexOf(section);
//     });
//   }

//   // Add to local cart (avoid duplicates by id)
//   void _addToCart(Map<String, dynamic> item) {
//     final id = item['id'] as String?;
//     if (id == null) return;
//     final exists = _cart.any((c) => c['id'] == id);
//     if (exists) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('"${item['title']}" already in cart')));
//       return;
//     }
//     setState(() {
//       _cart.add(item);
//     });
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Added "${item['title']}" to cart')));
//   }

//   // Navigate to external CartScreen and pass dynamic cart
//   void _navigateToCart() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => CartScreen(initialItems: List<Map<String, dynamic>>.from(_cart)),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final mq = MediaQuery.of(context);
//     final width = mq.size.width;

//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: const Size.fromHeight(120),
//         child: AppBar(
//           backgroundColor: Colors.white,
//           foregroundColor: Colors.black,
//           elevation: 1,
//           automaticallyImplyLeading: false,
//           titleSpacing: 0,
//           toolbarHeight: 120,
//           title: null,
//           flexibleSpace: SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Top row - back + title + dynamic cart icon with badge
//                   Row(
//                     children: [
//                       IconButton(
//                         icon: const Icon(Icons.arrow_back),
//                         onPressed: () => Navigator.of(context).pop(),
//                         padding: EdgeInsets.zero,
//                         constraints: const BoxConstraints(),
//                       ),
//                       const SizedBox(width: 8),
//                       const Text('Car Service', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.black)),
//                       const Spacer(),
//                       GestureDetector(
//                         onTap: _navigateToCart,
//                         child: Stack(
//                           clipBehavior: Clip.none,
//                           children: [
//                             Container(
//                               padding: const EdgeInsets.all(6),
//                               decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(10)),
//                               child: const Icon(Icons.shopping_cart_outlined, color: Colors.black87),
//                             ),
//                             if (_cart.isNotEmpty)
//                               Positioned(
//                                 right: -6,
//                                 top: -6,
//                                 child: Container(
//                                   padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                                   decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(12)),
//                                   child: Text('${_cart.length}', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
//                                 ),
//                               ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),

//                   const SizedBox(height: 8),

//                   // Sections scroll
//                   SizedBox(
//                     height: 44,
//                     child: ListView.separated(
//                       scrollDirection: Axis.horizontal,
//                       itemCount: sections.length,
//                       separatorBuilder: (_, __) => const SizedBox(width: 8),
//                       itemBuilder: (context, index) {
//                         final s = sections[index];
//                         final bool active = index == _activeIndex;

//                         return GestureDetector(
//                           onTap: () => _scrollToSection(s),
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//                             decoration: BoxDecoration(
//                               color: active ? Colors.deepPurple.shade50 : Colors.transparent,
//                               borderRadius: BorderRadius.circular(10),
//                               border: Border.all(color: active ? Colors.deepPurple : Colors.grey.shade300, width: 1.6),
//                             ),
//                             child: Text(s, style: TextStyle(color: active ? Colors.deepPurple : Colors.black87, fontWeight: active ? FontWeight.w700 : FontWeight.w600, fontSize: 14)),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),

//       body: SafeArea(
//         child: SingleChildScrollView(
//           controller: _scrollController,
//           padding: const EdgeInsets.symmetric(vertical: 16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildStandaloneVideoSection(context),
//               const SizedBox(height: 18),
//               for (final s in sections) ...[
//                 _SectionWrapper(key: _sectionKeys[s], title: s, child: _buildCardsForSection(context, s)),
//                 const SizedBox(height: 18),
//               ],
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildStandaloneVideoSection(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     final videoHeight = (width * 9 / 16).clamp(160.0, 320.0);

//     return Container(
//       width: double.infinity,
//       height: videoHeight,
//       color: Colors.black,
//       child: ClipRRect(
//         child: Stack(
//           fit: StackFit.expand,
//           children: [
//             if (_videoController.value.isInitialized)
//               GestureDetector(
//                 onTap: () {
//                   if (_videoController.value.isPlaying) {
//                     _videoController.pause();
//                   } else {
//                     _videoController.play();
//                   }
//                   setState(() {});
//                 },
//                 child: VideoPlayer(_videoController),
//               )
//             else
//               Image.network('https://via.placeholder.com/800x450.png?text=Loading+Video', fit: BoxFit.cover),
//             // Positioned(
//             //   right: 8,
//             //   top: 8,
//             //   child: Container(
//             //     decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(6)),
//             //     child: IconButton(
//             //       icon: Icon(_videoController.value.isInitialized && _videoController.value.isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white),
//             //       onPressed: () {
//             //         if (!_videoController.value.isInitialized) return;
//             //         if (_videoController.value.isPlaying) _videoController.pause(); else _videoController.play();
//             //         setState(() {});
//             //       },
//             //     ),
//             //   ),
//             // ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildCardsForSection(BuildContext context, String section) {
//     final items = sectionItems[section] ?? [];

//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Column(
//         children: items
//             .map((it) => _ServiceItemCard(
//                   key: ValueKey(it['id']),
//                   item: it,
//                   onAdd: () => _addToCart(it),
//                 ))
//             .toList(),
//       ),
//     );
//   }
// }

// /// Section wrapper unchanged
// class _SectionWrapper extends StatelessWidget {
//   final Widget child;
//   final String title;

//   const _SectionWrapper({Key? key, required this.child, required this.title}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     return Container(
//       padding: const EdgeInsets.only(bottom: 8),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(padding: const EdgeInsets.all(8.0), child: Text(title, style: TextStyle(fontSize: (width * 0.045).clamp(16.0, 20.0), fontWeight: FontWeight.w800))),
//           const SizedBox(height: 10),
//           child,
//         ],
//       ),
//     );
//   }
// }

// /// Service item card (unchanged, uses onAdd callback)
// class _ServiceItemCard extends StatelessWidget {
//   final Map<String, dynamic> item;
//   final VoidCallback onAdd;

//   const _ServiceItemCard({Key? key, required this.item, required this.onAdd}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     final imgSize = (width * 0.24).clamp(72.0, 110.0);
//     final titleFont = (width * 0.038).clamp(14.0, 18.0);

//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.grey.shade200), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 6))]),
//       child: Column(
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(
//                 child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//                   Text(item['title'] ?? '', style: TextStyle(fontSize: titleFont, fontWeight: FontWeight.w800)),
//                   const SizedBox(height: 8),
//                   if (item['bullets'] is List)
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: (item['bullets'] as List).map<Widget>((b) {
//                         return Padding(
//                           padding: const EdgeInsets.only(bottom: 6),
//                           child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
//                             const Text('• ', style: TextStyle(fontSize: 13.5)),
//                             Expanded(child: Text(b, style: const TextStyle(fontSize: 13.2))),
//                           ]),
//                         );
//                       }).toList(),
//                     ),
//                   const SizedBox(height: 6),
//                   Row(children: [
//                     Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6), decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(20)), child: Row(children: [const Icon(Icons.star, size: 14, color: Colors.red), const SizedBox(width: 6), Text((item['rating'] ?? '4.4').toString(), style: const TextStyle(fontWeight: FontWeight.w700)), const SizedBox(width: 8), Text('Nupura Expert Rating', style: TextStyle(fontSize: 12, color: Colors.grey.shade600))]))
//                   ]),
//                 ]),
//               ),
//               const SizedBox(width: 12),
//               Column(
//                 children: [
//                   ClipRRect(borderRadius: BorderRadius.circular(10), child: Container(width: imgSize, height: imgSize, color: Colors.grey[100], child: Image.network(item['image'] ?? '', fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: Colors.grey[100], child: const Icon(Icons.image_not_supported))))),
//                   const SizedBox(height: 8),
//                   SizedBox(
//                     width: imgSize,
//                     child: OutlinedButton(
//                       onPressed: onAdd,
//                       style: OutlinedButton.styleFrom(side: BorderSide(color: Colors.red.shade300, width: 1.6), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), padding: const EdgeInsets.symmetric(vertical: 8)),
//                       child: Text('ADD', style: TextStyle(color: Colors.red.shade600, fontWeight: FontWeight.w800)),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Row(children: [
//             if (item['oldPrice'] != null) Text('${item['oldPrice']}', style: TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey.shade500, fontSize: 13)),
//             if (item['oldPrice'] != null) const SizedBox(width: 8),
//             Text(item['price'] ?? '', style: TextStyle(fontWeight: FontWeight.w900, fontSize: (width * 0.042).clamp(15.0, 18.0))),
//             const SizedBox(width: 8),
//             if (item['discount'] != null) Text('${item['discount']} OFF', style: TextStyle(color: Colors.green.shade700, fontWeight: FontWeight.w800)),
//             const Spacer(),
//           ]),
//           const SizedBox(height: 12),
//           Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12), decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(10)), child: Row(children: [Expanded(child: Text(item['offerText'] ?? 'Get at ₹1479', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black87))), Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.green.shade600, Colors.green.shade400]), borderRadius: BorderRadius.circular(8)), child: const Text('Extra ₹500 OFF', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)))])),
//           const SizedBox(height: 10),
//           Container(width: double.infinity, padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12), decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(10)), child: Row(children: [Expanded(child: Text(item['infoText'] ?? '18489+ car owners booked this week', style: TextStyle(color: Colors.grey.shade700))), GestureDetector(onTap: () {}, child: Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: Colors.red.shade50, shape: BoxShape.circle), child: Icon(Icons.add, size: 18, color: Colors.red.shade700))) ]))
//         ],
//       ),
//     );
//   }
// }






















import 'package:flutter/material.dart';
import 'package:nupura_cars/providers/CartProvider/cart_provider.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import 'package:nupura_cars/models/ServiceModel/new_service_model.dart';
import 'package:nupura_cars/providers/ServiceNameProvider/new_service_provider.dart';
import 'package:nupura_cars/views/CartScreen/cart_screen.dart';

class ServiceDetailSinglePageScreen extends StatefulWidget {
  const ServiceDetailSinglePageScreen({Key? key}) : super(key: key);

  @override
  State<ServiceDetailSinglePageScreen> createState() =>
      _ServiceDetailSinglePageScreenState();
}

class _ServiceDetailSinglePageScreenState
    extends State<ServiceDetailSinglePageScreen> {
  final Map<String, GlobalKey> _sectionKeys = {};
  final ScrollController _scrollController = ScrollController();
  int _activeIndex = 0;

  late VideoPlayerController _videoController;
  final String videoUrl =
      'https://cdn.pixabay.com/video/2016/09/21/5497-184226939_medium.mp4';

  final String serviceId = '69454a379a10c9ea5b5a7c84';
  final String userId = '692468a7eef8da08eede6712';

  @override
  void initState() {
    super.initState();

    context.read<ServiceProvider>().loadServices(serviceId);
    context.read<CartProvider>().loadCart(userId);

    _videoController = VideoPlayerController.network(videoUrl)
      ..setLooping(true)
      ..setVolume(0)
      ..initialize().then((_) {
        if (mounted) {
          setState(() {});
          _videoController.play();
        }
      });

    _scrollController.addListener(_handleScrollForVideo);
  }

  void _handleScrollForVideo() {
    if (!_videoController.value.isInitialized) return;

    final width = MediaQuery.of(context).size.width;
    final videoHeight = (width * 9 / 16).clamp(160.0, 320.0);

    final offset = _scrollController.offset;
    final threshold = videoHeight - 40;

    if (offset > threshold) {
      if (_videoController.value.isPlaying) _videoController.pause();
    } else {
      if (!_videoController.value.isPlaying) _videoController.play();
    }
  }

  @override
  void dispose() {
    _videoController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _scrollToSection(String section) async {
    final key = _sectionKeys[section];
    if (key == null) return;

    final ctx = key.currentContext;
    if (ctx == null) return;

    await Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeInOut,
      alignment: 0.0,
    );

    setState(() {
      _activeIndex = _sectionKeys.keys.toList().indexOf(section);
    });
  }

  @override
  Widget build(BuildContext context) {
    final serviceProvider = context.watch<ServiceProvider>();
    final cartProvider = context.watch<CartProvider>();

    final sections = serviceProvider.subServices.map((e) => e.name).toList();

    for (final s in sections) {
      _sectionKeys.putIfAbsent(s, () => GlobalKey());
    }

    return Scaffold(
      appBar: _buildAppBar(sections, cartProvider.count),
      body: SafeArea(
        child: serviceProvider.loading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStandaloneVideoSection(context),
                    const SizedBox(height: 18),
                    for (final sub in serviceProvider.subServices) ...[
                      _SectionWrapper(
                        key: _sectionKeys[sub.name],
                        title: sub.name,
                        child: _buildCardsForSubService(sub),
                      ),
                      const SizedBox(height: 18),
                    ],
                  ],
                ),
              ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
      List<String> sections, int cartCount) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(120),
      child: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        automaticallyImplyLeading: false,
        toolbarHeight: 120,
        flexibleSpace: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// TOP ROW (UNCHANGED)
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Car Service',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CartScreen(),
                        ),
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.shopping_cart_outlined),
                          ),
                          if (cartCount > 0)
                            Positioned(
                              right: -6,
                              top: -6,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '$cartCount',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                /// SECTION TABS (UNCHANGED)
                SizedBox(
                  height: 44,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: sections.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(width: 8),
                    itemBuilder: (_, index) {
                      final active = index == _activeIndex;
                      return GestureDetector(
                        onTap: () => _scrollToSection(sections[index]),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: active
                                ? Colors.deepPurple.shade50
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: active
                                  ? Colors.deepPurple
                                  : Colors.grey.shade300,
                              width: 1.6,
                            ),
                          ),
                          child: Text(
                            sections[index],
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: active
                                  ? FontWeight.w700
                                  : FontWeight.w600,
                              color: active
                                  ? Colors.deepPurple
                                  : Colors.black87,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStandaloneVideoSection(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = (width * 9 / 16).clamp(160.0, 320.0);

    return Container(
      width: double.infinity,
      height: height,
      color: Colors.black,
      child: _videoController.value.isInitialized
          ? VideoPlayer(_videoController)
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildCardsForSubService(SubServiceModel sub) {
    final cartProvider = context.read<CartProvider>();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: sub.packages.map((pkg) {
          return _ServiceItemCard(
            item: {
              'title': pkg.name,
              'image': pkg.image,
              'price': '₹${pkg.offerPrice}',
              'oldPrice': '₹${pkg.price}',
              'rating': pkg.rating,
              'bullets': pkg.benefits,
            },
            onAdd: () {
              cartProvider.addItem(userId, pkg.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${pkg.name} added to cart')),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}

/// ================= UI BELOW IS 100% SAME AS YOUR SECOND FILE =================

class _SectionWrapper extends StatelessWidget {
  final Widget child;
  final String title;

  const _SectionWrapper({Key? key, required this.child, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: TextStyle(
                fontSize: (width * 0.045).clamp(16.0, 20.0),
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}




/// Service item card (unchanged, uses onAdd callback)
class _ServiceItemCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onAdd;

  const _ServiceItemCard({Key? key, required this.item, required this.onAdd}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final imgSize = (width * 0.24).clamp(72.0, 110.0);
    final titleFont = (width * 0.038).clamp(14.0, 18.0);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.grey.shade200), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 6))]),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(item['title'] ?? '', style: TextStyle(fontSize: titleFont, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 8),
                  if (item['bullets'] is List)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: (item['bullets'] as List).map<Widget>((b) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            const Text('• ', style: TextStyle(fontSize: 13.5)),
                            Expanded(child: Text(b, style: const TextStyle(fontSize: 13.2))),
                          ]),
                        );
                      }).toList(),
                    ),
                  const SizedBox(height: 6),
                  Row(children: [
                    Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6), decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(20)), child: Row(children: [const Icon(Icons.star, size: 14, color: Colors.red), const SizedBox(width: 6), Text((item['rating'] ?? '4.4').toString(), style: const TextStyle(fontWeight: FontWeight.w700)), const SizedBox(width: 8), Text('Nupura Expert Rating', style: TextStyle(fontSize: 12, color: Colors.grey.shade600))]))
                  ]),
                ]),
              ),
              const SizedBox(width: 12),
              Column(
                children: [
                  ClipRRect(borderRadius: BorderRadius.circular(10), child: Container(width: imgSize, height: imgSize, color: Colors.grey[100], child: Image.network(item['image'] ?? '', fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: Colors.grey[100], child: const Icon(Icons.image_not_supported))))),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: imgSize,
                    child: OutlinedButton(
                      onPressed: onAdd,
                      style: OutlinedButton.styleFrom(side: BorderSide(color: Colors.red.shade300, width: 1.6), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), padding: const EdgeInsets.symmetric(vertical: 8)),
                      child: Text('ADD', style: TextStyle(color: Colors.red.shade600, fontWeight: FontWeight.w800)),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(children: [
            if (item['oldPrice'] != null) Text('${item['oldPrice']}', style: TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey.shade500, fontSize: 13)),
            if (item['oldPrice'] != null) const SizedBox(width: 8),
            Text(item['price'] ?? '', style: TextStyle(fontWeight: FontWeight.w900, fontSize: (width * 0.042).clamp(15.0, 18.0))),
            const SizedBox(width: 8),
            if (item['discount'] != null) Text('${item['discount']} OFF', style: TextStyle(color: Colors.green.shade700, fontWeight: FontWeight.w800)),
            const Spacer(),
          ]),
          // const SizedBox(height: 12),
          // Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12), decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(10)), child: Row(children: [Expanded(child: Text(item['offerText'] ?? 'Get at ₹1479', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black87))), Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.green.shade600, Colors.green.shade400]), borderRadius: BorderRadius.circular(8)), child: const Text('Extra ₹500 OFF', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)))])),
          // const SizedBox(height: 10),
          // Container(width: double.infinity, padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12), decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(10)), child: Row(children: [Expanded(child: Text(item['infoText'] ?? '18489+ car owners booked this week', style: TextStyle(color: Colors.grey.shade700))), GestureDetector(onTap: () {}, child: Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: Colors.red.shade50, shape: BoxShape.circle), child: Icon(Icons.add, size: 18, color: Colors.red.shade700))) ]))
        ],
      ),
    );
  }
}

















