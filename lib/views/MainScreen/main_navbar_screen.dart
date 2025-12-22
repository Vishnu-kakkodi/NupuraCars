import 'package:nupura_cars/views/BookingScreen/booking_screen.dart';
import 'package:nupura_cars/views/CarService/custom_service_screen.dart';
import 'package:nupura_cars/views/CarService/service_booking_screen.dart';
import 'package:nupura_cars/views/HomeScreen/home_screen.dart';
import 'package:nupura_cars/views/ProfileScreen/profile_screen.dart';
import 'package:nupura_cars/views/guest_modal.dart';
import 'package:nupura_cars/providers/AuthProvider/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:upgrader/upgrader.dart';


class MainNavigationScreen extends StatefulWidget {
  final int initialIndex;

  const MainNavigationScreen({
    Key? key,
    this.initialIndex = 0,
  }) : super(key: key);

  @override
  _MainNavigationScreenState createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _animationController;
  late AnimationController _fabController;

  // Theme colors
  Color get _primaryColor => Theme.of(context).colorScheme.primary;
  Color get _secondaryColor => Theme.of(context).colorScheme.primaryContainer;
  Color get _accentColor => Theme.of(context).colorScheme.secondary;
  Color get _backgroundColor => Theme.of(context).colorScheme.background;
  Color get _cardColor => Theme.of(context).cardColor;
  Color get _textPrimary => Theme.of(context).colorScheme.onSurface;
  Color get _textSecondary => Theme.of(context).colorScheme.onSurfaceVariant;
  Color get _surfaceColor => Theme.of(context).colorScheme.surface;
  Color get _scaffoldBackgroundColor =>
      Theme.of(context).scaffoldBackgroundColor;
  Color get _dividerColor => Theme.of(context).dividerColor;

  // 0: Home, 1: Service Booking, 2: Bookings, 3: Profile
  final List<Widget> _screens = const [
    HomeScreen(),
    BookingScreen(),
        AllServiceBookingScreen(),
    ProfileScreen(),
  ];

  final List<NavItem> _navItems = const [
    NavItem(icon: Icons.home_filled, label: 'Home'),
    NavItem(icon: Icons.build_circle_outlined, label: 'Car Bookings'),
    NavItem(icon: Icons.event_note, label: 'Car Service'),
    NavItem(icon: Icons.account_circle, label: 'Profile'),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fabController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _animationController.forward();

    // Check if trying to access restricted tab as guest
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_currentIndex == 2) {
        // Bookings tab is now index 2
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        if (authProvider.isGuest) {
          setState(() {
            _currentIndex = 0;
          });
          GuestLoginBottomSheet.show(context);
        }
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _fabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return UpgradeAlert(
      upgrader: Upgrader(),
      child: Scaffold(
        body: _screens[_currentIndex],
        bottomNavigationBar: _buildModernGradientBar(context),
        // You can switch styles:
        // bottomNavigationBar: _buildFloatingIndicatorBar(context),
        // bottomNavigationBar: _buildGlassMorphBar(context),
        // bottomNavigationBar: _buildMinimalLineBar(context),
        // bottomNavigationBar: _buildBubbleBar(context),
        // bottomNavigationBar: _buildSideCurvedBar(context),
      ),
    );
  }

  // Style 1: Modern Gradient Navigation Bar (ICON TOP, TEXT BOTTOM)
  Widget _buildModernGradientBar(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          height: 70,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [Colors.grey.shade900, Colors.grey.shade800]
                  : [
                      _primaryColor.withOpacity(0.1),
                      _secondaryColor.withOpacity(0.1)
                    ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withOpacity(0.4)
                    : _primaryColor.withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
            border: Border.all(
              color: isDark
                  ? Colors.grey.shade800
                  : _primaryColor.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _navItems.asMap().entries.map((entry) {
              int index = entry.key;
              NavItem item = entry.value;
              bool isActive = _currentIndex == index;
              // Bookings tab (index 2) is locked for guests
              bool isLocked = authProvider.isGuest && index == 2;

              return GestureDetector(
                onTap: () => _updateIndex(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: isActive
                        ? LinearGradient(
                            colors: [_primaryColor, _secondaryColor],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                              color: _primaryColor.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : null,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          Icon(
                            item.icon,
                            color: isActive ? Colors.white : _textSecondary,
                            size: isActive ? 22 : 20,
                          ),
                          if (isLocked)
                            Positioned(
                              top: -2,
                              right: -2,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: _accentColor,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.lock,
                                  size: 8,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.label,
                        style: TextStyle(
                          color: isActive ? Colors.white : _textSecondary,
                          fontWeight:
                              isActive ? FontWeight.w600 : FontWeight.w500,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  // Style 2: Floating Indicator Navigation Bar
  Widget _buildFloatingIndicatorBar(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final itemCount = _navItems.length;
    final totalWidth = MediaQuery.of(context).size.width - 40;
    final itemWidth = totalWidth / itemCount;

    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          height: 65,
          decoration: BoxDecoration(
            color: isDark ? _surfaceColor : _cardColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withOpacity(0.3)
                    : Colors.black.withOpacity(0.1),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                left: _currentIndex * itemWidth,
                child: Container(
                  width: itemWidth,
                  height: 65,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [_primaryColor, _secondaryColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: _navItems.asMap().entries.map((entry) {
                  int index = entry.key;
                  NavItem item = entry.value;
                  bool isActive = _currentIndex == index;
                  bool isLocked = authProvider.isGuest && index == 2;

                  return GestureDetector(
                    onTap: () => _updateIndex(index),
                    child: SizedBox(
                      width: itemWidth,
                      height: 65,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            children: [
                              Icon(
                                item.icon,
                                color: isActive ? Colors.white : _textSecondary,
                                size: 22,
                              ),
                              if (isLocked)
                                Positioned(
                                  top: -2,
                                  right: -2,
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: _accentColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.lock,
                                      size: 8,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.label,
                            style: TextStyle(
                              color: isActive ? Colors.white : _textSecondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  // Style 3: Glass Morphism Navigation Bar
  Widget _buildGlassMorphBar(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          height: 70,
          decoration: BoxDecoration(
            color: isDark
                ? Colors.black.withOpacity(0.3)
                : Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: isDark
                  ? Colors.white.withOpacity(0.1)
                  : Colors.white.withOpacity(0.5),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withOpacity(0.4)
                    : Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                isDark
                    ? Colors.black.withOpacity(0.2)
                    : Colors.white.withOpacity(0.2),
                BlendMode.darken,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: _navItems.asMap().entries.map((entry) {
                  int index = entry.key;
                  NavItem item = entry.value;
                  bool isActive = _currentIndex == index;
                  bool isLocked = authProvider.isGuest && index == 2;

                  return GestureDetector(
                    onTap: () => _updateIndex(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isActive
                            ? _primaryColor.withOpacity(0.2)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(15),
                        border: isActive
                            ? Border.all(
                                color: _primaryColor.withOpacity(0.3),
                                width: 1,
                              )
                            : null,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Stack(
                            children: [
                              Icon(
                                item.icon,
                                color:
                                    isActive ? _primaryColor : _textSecondary,
                                size: 22,
                              ),
                              if (isLocked)
                                Positioned(
                                  top: -2,
                                  right: -2,
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: _accentColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.lock,
                                      size: 8,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.label,
                            style: TextStyle(
                              color:
                                  isActive ? _primaryColor : _textSecondary,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }

  // Style 4: Minimal Line Navigation Bar
  Widget _buildMinimalLineBar(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final itemCount = _navItems.length;
    final totalWidth = MediaQuery.of(context).size.width;
    final itemWidth = totalWidth / itemCount;

    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return SizedBox(
          height: 80,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: isDark ? _surfaceColor : _cardColor,
                  border: Border(
                    top: BorderSide(color: _dividerColor, width: 0.5),
                  ),
                ),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                left: _currentIndex * itemWidth,
                bottom: 0,
                child: Container(
                  width: itemWidth,
                  height: 3,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [_primaryColor, _secondaryColor],
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(2),
                      topRight: Radius.circular(2),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: _navItems.asMap().entries.map((entry) {
                  int index = entry.key;
                  NavItem item = entry.value;
                  bool isActive = _currentIndex == index;
                  bool isLocked = authProvider.isGuest && index == 2;

                  return GestureDetector(
                    onTap: () => _updateIndex(index),
                    child: SizedBox(
                      width: itemWidth,
                      height: 80,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isActive
                                      ? _primaryColor.withOpacity(0.1)
                                      : Colors.transparent,
                                ),
                                child: Icon(
                                  item.icon,
                                  color: isActive
                                      ? _primaryColor
                                      : _textSecondary,
                                  size: 24,
                                ),
                              ),
                              if (isLocked)
                                Positioned(
                                  top: 0,
                                  right: 8,
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: _accentColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.lock,
                                      size: 8,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.label,
                            style: TextStyle(
                              color: isActive
                                  ? _primaryColor
                                  : _textSecondary,
                              fontSize: 12,
                              fontWeight: isActive
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  // Style 5: Bubble Navigation Bar
  Widget _buildBubbleBar(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final itemCount = _navItems.length;
    final totalWidth = MediaQuery.of(context).size.width - 32;
    final itemWidth = totalWidth / itemCount;

    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          height: 70,
          child: Stack(
            children: [
              // Background
              Container(
                decoration: BoxDecoration(
                  color: isDark ? _surfaceColor : _cardColor,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? Colors.black.withOpacity(0.3)
                          : Colors.black.withOpacity(0.1),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
              ),
              // Active Bubble
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                left: _currentIndex * itemWidth +
                    (itemWidth - 60) / 2,
                bottom: 5,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [_primaryColor, _secondaryColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: _primaryColor.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                ),
              ),
              // Items
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: _navItems.asMap().entries.map((entry) {
                  int index = entry.key;
                  NavItem item = entry.value;
                  bool isActive = _currentIndex == index;
                  bool isLocked = authProvider.isGuest && index == 2;

                  return GestureDetector(
                    onTap: () => _updateIndex(index),
                    child: SizedBox(
                      width: itemWidth,
                      height: 70,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                transform: Matrix4.identity()
                                  ..scale(isActive ? 1.2 : 1.0),
                                child: Icon(
                                  item.icon,
                                  color: isActive
                                      ? Colors.white
                                      : _textSecondary,
                                  size: 24,
                                ),
                              ),
                              if (isLocked)
                                Positioned(
                                  top: -2,
                                  right: 8,
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: _accentColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.lock,
                                      size: 8,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          AnimatedOpacity(
                            duration:
                                const Duration(milliseconds: 300),
                            opacity: isActive ? 1.0 : 0.0,
                            child: Text(
                              item.label,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  // Style 6: Side Curved Navigation Bar
  Widget _buildSideCurvedBar(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          height: 70,
          decoration: BoxDecoration(
            color: isDark ? _surfaceColor : _cardColor,
            borderRadius: BorderRadius.circular(35),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withOpacity(0.3)
                    : Colors.black.withOpacity(0.1),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _navItems.asMap().entries.map((entry) {
              int index = entry.key;
              NavItem item = entry.value;
              bool isActive = _currentIndex == index;
              bool isLocked = authProvider.isGuest && index == 2;

              return GestureDetector(
                onTap: () => _updateIndex(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: isActive ? 120 : 60,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: isActive
                        ? LinearGradient(
                            colors: [_primaryColor, _secondaryColor],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    borderRadius: BorderRadius.circular(25),
                    border: isActive
                        ? null
                        : Border.all(
                            color: _dividerColor,
                            width: 1,
                          ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          Icon(
                            item.icon,
                            color: isActive
                                ? Colors.white
                                : _textSecondary,
                            size: 22,
                          ),
                          if (isLocked)
                            Positioned(
                              top: -2,
                              right: -2,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: _accentColor,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.lock,
                                  size: 8,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        ],
                      ),
                      if (isActive) ...[
                        const SizedBox(width: 8),
                        Text(
                          item.label,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _updateIndex(int index) {
    if (_currentIndex != index) {
      // Bookings tab is index 2 – block guests
      if (index == 2) {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        if (authProvider.isGuest) {
          GuestLoginBottomSheet.show(context);
          return;
        }
      }

      setState(() {
        _currentIndex = index;
      });
      _animationController.reset();
      _animationController.forward();
    }
  }
}

class NavItem {
  final IconData icon;
  final String label;

  const NavItem({
    required this.icon,
    required this.label,
  });
}

// Navigation Helper Class
class NavigationHelper {
  static const int homeTab = 0;
    static const int bookingTab = 1;
  static const int serviceBookingTab = 2;
  static const int profileTab = 3;

  static void navigateToTab(BuildContext context, int tabIndex,
      {bool replace = false}) {
    if (replace) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              MainNavigationScreen(initialIndex: tabIndex),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              MainNavigationScreen(initialIndex: tabIndex),
        ),
      );
    }
  }

  static void navigateToHome(BuildContext context, {bool replace = false}) {
    navigateToTab(context, homeTab, replace: replace);
  }


  static void navigateToBookings(BuildContext context,
      {bool replace = false}) {
    navigateToTab(context, bookingTab, replace: replace);
  }

    static void navigateToServiceBookings(BuildContext context,
      {bool replace = false}) {
    navigateToTab(context, serviceBookingTab, replace: replace);
  }

  static void navigateToProfile(BuildContext context,
      {bool replace = false}) {
    navigateToTab(context, profileTab, replace: replace);
  }
}
