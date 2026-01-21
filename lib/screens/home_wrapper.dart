import 'package:flutter/material.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:provider/provider.dart';
import '../providers/bike_provider.dart';
import 'maintenance_screen.dart';
import 'mileage_screen.dart';

class HomeWrapper extends StatefulWidget {
  const HomeWrapper({super.key});

  @override
  State<HomeWrapper> createState() => _HomeWrapperState();
}

class _HomeWrapperState extends State<HomeWrapper> {
  final _pageController = PageController(initialPage: 0);
  final _controller = NotchBottomBarController(index: 0);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BikeProvider>(context);
    
    final List<Widget> bottomBarPages = [
      const MaintenanceScreen(),
      const MileageScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Wrench"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(provider.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => provider.toggleTheme(),
          )
        ],
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: bottomBarPages,
      ),
      extendBody: true,
      bottomNavigationBar: AnimatedNotchBottomBar(
        notchBottomBarController: _controller,
        color: Theme.of(context).cardColor,
        showLabel: true,
        notchColor: Colors.blueAccent,
        removeMargins: false,
        bottomBarWidth: 500,
        durationInMilliSeconds: 300,
        bottomBarItems: const [
          BottomBarItem(
            inActiveItem: Icon(Icons.build_outlined, color: Colors.grey),
            activeItem: Icon(Icons.build, color: Colors.white),
            itemLabel: 'Service',
          ),
          BottomBarItem(
            inActiveItem: Icon(Icons.speed_outlined, color: Colors.grey),
            activeItem: Icon(Icons.speed, color: Colors.white),
            itemLabel: 'Mileage',
          ),
        ],
        onTap: (index) {
          _pageController.jumpToPage(index);
        },
        kIconSize: 24.0,
        kBottomRadius: 28.0,
      ),
    );
  }
}