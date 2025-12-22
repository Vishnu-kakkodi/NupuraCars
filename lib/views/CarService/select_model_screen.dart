// lib/views/CarService/select_model_screen.dart
import 'package:flutter/material.dart';
import 'package:nupura_cars/models/MyCarModel/car_models.dart';
import 'package:nupura_cars/providers/MyCarProvider/car_provider.dart';
import 'package:nupura_cars/views/CarService/add_car_details_screen.dart';
import 'package:provider/provider.dart';

class SelectModelScreen extends StatefulWidget {
  /// Full brand object (from brands API)
  final Brand brand;

  /// null => add new car, non-null => editing existing car
  final UserCar? editingCar;

  const SelectModelScreen({
    super.key,
    required this.brand,
    this.editingCar,
  });

  @override
  State<SelectModelScreen> createState() => _SelectModelScreenState();
}

class _SelectModelScreenState extends State<SelectModelScreen> {
  String _query = '';

  @override
  void initState() {
    super.initState();

    /// Load models / service cars for this brand
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<MyCarProvider>(context, listen: false);
      // This should call:
      // GET /api/admin/allservicecarsbyfilter?brandName=<brand.name>
      provider.loadServiceCarsForBrand(widget.brand.name);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MyCarProvider>(context);

    // serviceCars is List<ServiceCarModel> with fields: id, name, image
    final models = provider.serviceCars
        .where(
          (m) => m.name.toLowerCase().contains(_query.toLowerCase()),
        )
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Select Model - ${widget.brand.name}'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search your car...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                isDense: true,
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.9,
              ),
              itemCount: models.length,
              itemBuilder: (_, index) {
                final model = models[index];

                return InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddCarDetailsScreen(
                          // Brand / model info from API
                          brandName: widget.brand.name,
                          modelName: model.name,
                          modelImage: model.image,
                          carId: model.id,

                          // 👉 if editing, pass existing UserCar
                          editingCar: widget.editingCar,
                        ),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: (model.image.isNotEmpty)
                                ? Image.network(
                                    model.image,
                                    fit: BoxFit.contain,
                                    errorBuilder:
                                        (context, error, stackTrace) {
                                      return const Center(
                                        child: Icon(Icons.directions_car),
                                      );
                                    },
                                  )
                                : const Center(
                                    child: Icon(Icons.directions_car),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        model.name,
                        style: const TextStyle(fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
