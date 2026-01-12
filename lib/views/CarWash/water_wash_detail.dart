

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nupura_cars/constants/api_constants.dart';
import 'package:nupura_cars/views/CarWash/car_wash_booking_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class CarWashDetailScreen extends StatefulWidget {
  final String serviceId;

  const CarWashDetailScreen({
    Key? key,
    required this.serviceId,
  }) : super(key: key);

  @override
  State<CarWashDetailScreen> createState() => _CarWashDetailScreenState();
}

class _CarWashDetailScreenState extends State<CarWashDetailScreen> {
  final String _adminWhatsAppNumber = '919133905401';

  bool _loading = true;
  String _error = '';
  String? _selectedType;

  Map<String, dynamic>? _service;

  /// GENERIC TYPES (REUSABLE)
  final Map<String, Map<String, dynamic>> _serviceTypes = {
    'exterior': {
      'name': 'Exterior Service',
      'icon': Icons.directions_car,
      'description': 'Complete exterior cleaning and protection',
    },
    'interior': {
      'name': 'Interior Service',
      'icon': Icons.dashboard,
      'description': 'Deep interior cleaning and care',
    },
  };

  bool get _canProceed => _selectedType != null && _service != null;

  @override
  void initState() {
    super.initState();
    _fetchService();
  }

  /// 🔥 FETCH SINGLE CAR WASH
  Future<void> _fetchService() async {
    try {
      final res = await http.get(
        Uri.parse(
          '${ApiConstants.baseUrl}/admin/getsinglecarwash/${widget.serviceId}',
        ),
      );

      if (res.statusCode == 200) {
        final decoded = jsonDecode(res.body);

        if (decoded['isSuccessfull'] == true &&
            decoded['carWash'] != null) {
          final data = decoded['carWash'];

          setState(() {
            _service = {
              'id': data['_id'],
              'name': data['washName'],
              'price': data['price'],
              'image': data['image']?['url'],
              'benefits': _normalizeBenefits(data['benefits']),
              'seater': data['seater'],
            };
            _loading = false;
          });
          return;
        }
      }

      _setError('Service not found');
    } catch (e) {
      _setError('Something went wrong');
    }
  }

  List<String> _normalizeBenefits(dynamic raw) {
    if (raw is List) {
      return raw.expand<String>((b) {
        if (b is String && b.startsWith('[')) {
          return List<String>.from(jsonDecode(b));
        }
        return [b.toString()];
      }).toList();
    }
    return [];
  }

  void _setError(String msg) {
    setState(() {
      _error = msg;
      _loading = false;
    });
  }

  /// 📞 CALL
  Future<void> _callNow() async {
    final uri = Uri.parse('tel:9133905401');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  /// 💬 WHATSAPP
  Future<void> _openWhatsApp() async {
    final typeName = _selectedType != null
        ? _serviceTypes[_selectedType]!['name']
        : _service!['name'];

    final message = '''
Hello, I'm interested in ${_service!['name']}

Selected Service: $typeName
Vehicle Seater: ${_service!['seater']}

Please share pricing and details.
''';

    final uri = Uri.parse(
      'https://wa.me/$_adminWhatsAppNumber?text=${Uri.encodeComponent(message)}',
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  /// 🧾 ENQUIRE
  void _handleEnquiry() {
    if (!_canProceed) return;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Enquire for ${_serviceTypes[_selectedType]!['name']}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _callNow,
              icon: const Icon(Icons.call),
              label: const Text('Call Now'),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _openWhatsApp,
              icon: const Icon(Icons.chat),
              label: const Text('WhatsApp'),
            ),
          ],
        ),
      ),
    );
  }

  /// 📦 BOOK
  void _handleBooking() {
    if (!_canProceed) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CarWashBookingScreen(
          washId: _service!['id'],
          washName: _service!['name'],
          price: 500,
          imageUrl: _service!['image'],
                  serviceType: _selectedType!,

        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error.isNotEmpty) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(_error)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_service!['name']),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// IMAGE
            Image.network(
              _service!['image'],
              height: 240,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.local_car_wash, size: 80),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
  
                  /// BENEFITS
                  if (_service!['benefits'].isNotEmpty) ...[
                    const Text(
                      'What’s Included',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ..._service!['benefits']
                        .map<Widget>(
                          (b) => Row(
                            children: [
                              const Icon(Icons.check, size: 16),
                              const SizedBox(width: 6),
                              Expanded(child: Text(b)),
                            ],
                          ),
                        )
                        .toList(),
                  ],

                  const SizedBox(height: 24),

                  /// TYPE SELECTION
                  const Text(
                    'Select Service Type',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  _buildTypeCard('exterior'),
                  const SizedBox(height: 12),
                  _buildTypeCard('interior'),

                  const SizedBox(height: 120),
                ],
              ),
            ),
          ],
        ),
      ),

      /// 🔒 BOTTOM BAR
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 8),
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _selectedType != null
                    ? _serviceTypes[_selectedType]!['name']
                    : 'Select Service Type',
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 6),

              /// INFO TEXT
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border:
                      Border.all(color: Colors.orange.withOpacity(0.4)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline,
                        color: Colors.orange, size: 18),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Before paying the advance amount, please enquire with us and then proceed to payment.',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _canProceed ? _handleEnquiry : null,
                      child: const Text('Enquire'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _canProceed ? _handleBooking : null,
                      child: Text('Book @ ₹${_service!['price']}'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// TYPE CARD
  Widget _buildTypeCard(String type) {
    final data = _serviceTypes[type]!;
    final isSelected = _selectedType == type;

    return GestureDetector(
      onTap: () => setState(() => _selectedType = type),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              data['icon'],
              color: isSelected ? Colors.blue : Colors.grey,
              size: 28,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['name'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    data['description'],
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
            Icon(
              isSelected
                  ? Icons.check_circle
                  : Icons.circle_outlined,
              color: isSelected ? Colors.blue : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
