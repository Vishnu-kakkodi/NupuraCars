import 'package:flutter/material.dart';
import 'package:nupura_cars/providers/MyCarProvider/car_provider.dart';
import 'package:nupura_cars/views/CarService/select_brand_screen.dart';
import 'package:provider/provider.dart';

class CurrentCarScreen extends StatefulWidget {
  const CurrentCarScreen({Key? key}) : super(key: key);

  @override
  State<CurrentCarScreen> createState() => _CurrentCarScreenState();
}

class _CurrentCarScreenState extends State<CurrentCarScreen> {
  bool _isLoadingAction = false;

  Future<void> _setCurrent(MyCarProvider provider, String userId, String carId) async {
    setState(() => _isLoadingAction = true);
    try {
      await provider.setCurrentCarForUser(userId, carId);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Current car updated')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to set current car: $e')));
    } finally {
      if (mounted) setState(() => _isLoadingAction = false);
    }
  }

  Future<void> _removeCar(MyCarProvider provider, String userId, String carId) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove car'),
        content: const Text('Are you sure you want to remove this car?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Remove')),
        ],
      ),
    );

    if (ok != true) return;

    setState(() => _isLoadingAction = true);
    try {
      await provider.removeUserCar(userId, carId);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Car removed')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to remove car: $e')));
    } finally {
      if (mounted) setState(() => _isLoadingAction = false);
    }
  }

  String _formatDate(DateTime? dt) {
    if (dt == null) return '';
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MyCarProvider>(context);
    // If you have authenticated user id in provider or elsewhere, pass it here.
    // For demo we use a placeholder 'me' — adjust as per your auth flow.
    final userId = 'me';

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
            padding: const EdgeInsets.only(right: 12.0),
            child: GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SelectBrandScreen())),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.green.shade700,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.green.shade700.withOpacity(0.12), blurRadius: 8, offset: const Offset(0, 3))],
                ),
                child: Row(
                  children: const [
                    Icon(Icons.add, color: Colors.white, size: 18),
                    SizedBox(width: 8),
                    Text('Add Car', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // attempt to refresh provider lists if you have such methods
          try {
            await provider.loadMyCars(userId);
            await provider.loadBrands();
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Refreshed')));
            }
          } catch (_) {}
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Header: current car preview
            if (currentCar != null)
              _CurrentCarHeader(currentCar: currentCar, onEdit: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SelectBrandScreen()))),
            if (currentCar == null)
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                color: Colors.blueGrey.shade50,
                child: ListTile(
                  leading: const Icon(Icons.info_outline, color: Colors.blueGrey),
                  title: const Text('No current car selected'),
                  subtitle: const Text('Tap a car below to set it as current or add a new car.'),
                  trailing: TextButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SelectBrandScreen())),
                    child: const Text('Add Car'),
                  ),
                ),
              ),
            const SizedBox(height: 18),

            // Section title
            Row(
              children: [
                const Text('My Cars', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                const SizedBox(width: 8),
                Text('(${myCars.length})', style: TextStyle(color: Colors.grey.shade600)),
                const Spacer(),
                if (provider.isMyCarsLoading) const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
              ],
            ),
            const SizedBox(height: 12),

            // Cards list
            if (myCars.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 28),
                child: Column(
                  children: [
                    const Icon(Icons.directions_car_outlined, size: 56, color: Colors.grey),
                    const SizedBox(height: 12),
                    Text('No cars added yet', style: TextStyle(color: Colors.grey.shade700, fontSize: 16)),
                    const SizedBox(height: 6),
                    TextButton.icon(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SelectBrandScreen())),
                      icon: const Icon(Icons.add),
                      label: const Text('Add your first car'),
                    ),
                  ],
                ),
              )
            else
              Column(
                children: myCars.map((c) {
                  final isCurrent = provider.currentCarId != null && provider.currentCarId == c.id;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: GestureDetector(
                      onTap: () {
                        if (!isCurrent) _setCurrent(provider, userId, c.id);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 260),
                        curve: Curves.easeOut,
                        decoration: BoxDecoration(
                          gradient: isCurrent
                              ? LinearGradient(colors: [Colors.indigo.shade50, Colors.indigo.shade100])
                              : const LinearGradient(colors: [Colors.white, Colors.white]),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: isCurrent ? Colors.indigo.shade200 : Colors.grey.shade200),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 4)),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          leading: _CarImageWidget(imageUrl: c.car?.image ?? ''),
                          title: Row(
                            children: [
                              Expanded(child: Text(c.brandName, style: const TextStyle(fontWeight: FontWeight.w800))),
                              if (isCurrent)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(color: Colors.indigo, borderRadius: BorderRadius.circular(8)),
                                  child: const Text('Current', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                                ),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 6),
                              Text(c.registrationNumber, style: TextStyle(color: Colors.grey.shade700)),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Chip(
                                    label: Text(c.fuelType, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                                    backgroundColor: Colors.grey.shade100,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(c.variant, style: const TextStyle(fontSize: 13, color: Colors.black87)),
                                  const SizedBox(width: 8),
                                  const Spacer(),                                ],
                              ),
                            ],
                          ),
                          trailing: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  // Navigate to edit screen - reuse SelectBrandScreen (or your edit flow)
                                  Navigator.push(context, MaterialPageRoute(builder: (_) => const SelectBrandScreen()));
                                },
                                icon: Icon(Icons.edit, color: Colors.grey.shade700),
                              ),
                              // IconButton(
                              //   onPressed: _isLoadingAction ? null : () => _removeCar(provider, userId, c.id),
                              //   icon: Icon(Icons.delete_outline, color: Colors.red.shade400),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

            const SizedBox(height: 32),
            // CTA: Add Car
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                backgroundColor: Colors.green.shade700,
              ),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SelectBrandScreen())),
              icon: const Icon(Icons.add),
              label: const Text('Add another car', style: TextStyle(fontWeight: FontWeight.w700)),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _CurrentCarHeader extends StatelessWidget {
  final dynamic currentCar;
  final VoidCallback onEdit;
  const _CurrentCarHeader({Key? key, required this.currentCar, required this.onEdit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imageUrl = currentCar.car?.image ?? '';
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: LinearGradient(colors: [Colors.indigo.shade600, Colors.indigo.shade400]),
        boxShadow: [BoxShadow(color: Colors.indigo.shade600.withOpacity(0.12), blurRadius: 12, offset: const Offset(0, 6))],
      ),
      child: Row(
        children: [
          Container(
            width: 84,
            height: 56,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white24),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: imageUrl.isNotEmpty
                  ? Image.network(imageUrl, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.directions_car, color: Colors.white70))
                  : const Icon(Icons.directions_car, color: Colors.white70, size: 36),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(currentCar.brandName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18)),
                const SizedBox(height: 6),
                Text(currentCar.registrationNumber, style: const TextStyle(color: Colors.white70)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Chip(label: Text(currentCar.fuelType ?? 'Unknown', style: const TextStyle(fontWeight: FontWeight.bold)), backgroundColor: Colors.white24),
                    const SizedBox(width: 8),
                    Text(currentCar.variant ?? '', style: const TextStyle(color: Colors.white70)),
                    const Spacer(),
                    Text('Active', style: TextStyle(color: Colors.white.withOpacity(0.95), fontWeight: FontWeight.w800)),
                  ],
                ),
              ],
            ),
          ),
          IconButton(onPressed: onEdit, icon: const Icon(Icons.edit, color: Colors.white70)),
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
      return CircleAvatar(radius: 26, backgroundColor: Colors.grey.shade100, child: Icon(Icons.directions_car, color: Colors.grey.shade700));
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(imageUrl, width: 56, height: 56, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: Colors.grey.shade100, child: Icon(Icons.directions_car, color: Colors.grey.shade700))),
    );
  }
}
