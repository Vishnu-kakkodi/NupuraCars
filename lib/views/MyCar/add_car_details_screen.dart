
// import 'package:flutter/material.dart';
// import 'package:nupura_cars/models/MyCarModel/car_models.dart';
// import 'package:nupura_cars/providers/MyCarProvider/car_provider.dart';
// import 'package:nupura_cars/views/MainScreen/main_navbar_screen.dart';
// import 'package:provider/provider.dart';
// import 'package:nupura_cars/utils/StoragePreference/storage_prefs.dart';

// class AddCarDetailsScreen extends StatefulWidget {
//   final String brandName;
//   final String modelName;
//   final String modelImage;
//   final String carId;
//   final UserCar? editingCar;

//   const AddCarDetailsScreen({
//     super.key,
//     required this.brandName,
//     required this.modelName,
//     required this.modelImage,
//     required this.carId,
//     this.editingCar,
//   });

//   bool get isEdit => editingCar != null;

//   @override
//   State<AddCarDetailsScreen> createState() => _AddCarDetailsScreenState();
// }

// class _AddCarDetailsScreenState extends State<AddCarDetailsScreen> {
//   final TextEditingController _regController = TextEditingController();

//   String _fuel = '';
//   String _variant = '';
//   String _seater = ''; // ✅ NEW (5 / 7)

//   bool _saving = false;
//   String? _userId;

//   @override
//   void initState() {
//     super.initState();
//     _loadUserId();
//     _prefillIfEditing();
//   }

//   Future<void> _loadUserId() async {
//     final uid = await StorageHelper.getUserId();
//     if (mounted) setState(() => _userId = uid);
//   }

//   void _prefillIfEditing() {
//     final car = widget.editingCar;
//     if (car == null) return;

//     _regController.text = car.registrationNumber;
//     _fuel = car.fuelType;
//     _variant = car.variant;
//     _seater = car.seater.toString(); // ✅ PREFILL
//   }

//   @override
//   void dispose() {
//     _regController.dispose();
//     super.dispose();
//   }

//   Future<void> _saveCar() async {
//     if (!widget.isEdit && _userId == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('User not found. Please login again.')),
//       );
//       return;
//     }

//     if (_regController.text.trim().isEmpty ||
//         _fuel.isEmpty ||
//         _variant.isEmpty ||
//         _seater.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Please fill all car details'),
//         ),
//       );
//       return;
//     }

//     setState(() => _saving = true);

//     try {
//       final provider = Provider.of<MyCarProvider>(context, listen: false);

//       final request = UserCarRequest(
//         carId: widget.carId,
//         registrationNumber: _regController.text.trim(),
//         fuelType: _fuel,
//         variant: _variant,
//         seater: int.parse(_seater).toString(), // ✅ SEND SEATER
//       );

//       if (widget.isEdit) {
//         await provider.updateUserCar(
//           _userId.toString(),
//           widget.editingCar!.id,
//           request,
//         );
//       } else {
//         await provider.addUserCar(_userId!, request);
//       }

//       if (mounted) {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (_) => const MainNavigationScreen(initialIndex: 0),
//           ),
//         );
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to save car: $e')),
//         );
//       }
//     } finally {
//       if (mounted) setState(() => _saving = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final primary = Theme.of(context).colorScheme.primary;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.isEdit ? 'Edit Your Car' : 'Select Your Car'),
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: EdgeInsets.fromLTRB(
//             16,
//             16,
//             16,
//             16 + MediaQuery.of(context).viewInsets.bottom,
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // CAR CARD
//               Container(
//                 width: double.infinity,
//                 height: 180,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(16),
//                   color: Theme.of(context).cardColor,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.05),
//                       blurRadius: 10,
//                       offset: const Offset(0, 5),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(12),
//                       child: widget.modelImage.isNotEmpty
//                           ? Image.network(
//                               widget.modelImage,
//                               height: 110,
//                               fit: BoxFit.contain,
//                               errorBuilder: (_, __, ___) =>
//                                   const Icon(Icons.directions_car, size: 64),
//                             )
//                           : const Icon(Icons.directions_car, size: 64),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       widget.modelName.toUpperCase(),
//                       style: const TextStyle(
//                           fontWeight: FontWeight.bold, fontSize: 16),
//                     ),
//                     Text(
//                       widget.brandName,
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: Colors.grey.shade600,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 24),

//               const Text('Car Registration',
//                   style: TextStyle(fontWeight: FontWeight.w600)),
//               const SizedBox(height: 8),
//               TextField(
//                 controller: _regController,
//                 decoration: InputDecoration(
//                   hintText: 'Enter Car Registration',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 24),
//               const Text('Fuel Type',
//                   style: TextStyle(fontWeight: FontWeight.w600)),
//               const SizedBox(height: 8),
//               Row(
//                 children: [
//                   _fuelButton('Diesel', primary),
//                   const SizedBox(width: 12),
//                   _fuelButton('Petrol', primary),
//                 ],
//               ),

//               const SizedBox(height: 24),
//               const Text('Variant',
//                   style: TextStyle(fontWeight: FontWeight.w600)),
//               const SizedBox(height: 8),
//               Row(
//                 children: [
//                   _variantButton('LOW', primary),
//                   const SizedBox(width: 8),
//                   _variantButton('MEDIUM', primary),
//                   const SizedBox(width: 8),
//                   _variantButton('FULL', primary),
//                 ],
//               ),

//               // ✅ SEATER SELECTION
//               const SizedBox(height: 24),
//               const Text('Seater',
//                   style: TextStyle(fontWeight: FontWeight.w600)),
//               const SizedBox(height: 8),
//               Row(
//                 children: [
//                   _seaterButton('5', primary),
//                   const SizedBox(width: 12),
//                   _seaterButton('7', primary),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
//         child: SizedBox(
//           height: 48,
//           child: ElevatedButton(
//             onPressed: _saving ? null : _saveCar,
//             child: _saving
//                 ? const SizedBox(
//                     width: 18,
//                     height: 18,
//                     child: CircularProgressIndicator(strokeWidth: 2),
//                   )
//                 : Text(widget.isEdit ? 'Update Car' : 'Save Car'),
//           ),
//         ),
//       ),
//     );
//   }

//   // ---------------- BUTTONS ----------------

//   Widget _fuelButton(String label, Color primary) {
//     final selected = _fuel == label;
//     return Expanded(
//       child: GestureDetector(
//         onTap: () => setState(() => _fuel = label),
//         child: _choiceBox(label, selected, primary),
//       ),
//     );
//   }

//   Widget _variantButton(String label, Color primary) {
//     final selected = _variant == label;
//     return Expanded(
//       child: GestureDetector(
//         onTap: () => setState(() => _variant = label),
//         child: _choiceBox(label, selected, primary),
//       ),
//     );
//   }

//   Widget _seaterButton(String label, Color primary) {
//     final selected = _seater == label;
//     return Expanded(
//       child: GestureDetector(
//         onTap: () => setState(() => _seater = label),
//         child: _choiceBox('$label Seater', selected, primary),
//       ),
//     );
//   }

//   Widget _choiceBox(String text, bool selected, Color primary) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 12),
//       decoration: BoxDecoration(
//         color: selected ? primary : Colors.transparent,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: selected ? primary : Colors.grey.shade300,
//         ),
//       ),
//       child: Center(
//         child: Text(
//           text,
//           style: TextStyle(
//             fontWeight: FontWeight.w600,
//             color: selected ? Colors.white : Colors.black,
//           ),
//         ),
//       ),
//     );
//   }
// }
























import 'package:flutter/material.dart';
import 'package:nupura_cars/models/MyCarModel/car_models.dart';
import 'package:nupura_cars/providers/MyCarProvider/car_provider.dart';
import 'package:nupura_cars/views/MainScreen/main_navbar_screen.dart';
import 'package:provider/provider.dart';
import 'package:nupura_cars/utils/StoragePreference/storage_prefs.dart';

class AddCarDetailsScreen extends StatefulWidget {
  final String brandName;
  final String modelName;
  final String modelImage;
  final String carId;
  final UserCar? editingCar;

  const AddCarDetailsScreen({
    super.key,
    required this.brandName,
    required this.modelName,
    required this.modelImage,
    required this.carId,
    this.editingCar,
  });

  bool get isEdit => editingCar != null;

  @override
  State<AddCarDetailsScreen> createState() => _AddCarDetailsScreenState();
}

class _AddCarDetailsScreenState extends State<AddCarDetailsScreen> {
  final TextEditingController _regController = TextEditingController();

  String _fuel = '';
  String _variant = '';
  String _seater = '';

  bool _saving = false;
  String? _userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
    _prefillIfEditing();
  }

  Future<void> _loadUserId() async {
    final uid = await StorageHelper.getUserId();
    if (mounted) setState(() => _userId = uid);
  }

  void _prefillIfEditing() {
    final car = widget.editingCar;
    if (car == null) return;

    _regController.text = car.registrationNumber;
    _fuel = car.fuelType;
    _variant = car.variant;
    _seater = car.seater.toString();
  }

  @override
  void dispose() {
    _regController.dispose();
    super.dispose();
  }

  Future<void> _saveCar() async {
    if (!widget.isEdit && _userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not found. Please login again.')),
      );
      return;
    }

    if (_regController.text.trim().isEmpty ||
        _fuel.isEmpty ||
        _variant.isEmpty ||
        _seater.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all car details')),
      );
      return;
    }

    setState(() => _saving = true);

    try {
      final provider = Provider.of<MyCarProvider>(context, listen: false);

      final request = UserCarRequest(
        carId: widget.carId,
        registrationNumber: _regController.text.trim(),
        fuelType: _fuel,
        variant: _variant,
        seater: int.parse(_seater).toString(),
      );

      if (widget.isEdit) {
        await provider.updateUserCar(
          _userId.toString(),
          widget.editingCar!.id,
          request,
        );
      } else {
        await provider.addUserCar(_userId!, request);
      }

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const MainNavigationScreen(initialIndex: 0),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save car: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEdit ? 'Edit Your Car' : 'Select Your Car'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            16,
            16,
            16,
            16 + MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// CAR CARD
              Container(
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Theme.of(context).cardColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: widget.modelImage.isNotEmpty
                          ? Image.network(
                              widget.modelImage,
                              height: 110,
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) =>
                                  const Icon(Icons.directions_car, size: 64),
                            )
                          : const Icon(Icons.directions_car, size: 64),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.modelName.toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      widget.brandName,
                      style: TextStyle(
                        fontSize: 12,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Car Registration',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _regController,
                decoration: InputDecoration(
                  hintText: 'Enter Car Registration',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Fuel Type',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _fuelButton('Diesel', cs),
                  const SizedBox(width: 12),
                  _fuelButton('Petrol', cs),
                ],
              ),

              const SizedBox(height: 24),

              const Text(
                'Variant',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _variantButton('LOW', cs),
                  const SizedBox(width: 8),
                  _variantButton('MEDIUM', cs),
                  const SizedBox(width: 8),
                  _variantButton('FULL', cs),
                ],
              ),

              const SizedBox(height: 24),

              const Text(
                'Seater',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _seaterButton('5', cs),
                  const SizedBox(width: 12),
                  _seaterButton('7', cs),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: SizedBox(
          height: 48,
          child: ElevatedButton(
            onPressed: _saving ? null : _saveCar,
            child: _saving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(widget.isEdit ? 'Update Car' : 'Save Car'),
          ),
        ),
      ),
    );
  }

  // ---------------- BUTTONS ----------------

  Widget _fuelButton(String label, ColorScheme cs) {
    final selected = _fuel == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _fuel = label),
        child: _choiceBox(label, selected, cs),
      ),
    );
  }

  Widget _variantButton(String label, ColorScheme cs) {
    final selected = _variant == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _variant = label),
        child: _choiceBox(label, selected, cs),
      ),
    );
  }

  Widget _seaterButton(String label, ColorScheme cs) {
    final selected = _seater == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _seater = label),
        child: _choiceBox('$label Seater', selected, cs),
      ),
    );
  }

  Widget _choiceBox(String text, bool selected, ColorScheme cs) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: selected ? cs.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: selected ? cs.primary : cs.outlineVariant,
        ),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: selected ? cs.onPrimary : cs.onSurface,
          ),
        ),
      ),
    );
  }
}
