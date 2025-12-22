
// FILE: lib/views/CarRent/cars_rent_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/CarModel/car_model.dart';
import '../../providers/CarProvider/car_provider.dart';
import '../../providers/DateTimeProvider/date_time_provider.dart';
import '../../views/BookingScreen/checkout_screen.dart';
import 'package:intl/intl.dart';

class CarsRentScreen extends StatefulWidget {
  const CarsRentScreen({super.key});

  @override
  State<CarsRentScreen> createState() => _CarsRentScreenState();
}

class _CarsRentScreenState extends State<CarsRentScreen> {
  bool guest = false; // you can pass this via constructor if needed

  Color get _primaryColor => Theme.of(context).colorScheme.primary;
  Color get _cardColor => Theme.of(context).cardColor;
  Color get _textPrimary => Theme.of(context).colorScheme.onSurface;
  Color get _textSecondary => Theme.of(context).colorScheme.onSurfaceVariant;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // initial load
      _loadCarsWithFilters();
    });
  }

  void _loadCarsWithFilters() {
    final dateTimeProvider = Provider.of<DateTimeProvider>(context, listen: false);
    final carProvider = Provider.of<CarProvider>(context, listen: false);

    String? startDateStr, endDateStr, startTimeStr, endTimeStr;
    if (dateTimeProvider.startDate != null) {
      final d = dateTimeProvider.startDate!;
      startDateStr = '${d.year}/${d.month.toString().padLeft(2,'0')}/${d.day.toString().padLeft(2,'0')}';
    }
    if (dateTimeProvider.endDate != null) {
      final d = dateTimeProvider.endDate!;
      endDateStr = '${d.year}/${d.month.toString().padLeft(2,'0')}/${d.day.toString().padLeft(2,'0')}';
    }
    if (dateTimeProvider.startTime != null) {
      final t = dateTimeProvider.startTime!;
      startTimeStr = '${t.hour.toString().padLeft(2,'0')}:${t.minute.toString().padLeft(2,'0')}';
    }
    if (dateTimeProvider.endTime != null) {
      final t = dateTimeProvider.endTime!;
      endTimeStr = '${t.hour.toString().padLeft(2,'0')}:${t.minute.toString().padLeft(2,'0')}';
    }

    // adapt this call to your provider signature
    carProvider.loadCars(
      lat: '17.4920832',
      lng: '78.3989487',
      startDate: startDateStr,
      endDate: endDateStr,
      startTime: startTimeStr,
      endTime: endTimeStr,
    );
  }

  String formatTime(TimeOfDay? time) {
    if (time == null) return '--:--';
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat.jm().format(dt);
  }

  Future<void> _pickDate({required bool isStart}) async {
    final provider = Provider.of<DateTimeProvider>(context, listen: false);
    final today = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? (provider.startDate ?? today) : (provider.endDate ?? provider.startDate ?? today),
      firstDate: today,
      lastDate: DateTime(today.year + 1),
    );

    if (picked != null) {
      if (isStart) provider.setStartDate(picked);
      else provider.setEndDate(picked);
      _loadCarsWithFilters();
    }
  }

  Future<void> _pickTime({required bool isStart}) async {
    final provider = Provider.of<DateTimeProvider>(context, listen: false);
    final initial = isStart ? (provider.startTime ?? TimeOfDay.now()) : (provider.endTime ?? TimeOfDay.now());
    final picked = await showTimePicker(context: context, initialTime: initial);
    if (picked != null) {
      if (isStart) provider.setStartTime(picked);
      else provider.setEndTime(picked);
      _loadCarsWithFilters();
    }
  }

  void _openCheckout(Car car) {
    final dt = Provider.of<DateTimeProvider>(context, listen: false);
    if (dt.allFieldsComplete) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CheckoutScreen(
            carImages: car.image,
            carId: car.id,
            carName: car.name,
            fuel: car.fuel,
            carType: car.carType,
            seats: car.seats,
            location: car.location,
            pricePerDay: car.pricePerDay,
            pricePerHour: car.pricePerHour,
            branch: car.branch.name ?? 'Unknown',
            cordinates: car.branch.coordinates,
          ),
        ),
      );
    } else {
      _showDateSelectionDialog();
    }
  }

  void _showDateSelectionDialog() {
    showDialog(context: context, builder: (context) => AlertDialog(
      title: const Text('Set Booking Time'),
      content: const Text('Please set start/end date and times before proceeding.'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cars for Rent')),
      body: Consumer<CarProvider>(
        builder: (context, carProvider, _) {
          if (carProvider.isLoading) return const Center(child: CircularProgressIndicator());
          if (carProvider.hasError) return Center(child: Text(carProvider.errorMessage ?? 'Failed to load'));
          final cars = carProvider.cars.where((c) => c != null).toList();
          if (cars.isEmpty) return const Center(child: Text('No cars available'));

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Expanded(child: GestureDetector(onTap: () => _pickDate(isStart: true), child: Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: _cardColor, borderRadius: BorderRadius.circular(8)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Start Date'), Consumer<DateTimeProvider>(builder: (_, dt, __) => Text(dt.startDate != null ? DateFormat('EEE, MMM d').format(dt.startDate!) : 'Tap to select'))])))),
                    const SizedBox(width: 8),
                    Expanded(child: GestureDetector(onTap: () => _pickDate(isStart: false), child: Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: _cardColor, borderRadius: BorderRadius.circular(8)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('End Date'), Consumer<DateTimeProvider>(builder: (_, dt, __) => Text(dt.endDate != null ? DateFormat('EEE, MMM d').format(dt.endDate!) : 'Tap to select'))])))),
                  ],
                ),
              ),

              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: cars.length,
                  itemBuilder: (context, index) {
                    final car = cars[index] as Car;
                    return Card(
                      child: ListTile(
                        leading: car.image.isNotEmpty ? Image.network(car.image.first, width: 64, fit: BoxFit.cover) : const Icon(Icons.directions_car),
                        title: Text(car.name),
                        subtitle: Text('₹${car.pricePerDay}/day • ${car.seats ?? 4} seats'),
                        trailing: ElevatedButton(
                          onPressed: () => _openCheckout(car),
                          child: const Text('Rent'),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
