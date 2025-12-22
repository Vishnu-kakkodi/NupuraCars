
// import 'package:flutter/material.dart';
// import 'package:nupura_cars/providers/MaintenanceProvider/maintenance_provider.dart';
// import 'package:nupura_cars/providers/MyCarProvider/car_provider.dart';
// import 'package:nupura_cars/providers/ServiceNameProvider/current_service_car_provider.dart';
// import 'package:nupura_cars/providers/ServiceNameProvider/service_booking_provider.dart';
// import 'package:nupura_cars/providers/ServiceNameProvider/service_name_provider.dart';
// import 'package:nupura_cars/providers/VersionProvider/version_provider.dart';
// import 'package:nupura_cars/views/MaintenanceScreen/maintenance_screen.dart';
// import 'package:nupura_cars/views/Version/global_watcher.dart';
// import 'package:provider/provider.dart';
// import 'package:nupura_cars/providers/AuthProvider/auth_provider.dart';
// import 'package:nupura_cars/providers/BannerProvider/banner_provider.dart';
// import 'package:nupura_cars/providers/BookingProvider/booking_provider.dart';
// import 'package:nupura_cars/providers/CarProvider/car_provider.dart';
// import 'package:nupura_cars/providers/CarServiceProvider/car_service_provider.dart';
// import 'package:nupura_cars/providers/DateTimeProvider/date_time_provider.dart';
// import 'package:nupura_cars/providers/DocumentProvider/document_provider.dart';
// import 'package:nupura_cars/providers/LocationProvider/location_provider.dart';
// import 'package:nupura_cars/providers/WalletProvider/wallet_provider.dart';
// import 'package:nupura_cars/splash_screen.dart';
// import 'package:nupura_cars/theme/app_theme.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => AuthProvider()),
//         ChangeNotifierProvider(create: (_) => BannerProvider()),
//         ChangeNotifierProvider(create: (_) => BookingProvider()),
//         ChangeNotifierProvider(create: (_) => CarProvider()),
//         ChangeNotifierProvider(create: (_) => DateTimeProvider()),
//         ChangeNotifierProvider(create: (_) => DocumentProvider()),
//         ChangeNotifierProvider(create: (_) => LocationProvider()),
//         ChangeNotifierProvider(create: (_) => WalletProvider()),
//         // ChangeNotifierProvider(create: (_) => CarServiceProvider()),

//         // 🔥 NEW: Maintenance + Version providers
//         ChangeNotifierProvider(create: (_) => MaintenanceProvider()),
//         ChangeNotifierProvider(create: (_) => VersionProvider()),
//         ChangeNotifierProvider(create: (_) => MyCarProvider()),
//         ChangeNotifierProvider(create: (_) => ServiceNameProvider()),
//         ChangeNotifierProvider(create: (_) => CurrentServiceCarProvider()),
//         ChangeNotifierProvider(create: (_) => ServiceBookingProvider()),
//       ],
//       child: LifecycleWatcher(
//         // 🔥 Handles app resume → re-checks
//         child: Consumer<MaintenanceProvider>(
//           builder: (context, maintenance, _) {
//             return MaterialApp(
//               debugShowCheckedModeBanner: false,
//               title: 'Car Service App',
//               theme: AppTheme.lightTheme,
//               darkTheme: AppTheme.darkTheme,
//               themeMode: ThemeMode.system, // mobile system theme
//               // 🔥 Wrap root with UpgradeWatcher to show update popup
//               home: UpgradeWatcher(child: _buildRoot(maintenance)),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildRoot(MaintenanceProvider maintenance) {
//     // If app is under maintenance, show blocking screen
//     if (maintenance.isMaintenance) {
//       return const MaintenanceScreen();
//     }

//     // Otherwise, normal flow
//     return const SplashScreen();
//   }
// }

// /// 🔥 This widget listens to app lifecycle and triggers checks on resume
// class LifecycleWatcher extends StatefulWidget {
//   final Widget child;

//   const LifecycleWatcher({super.key, required this.child});

//   @override
//   State<LifecycleWatcher> createState() => _LifecycleWatcherState();
// }

// class _LifecycleWatcherState extends State<LifecycleWatcher>
//     with WidgetsBindingObserver {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);

//     // Optional: initial checks on app startup
//     Future.microtask(() {
//       final maintenance = context.read<MaintenanceProvider>();
//       final version = context.read<VersionProvider>();

//       maintenance.checkMaintenance();
//       version.checkVersion();
//     });
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     debugPrint('🔥 Lifecycle → $state');

//     if (state == AppLifecycleState.resumed) {
//       // When app comes back to foreground, re-check both
//       final maintenance = context.read<MaintenanceProvider>();
//       final version = context.read<VersionProvider>();

//       maintenance.checkMaintenance();
//       version.checkVersion();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return widget.child;
//   }
// }


















// import 'package:flutter/material.dart';
// import 'package:nupura_cars/splash_screen.dart';
// import 'package:provider/provider.dart';

// import 'package:nupura_cars/core/app_lifecycle_service.dart';

// import 'package:nupura_cars/providers/AuthProvider/auth_provider.dart';
// import 'package:nupura_cars/providers/BannerProvider/banner_provider.dart';
// import 'package:nupura_cars/providers/BookingProvider/booking_provider.dart';
// import 'package:nupura_cars/providers/CarProvider/car_provider.dart';
// import 'package:nupura_cars/providers/DateTimeProvider/date_time_provider.dart';
// import 'package:nupura_cars/providers/DocumentProvider/document_provider.dart';
// import 'package:nupura_cars/providers/LocationProvider/location_provider.dart';
// import 'package:nupura_cars/providers/WalletProvider/wallet_provider.dart';
// import 'package:nupura_cars/providers/MyCarProvider/car_provider.dart';
// import 'package:nupura_cars/providers/MaintenanceProvider/maintenance_provider.dart';
// import 'package:nupura_cars/providers/VersionProvider/version_provider.dart';
// import 'package:nupura_cars/providers/ServiceNameProvider/service_name_provider.dart';
// import 'package:nupura_cars/providers/ServiceNameProvider/current_service_car_provider.dart';
// import 'package:nupura_cars/providers/ServiceNameProvider/service_booking_provider.dart';

// import 'package:nupura_cars/views/MaintenanceScreen/maintenance_screen.dart';
// import 'package:nupura_cars/views/Version/global_watcher.dart';
// import 'package:nupura_cars/theme/app_theme.dart';

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();

//   // 🔥 Central lifecycle service
//   AppLifecycleService.instance.init();

//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => AuthProvider()),
//         ChangeNotifierProvider(create: (_) => BannerProvider()),
//         ChangeNotifierProvider(create: (_) => BookingProvider()),
//         ChangeNotifierProvider(create: (_) => CarProvider()),
//         ChangeNotifierProvider(create: (_) => DateTimeProvider()),
//         ChangeNotifierProvider(create: (_) => DocumentProvider()),
//         ChangeNotifierProvider(create: (_) => LocationProvider()),
//         ChangeNotifierProvider(create: (_) => WalletProvider()),
//         ChangeNotifierProvider(create: (_) => MyCarProvider()),
//         ChangeNotifierProvider(create: (_) => ServiceNameProvider()),
//         ChangeNotifierProvider(create: (_) => CurrentServiceCarProvider()),
//         ChangeNotifierProvider(create: (_) => ServiceBookingProvider()),

//         // 🔥 Core system providers
//         ChangeNotifierProvider(create: (_) => MaintenanceProvider()),
//         ChangeNotifierProvider(create: (_) => VersionProvider()),
//       ],
//       child: Builder(
//         builder: (context) {
//           // 🔁 App resume → maintenance + version check
//           AppLifecycleService.instance.onAppResumed ??= () {
//             debugPrint("🔁 App resumed → checking maintenance & version");
//             context.read<MaintenanceProvider>().checkMaintenance();
//             context.read<VersionProvider>().checkVersion();
//           };

//           // 🔥 Initial startup checks
//           Future.microtask(() {
//             context.read<MaintenanceProvider>().checkMaintenance();
//             context.read<VersionProvider>().checkVersion();
//           });

//           return Consumer<MaintenanceProvider>(
//             builder: (context, maintenance, _) {
//               return MaterialApp(
//                 debugShowCheckedModeBanner: false,
//                 title: 'Car Service App',
//                 theme: AppTheme.lightTheme,
//                 darkTheme: AppTheme.darkTheme,
//                 themeMode: ThemeMode.system,
//                 home: UpgradeWatcher(
//                   child: _buildRoot(maintenance),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildRoot(MaintenanceProvider maintenance) {
//     // While checking → splash
//     if (maintenance.isChecking && !maintenance.isMaintenance) {
//       return const SplashScreen();
//     }

//     // Backend says maintenance ON
//     // if (maintenance.isMaintenance) {
//     //   return const MaintenanceScreen();
//     // }

//     // Normal flow
//     return const SplashScreen();
//   }
// }




















import 'package:flutter/material.dart';
import 'package:nupura_cars/providers/CartProvider/cart_provider.dart';
import 'package:nupura_cars/providers/ServiceNameProvider/new_service_provider.dart';
import 'package:provider/provider.dart';

/// 🔹 Splash
import 'package:nupura_cars/splash_screen.dart';

/// 🔹 Core lifecycle
import 'package:nupura_cars/core/app_lifecycle_service.dart';

/// 🔹 Providers
import 'package:nupura_cars/providers/AuthProvider/auth_provider.dart';
import 'package:nupura_cars/providers/BannerProvider/banner_provider.dart';
import 'package:nupura_cars/providers/BookingProvider/booking_provider.dart';
import 'package:nupura_cars/providers/CarProvider/car_provider.dart';
import 'package:nupura_cars/providers/DateTimeProvider/date_time_provider.dart';
import 'package:nupura_cars/providers/DocumentProvider/document_provider.dart';
import 'package:nupura_cars/providers/LocationProvider/location_provider.dart';
import 'package:nupura_cars/providers/WalletProvider/wallet_provider.dart';
import 'package:nupura_cars/providers/MyCarProvider/car_provider.dart';
import 'package:nupura_cars/providers/MaintenanceProvider/maintenance_provider.dart';
import 'package:nupura_cars/providers/VersionProvider/version_provider.dart';
import 'package:nupura_cars/providers/ServiceNameProvider/service_name_provider.dart';
import 'package:nupura_cars/providers/ServiceNameProvider/current_service_car_provider.dart';
import 'package:nupura_cars/providers/ServiceNameProvider/service_booking_provider.dart';

/// 🔹 Maintenance + Version watcher
import 'package:nupura_cars/views/MaintenanceScreen/maintenance_screen.dart';
import 'package:nupura_cars/views/Version/global_watcher.dart';

/// 🔹 Theme
import 'package:nupura_cars/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  /// Init lifecycle watcher
  AppLifecycleService.instance.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => BannerProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
        ChangeNotifierProvider(create: (_) => CarProvider()),
        ChangeNotifierProvider(create: (_) => DateTimeProvider()),
        ChangeNotifierProvider(create: (_) => DocumentProvider()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        ChangeNotifierProvider(create: (_) => WalletProvider()),
        ChangeNotifierProvider(create: (_) => MyCarProvider()),
        ChangeNotifierProvider(create: (_) => ServiceNameProvider()),
        ChangeNotifierProvider(create: (_) => CurrentServiceCarProvider()),
        ChangeNotifierProvider(create: (_) => ServiceBookingProvider()),

        /// 🔥 Core system providers
        ChangeNotifierProvider(create: (_) => MaintenanceProvider()),
        ChangeNotifierProvider(create: (_) => VersionProvider()),
               ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => ServiceProvider()),
      ],
      child: Builder(
        builder: (context) {
          /// When app resumes from background → re-check maintenance + version
          AppLifecycleService.instance.onAppResumed ??= () {
            debugPrint("🔁 App resumed → re-check maintenance & version (nupura_cars)");
            context.read<MaintenanceProvider>().checkMaintenance();
            context.read<VersionProvider>().checkVersion();
          };

          /// Initial startup checks (fire and forget)
          Future.microtask(() {
            context.read<MaintenanceProvider>().checkMaintenance();
            context.read<VersionProvider>().checkVersion();
          });

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Car Service App',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.system,

            /// Normal initial route – Splash will navigate to Home/Login etc.
            home: const SplashScreen(),

            /// GLOBAL WRAPPER: Maintenance + Version watcher
            ///
            /// Important:
            ///  - We DO NOT override while "checking"
            ///  - We ONLY override when backend says maintenance = true
            builder: (context, child) {
              final maintenance = context.watch<MaintenanceProvider>();

              // Default: keep whatever the navigator wants to show
              Widget screen = child ?? const SizedBox.shrink();

              // If backend says maintenance ON → force MaintenanceScreen
              if (maintenance.isMaintenance) {
                screen = const MaintenanceScreen();
              }

              // Always wrap with UpgradeWatcher (version checks)
              return UpgradeWatcher(
                child: screen,
              );
            },
          );
        },
      ),
    );
  }
}
