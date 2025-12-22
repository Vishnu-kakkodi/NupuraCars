import 'package:flutter/material.dart';
import 'package:nupura_cars/models/Cart/cart_model.dart';
import 'package:nupura_cars/providers/CartProvider/cart_provider.dart';
import 'package:nupura_cars/providers/LocationProvider/location_provider.dart';
import 'package:nupura_cars/views/Location/location_picker.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final String userId = '692468a7eef8da08eede6712';

  String _mode = 'Pickup';
  String _notes = '';
  String? _coupon;

  DateTime? _pickupDate;
  TimeOfDay? _pickupTime;

  @override
  void initState() {
    super.initState();
    context.read<CartProvider>().loadCart(userId);
  }

  void _removeItemLocally(String id) {
    context.read<CartProvider>().removeLocal(userId, id);
  }

  Future<void> _selectPickupDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );

    if (picked != null) {
      setState(() => _pickupDate = picked);
    }
  }

  Future<void> _selectPickupTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() => _pickupTime = picked);
    }
  }

  Widget _pickupLocationSection() {
    return Consumer<LocationProvider>(
      builder: (context, provider, _) {
        return InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    LocationPickerScreen(isEditing: false, userId: userId),
              ),
            );
          },
          child: _whiteCard(
            child: Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: provider.isLoading
                      ? const Text('Fetching location...')
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              provider.address.isNotEmpty
                                  ? provider.address
                                  : 'Set pickup location',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (provider.coordinates != null)
                              Text(
                                'Lat: ${provider.coordinates![0]}, Lng: ${provider.coordinates![1]}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                          ],
                        ),
                ),
                const Icon(Icons.keyboard_arrow_right),
              ],
            ),
          ),
        );
      },
    );
  }


    Widget _bookingDateTimeSection() {
    return Column(
      children: [
        GestureDetector(
          onTap: _selectPickupDate,
          child: _whiteCard(
            child: Row(
              children: [
                const Icon(Icons.calendar_today),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _pickupDate == null
                        ? 'Select booking date'
                        : '${_pickupDate!.day}/${_pickupDate!.month}/${_pickupDate!.year}',
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, size: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _pickupDateTimeSection() {
    return Column(
      children: [
        GestureDetector(
          onTap: _selectPickupDate,
          child: _whiteCard(
            child: Row(
              children: [
                const Icon(Icons.calendar_today),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _pickupDate == null
                        ? 'Select pickup date'
                        : '${_pickupDate!.day}/${_pickupDate!.month}/${_pickupDate!.year}',
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, size: 16),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: _selectPickupTime,
          child: _whiteCard(
            child: Row(
              children: [
                const Icon(Icons.access_time),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _pickupTime == null
                        ? 'Select pickup time'
                        : _pickupTime!.format(context),
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, size: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showNotesModal() {
    final ctrl = TextEditingController(text: _notes);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          top: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Any other requirements',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: ctrl,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Write instructions for service team...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                setState(() => _notes = ctrl.text.trim());
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _showCouponDialog() {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Apply Coupon'),
        content: TextField(
          controller: ctrl,
          decoration: const InputDecoration(hintText: 'Enter coupon code'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => _coupon = ctrl.text.trim());
              Navigator.pop(context);
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  void _checkout(int total) {
    if (total == 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Cart is empty')));
      return;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Checkout'),
        content: Text('Proceed to pay ₹$total ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Checkout flow (demo)')),
              );
            },
            child: const Text('Pay'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CartProvider>();
    final CartModel? cart = provider.cart;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F8),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text(
          'My Cart',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: cart == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 90),
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    children: [
                      /// CART ITEMS
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: cart.items.map((CartItem item) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                children: [
                                  Container(
                                    width: 56,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        item.image,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) =>
                                            const Icon(Icons.car_repair),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text('₹ ${item.price}'),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => _removeItemLocally(item.id),
                                    child: Container(
                                      width: 34,
                                      height: 34,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                      child: const Icon(Icons.close, size: 18),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                      GestureDetector( onTap: _showNotesModal, child: _whiteCard( child: Row( children: [ Expanded( child: Text( _notes.isEmpty ? 'Any other requirements…' : _notes, style: TextStyle( color: _notes.isEmpty ? Colors.grey : Colors.black), ), ), const Icon(Icons.edit), ], ), ), ), const SizedBox(height: 14),

                      const SizedBox(height: 14),

                      _bookingDateTimeSection(),

                                            const SizedBox(height: 14),


                      /// NOTES
                      GestureDetector(
                        onTap: _showNotesModal,
                        child:
                            /// MODE OF SERVICE
                            _whiteCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Mode of Service',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Radio<String>(
                                        value: 'Pickup',
                                        groupValue: _mode,
                                        onChanged: (v) =>
                                            setState(() => _mode = v!),
                                      ),
                                      const Text('Pickup'),
                                      Radio<String>(
                                        value: 'Walk In',
                                        groupValue: _mode,
                                        onChanged: (v) =>
                                            setState(() => _mode = v!),
                                      ),
                                      const Text('Walk In'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                      ),

                      if (_mode == 'Pickup') ...[
                        const SizedBox(height: 14),
                        _pickupDateTimeSection(),
                        const SizedBox(height: 14),
                        _pickupLocationSection(),
                      ],

                      // const SizedBox(height: 14),

                      // /// COUPON
                      // GestureDetector(
                      //   onTap: _showCouponDialog,
                      //   child: _whiteCard(
                      //     child: Row(
                      //       children: const [
                      //         Icon(Icons.percent, color: Colors.green),
                      //         SizedBox(width: 10),
                      //         Expanded(
                      //           child: Text('Apply Coupon | GoApp Money',
                      //               style:
                      //                   TextStyle(fontWeight: FontWeight.bold)),
                      //         ),
                      //         Icon(Icons.arrow_forward_ios, size: 16),
                      //       ],
                      //     ),
                      //   ),
                      // ),

                      // const SizedBox(height: 14),

                      // /// MODE OF SERVICE
                      // _whiteCard(
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       const Text('Mode of Service',
                      //           style: TextStyle(
                      //               fontWeight: FontWeight.bold, fontSize: 16)),
                      //       Row(
                      //         children: [
                      //           Radio<String>(
                      //             value: 'Pickup',
                      //             groupValue: _mode,
                      //             onChanged: (v) =>
                      //                 setState(() => _mode = v!),
                      //           ),
                      //           const Text('Pickup'),
                      //           Radio<String>(
                      //             value: 'Walk In',
                      //             groupValue: _mode,
                      //             onChanged: (v) =>
                      //                 setState(() => _mode = v!),
                      //           ),
                      //           const Text('Walk In'),
                      //         ],
                      //       )
                      //     ],
                      //   ),
                      // ),
                      const SizedBox(height: 14),

                      /// BILL SUMMARY
                      _whiteCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Bill Summary',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 10),
                            _billRow('Item Total (Incl. taxes)', cart.total),
                            const Divider(),
                            _billRow('Grand Total', cart.total, bold: true),
                          ],
                        ),
                      ),

                      const SizedBox(height: 100),
                    ],
                  ),
                ),

                /// CHECKOUT BAR
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 10),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Cart Value',
                                style: TextStyle(color: Colors.black54),
                              ),
                              Text(
                                '₹ ${cart.total}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => _checkout(cart.total),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: const Text('Checkout'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _whiteCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }

  Widget _billRow(String title, int value, {bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        Text(
          '₹ $value',
          style: TextStyle(fontWeight: bold ? FontWeight.bold : null),
        ),
      ],
    );
  }
}
