import 'package:flutter/material.dart';
import 'package:nupura_cars/providers/MyCarProvider/car_provider.dart';
import 'package:nupura_cars/views/MyCar/select_brand_screen.dart';
import 'package:provider/provider.dart';
import 'package:nupura_cars/utils/StoragePreference/storage_prefs.dart';

class CurrentCarScreen extends StatefulWidget {
  const CurrentCarScreen({Key? key}) : super(key: key);

  @override
  State<CurrentCarScreen> createState() => _CurrentCarScreenState();
}

class _CurrentCarScreenState extends State<CurrentCarScreen> {
  bool _isLoadingAction = false;
  bool _loadingUser = true;
  String? _userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final id = await StorageHelper.getUserId();
    if (mounted) {
      setState(() {
        _userId = id;
        _loadingUser = false;
      });
    }
  }

  Future<void> _setCurrent(
      MyCarProvider provider, String carId) async {
    if (_userId == null) return;

    setState(() => _isLoadingAction = true);
    try {
      await provider.setCurrentCarForUser(_userId!, carId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Current car updated')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to set current car: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoadingAction = false);
    }
  }

  Future<void> _removeCar(
      MyCarProvider provider, String carId) async {
    if (_userId == null) return;

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove car'),
        content: const Text('Are you sure you want to remove this car?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Remove')),
        ],
      ),
    );

    if (ok != true) return;

    setState(() => _isLoadingAction = true);
    try {
      await provider.removeUserCar(_userId!, carId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Car removed')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to remove car: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoadingAction = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingUser) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final provider = Provider.of<MyCarProvider>(context);
    final currentCar = provider.currentCar;
    final myCars = provider.myCars;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cars'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0.5,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SelectBrandScreen()),
              ),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.green.shade700,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.add, color: Colors.white, size: 18),
                    SizedBox(width: 8),
                    Text('Add Car',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          if (_userId != null) {
            await provider.loadMyCars(_userId!);
          }
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (currentCar != null)
              _CurrentCarHeader(
                currentCar: currentCar,
                onEdit: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const SelectBrandScreen()),
                ),
              ),

            if (currentCar == null)
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                color: Colors.blueGrey.shade50,
                child: ListTile(
                  leading:
                      const Icon(Icons.info_outline, color: Colors.blueGrey),
                  title: const Text('No current car selected'),
                  subtitle: const Text(
                      'Tap a car below to set it as current or add a new car.'),
                  trailing: TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const SelectBrandScreen()),
                    ),
                    child: const Text('Add Car'),
                  ),
                ),
              ),

            const SizedBox(height: 18),

            Row(
              children: [
                const Text('My Cars',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                const SizedBox(width: 8),
                Text('(${myCars.length})',
                    style: TextStyle(color: Colors.grey.shade600)),
              ],
            ),

            const SizedBox(height: 12),

            if (myCars.isEmpty)
              Column(
                children: [
                  const Icon(Icons.directions_car_outlined,
                      size: 56, color: Colors.grey),
                  const SizedBox(height: 12),
                  Text('No cars added yet',
                      style: TextStyle(
                          color: Colors.grey.shade700, fontSize: 16)),
                ],
              )
            else
              Column(
                children: myCars.map((c) {
                  final isCurrent = provider.currentCarId == c.id;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: GestureDetector(
                      onTap: () {
                        if (!isCurrent) {
                          _setCurrent(provider, c.id);
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: isCurrent
                                  ? Colors.indigo
                                  : Colors.grey.shade200),
                        ),
                        child: ListTile(
                          leading:
                              _CarImageWidget(imageUrl: c.car?.image ?? ''),
                          title: Text(
                            c.brandName,
                            style:
                                const TextStyle(fontWeight: FontWeight.w800),
                          ),
                          subtitle: Text(c.registrationNumber),
                          trailing: isCurrent
                              ? const Chip(
                                  label: Text('Current'),
                                  backgroundColor: Colors.indigo,
                                  labelStyle:
                                      TextStyle(color: Colors.white),
                                )
                              : null,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

            const SizedBox(height: 24),

            ElevatedButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const SelectBrandScreen()),
              ),
              icon: const Icon(Icons.add),
              label: const Text('Add another car'),
            ),
          ],
        ),
      ),
    );
  }
}

class _CurrentCarHeader extends StatelessWidget {
  final dynamic currentCar;
  final VoidCallback onEdit;

  const _CurrentCarHeader({
    Key? key,
    required this.currentCar,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imageUrl = currentCar.car?.image ?? '';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: LinearGradient(
            colors: [Colors.indigo.shade600, Colors.indigo.shade400]),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: imageUrl.isNotEmpty
                ? Image.network(imageUrl,
                    width: 84, height: 56, fit: BoxFit.cover)
                : const Icon(Icons.directions_car,
                    size: 36, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(currentCar.brandName,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 18)),
                Text(currentCar.registrationNumber,
                    style: const TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          IconButton(
            onPressed: onEdit,
            icon: const Icon(Icons.edit, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _CarImageWidget extends StatelessWidget {
  final String imageUrl;

  const _CarImageWidget({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return const CircleAvatar(
        radius: 26,
        child: Icon(Icons.directions_car),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        imageUrl,
        width: 56,
        height: 56,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
            const Icon(Icons.directions_car),
      ),
    );
  }
}
