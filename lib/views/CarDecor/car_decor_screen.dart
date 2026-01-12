import 'package:flutter/material.dart';
import 'package:nupura_cars/providers/Decor/car_decor_provider.dart';
import 'package:nupura_cars/views/CarService/service_card.dart';
import 'package:nupura_cars/views/CarService/current_car.dart';
import 'package:provider/provider.dart';
import 'package:nupura_cars/models/MyCarModel/car_models.dart';
import 'package:nupura_cars/providers/MyCarProvider/car_provider.dart';
import 'package:nupura_cars/views/MyCar/select_brand_screen.dart';
import 'car_decor_category_detail_screen.dart';

class CarDecorScreen extends StatefulWidget {
  const CarDecorScreen({Key? key}) : super(key: key);

  static const int columns = 4;
  static const double spacing = 12.0;
  static const double outerPadding = 12.0;

  @override
  State<CarDecorScreen> createState() => _CarDecorScreenState();
}

class _CarDecorScreenState extends State<CarDecorScreen> {
  bool _checkedCar = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<CarDecorProvider>().loadCategories();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_checkedCar) {
      _checkedCar = true;
      final carProvider = context.read<MyCarProvider>();

      if (carProvider.myCars.isEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showAddCarSheet(context);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final decorProvider = context.watch<CarDecorProvider>();
    final myCarProvider = context.watch<MyCarProvider>();

    final UserCar? currentCar = myCarProvider.currentCar ??
        (myCarProvider.myCars.isNotEmpty ? myCarProvider.myCars.first : null);

    final mq = MediaQuery.of(context);
    final totalSpacing =
        CarDecorScreen.spacing * (CarDecorScreen.columns - 1);
    final usableWidth =
        mq.size.width - (CarDecorScreen.outerPadding * 2) - totalSpacing;

    final itemWidth = usableWidth / CarDecorScreen.columns;
    final itemHeight = itemWidth * 1.45;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Car Decors'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(CarDecorScreen.outerPadding),
        child: decorProvider.loading
            ? const Center(child: CircularProgressIndicator())
            : decorProvider.categories.isEmpty
                ? _emptyUI()
                : GridView.builder(
                    itemCount: decorProvider.categories.length,
                    gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: CarDecorScreen.columns,
                      crossAxisSpacing: CarDecorScreen.spacing,
                      mainAxisSpacing: CarDecorScreen.spacing,
                      childAspectRatio: itemWidth / itemHeight,
                    ),
                    itemBuilder: (_, index) {
                      final item = decorProvider.categories[index];
                      return ServiceCard(
                        title: item.name,
                        imageUrl: item.image,
                        cellWidth: itemWidth,
                        cellHeight: itemHeight,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  CarDecorCategoryDetailScreen(
                                categoryId: item.id,
                                categoryName: item.name,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
      ),
    );
  }

  Widget _emptyUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined,
              size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No car decors available',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  void _showAddCarSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (ctx) => SizedBox(
        height: 220,
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text('No cars found',
                style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                'Add a car to continue browsing car decors',
                textAlign: TextAlign.center,
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => SelectBrandScreen()),
                        );
                      },
                      child: const Text('Add Car'),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
