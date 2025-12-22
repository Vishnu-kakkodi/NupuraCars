// // lib/views/CarService/add_car_details_screen.dart
// import 'package:flutter/material.dart';
// import 'package:nupura_cars/models/MyCarModel/car_models.dart';
// import 'package:nupura_cars/providers/MyCarProvider/car_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:nupura_cars/utils/StoragePreference/storage_prefs.dart';

// class AddCarDetailsScreen extends StatefulWidget {
//   final String brandName;
//   final String modelName;
//   final String modelImage;
//   final String carId; // <-- service car id from API

//   const AddCarDetailsScreen({
//     super.key,
//     required this.brandName,
//     required this.modelName,
//     required this.modelImage,
//     required this.carId,
//   });

//   @override
//   State<AddCarDetailsScreen> createState() => _AddCarDetailsScreenState();
// }

// class _AddCarDetailsScreenState extends State<AddCarDetailsScreen> {
//   final TextEditingController _regController = TextEditingController();
//   String _fuel = '';
//   String _variant = ''; // LOW / MEDIUM / FULL
//   bool _saving = false;
//   String? _userId;

//   @override
//   void initState() {
//     super.initState();
//     _loadUserId();
//   }

//   Future<void> _loadUserId() async {
//     final uid = await StorageHelper.getUserId();
//     if (mounted) {
//       setState(() {
//         _userId = uid;
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _regController.dispose();
//     super.dispose();
//   }

//   Future<void> _saveCar() async {
//     if (_userId == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('User not found. Please login again.')),
//       );
//       return;
//     }

//     if (_regController.text.trim().isEmpty || _fuel.isEmpty || _variant.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Please enter registration, fuel type & variant'),
//         ),
//       );
//       return;
//     }

//     setState(() => _saving = true);

//     try {
//       final myCarProvider =
//           Provider.of<MyCarProvider>(context, listen: false);

//       final request = UserCarRequest(
//         carId: widget.carId,
//         registrationNumber: _regController.text.trim(),
//         fuelType: _fuel,
//         variant: _variant,
//       );

//       await myCarProvider.addUserCar(_userId!, request);

//       if (mounted) {
//         Navigator.popUntil(context, (route) => route.isFirst);
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to save car: $e')),
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() => _saving = false);
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final primary = Theme.of(context).colorScheme.primary;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Select Your Car'),
//       ),
//       resizeToAvoidBottomInset: true,
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
//               // Car card with MODEL IMAGE
//               Container(
//                 width: double.infinity,
//                 height: 180,
//                 decoration: BoxDecoration(
//                   color: Theme.of(context).cardColor,
//                   borderRadius: BorderRadius.circular(16),
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
//                               errorBuilder: (context, error, stackTrace) {
//                                 return const Icon(
//                                   Icons.directions_car,
//                                   size: 64,
//                                 );
//                               },
//                             )
//                           : const Icon(
//                               Icons.directions_car,
//                               size: 64,
//                             ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       widget.modelName.toUpperCase(),
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                     const SizedBox(height: 2),
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
//               const Text(
//                 'Car Registration',
//                 style: TextStyle(fontWeight: FontWeight.w600),
//               ),
//               const SizedBox(height: 8),
//               TextField(
//                 controller: _regController,
//                 textInputAction: TextInputAction.done,
//                 decoration: InputDecoration(
//                   hintText: 'Enter Car Registration',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 24),
//               const Text(
//                 'Fuel Type',
//                 style: TextStyle(fontWeight: FontWeight.w600),
//               ),
//               const SizedBox(height: 8),
//               Row(
//                 children: [
//                   _fuelButton('Diesel', primary),
//                   const SizedBox(width: 12),
//                   _fuelButton('Petrol', primary),
//                 ],
//               ),

//               const SizedBox(height: 24),
//               const Text(
//                 'Variant',
//                 style: TextStyle(fontWeight: FontWeight.w600),
//               ),
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
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
//         child: SizedBox(
//           width: double.infinity,
//           height: 48,
//           child: ElevatedButton(
//             onPressed: _saving ? null : _saveCar,
//             child: _saving
//                 ? const SizedBox(
//                     width: 18,
//                     height: 18,
//                     child: CircularProgressIndicator(strokeWidth: 2),
//                   )
//                 : const Text('Save Car'),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _fuelButton(String label, Color primary) {
//     final bool selected = _fuel == label;
//     return Expanded(
//       child: GestureDetector(
//         onTap: () => setState(() => _fuel = label),
//         child: Container(
//           padding: const EdgeInsets.symmetric(vertical: 12),
//           decoration: BoxDecoration(
//             color: selected ? primary : Colors.transparent,
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(
//               color: selected ? primary : Colors.grey.shade300,
//             ),
//           ),
//           child: Center(
//             child: Text(
//               label,
//               style: TextStyle(
//                 fontWeight: FontWeight.w600,
//                 color: selected ? Colors.white : Colors.black,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _variantButton(String label, Color primary) {
//     final bool selected = _variant == label;
//     return Expanded(
//       child: GestureDetector(
//         onTap: () => setState(() => _variant = label),
//         child: Container(
//           padding: const EdgeInsets.symmetric(vertical: 12),
//           decoration: BoxDecoration(
//             color: selected ? primary : Colors.transparent,
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(
//               color: selected ? primary : Colors.grey.shade300,
//             ),
//           ),
//           child: Center(
//             child: Text(
//               label,
//               style: TextStyle(
//                 fontWeight: FontWeight.w600,
//                 color: selected ? Colors.white : Colors.black,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }



















// lib/views/CarService/add_car_details_screen.dart
import 'package:flutter/material.dart';
import 'package:nupura_cars/models/MyCarModel/car_models.dart'; // UserCarRequest
import 'package:nupura_cars/providers/MyCarProvider/car_provider.dart';
import 'package:nupura_cars/views/MainScreen/main_navbar_screen.dart';
import 'package:provider/provider.dart';
import 'package:nupura_cars/utils/StoragePreference/storage_prefs.dart';

class AddCarDetailsScreen extends StatefulWidget {
  final String brandName;
  final String modelName;
  final String modelImage;
  final String carId; // service car id from API

  /// null => Add new car, non-null => Edit existing car
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
  String _variant = ''; // LOW / MEDIUM / FULL
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
    if (mounted) {
      setState(() {
        _userId = uid;
      });
    }
  }

  void _prefillIfEditing() {
    final editingCar = widget.editingCar;
    if (editingCar == null) return;

    // These field names are based on your earlier usage in HomeScreen:
    // registrationNumber, fuelType, variant
    _regController.text = editingCar.registrationNumber;
    _fuel = editingCar.fuelType;
    _variant = editingCar.variant;
  }

  @override
  void dispose() {
    _regController.dispose();
    super.dispose();
  }

  Future<void> _saveCar() async {
    if (!widget.isEdit && _userId == null) {
      // userId required only for add
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not found. Please login again.')),
      );
      return;
    }

    if (_regController.text.trim().isEmpty || _fuel.isEmpty || _variant.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter registration, fuel type & variant'),
        ),
      );
      return;
    }

    setState(() => _saving = true);

    try {
      final myCarProvider =
          Provider.of<MyCarProvider>(context, listen: false);

      final request = UserCarRequest(
        carId: widget.carId,
        registrationNumber: _regController.text.trim(),
        fuelType: _fuel,
        variant: _variant,
      );

      if (widget.isEdit) {
        // 🔄 EDIT FLOW
        // Assuming your provider has: Future<UserCar?> updateUserCar(String userCarId, UserCarRequest request)
        await myCarProvider.updateUserCar(_userId.toString(), widget.editingCar!.id, request);
      } else {
        // ➕ ADD FLOW
        await myCarProvider.addUserCar(_userId!, request);
      }

      if (mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MainNavigationScreen(initialIndex: 0,)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save car: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEdit ? 'Edit Your Car' : 'Select Your Car'),
      ),
      resizeToAvoidBottomInset: true,
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
              // Car card with MODEL IMAGE
              Container(
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
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
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.directions_car,
                                  size: 64,
                                );
                              },
                            )
                          : const Icon(
                              Icons.directions_car,
                              size: 64,
                            ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.modelName.toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.brandName,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
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
                textInputAction: TextInputAction.done,
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
                  _fuelButton('Diesel', primary),
                  const SizedBox(width: 12),
                  _fuelButton('Petrol', primary),
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
                  _variantButton('LOW', primary),
                  const SizedBox(width: 8),
                  _variantButton('MEDIUM', primary),
                  const SizedBox(width: 8),
                  _variantButton('FULL', primary),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: SizedBox(
          width: double.infinity,
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

  Widget _fuelButton(String label, Color primary) {
    final bool selected = _fuel == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _fuel = label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? primary : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? primary : Colors.grey.shade300,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: selected ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _variantButton(String label, Color primary) {
    final bool selected = _variant == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _variant = label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? primary : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? primary : Colors.grey.shade300,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: selected ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
