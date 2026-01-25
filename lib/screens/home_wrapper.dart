import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import '../providers/bike_provider.dart';
import 'maintenance_screen.dart';
import 'mileage_screen.dart';

class HomeWrapper extends StatefulWidget {
  const HomeWrapper({super.key});

  @override
  State<HomeWrapper> createState() => _HomeWrapperState();
}

class _HomeWrapperState extends State<HomeWrapper> {
  final _controller = NotchBottomBarController(index: 0);
  final _pageController = PageController(initialPage: 0);

  // Track current index for the AppBar Title
  int _currentIndex = 0;

  // Variable to control the Notch (Background) Color
  Color _notchColor = Colors.blueAccent;

  final List<Widget> _screens = [
    const MaintenanceScreen(),
    const MileageScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BikeProvider>(context, listen: false).init();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BikeProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (!provider.isInitialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Colors.blueAccent),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _currentIndex == 0 ? "Service" : "Mileage",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [
          // --- THEME TOGGLE ---
          IconButton(
            icon: Icon(
              provider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () {
              provider.toggleTheme();
            },
          ),
          const SizedBox(width: 10),
        ],
      ),

      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
          _controller.jumpTo(index);
        },
        children: _screens,
      ),
      extendBody: true,
      bottomNavigationBar: AnimatedNotchBottomBar(
        notchBottomBarController: _controller,
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        showLabel: true,
        notchColor: _notchColor,
        itemLabelStyle: TextStyle(
          color: isDark ? Colors.grey : Colors.black54,
          fontSize: 10,
        ),
        bottomBarItems: const [
          BottomBarItem(
            inActiveItem: Icon(Icons.build_outlined, color: Colors.grey),
            activeItem: Icon(Icons.build, color: Colors.white),
            itemLabel: 'Service',
          ),
          BottomBarItem(
            inActiveItem: Icon(
              Icons.local_gas_station_outlined,
              color: Colors.grey,
            ),
            activeItem: Icon(Icons.local_gas_station, color: Colors.white),
            itemLabel: 'Mileage',
          ),
        ],
        onTap: (index) {
          _pageController.jumpToPage(index);
          setState(() {
            _currentIndex = index;
            if (index == 1) {
              _notchColor = Colors.green;
            } else {
              _notchColor = Colors.blueAccent;
            }
          });
        },
        kIconSize: 24,
        kBottomRadius: 28,
      ),
    );
  }
}
