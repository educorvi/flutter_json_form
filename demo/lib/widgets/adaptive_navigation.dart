import 'package:flutter/material.dart';

class NavigationItem {
  final String label;
  final IconData selectedIcon;
  final IconData unselectedIcon;
  final Widget page;

  NavigationItem({
    required this.label,
    required this.selectedIcon,
    required this.unselectedIcon,
    required this.page,
  });
}

class AdaptiveNavigation extends StatefulWidget {
  final List<NavigationItem> items;
  final Widget? appBarTitle;
  final List<Widget>? appBarActions;

  const AdaptiveNavigation({
    super.key,
    required this.items,
    this.appBarTitle,
    this.appBarActions,
  });

  @override
  State<AdaptiveNavigation> createState() => _AdaptiveNavigationState();
}

class _AdaptiveNavigationState extends State<AdaptiveNavigation> {
  int _selectedIndex = 0;

  void _onDestinationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width >= 800;

    if (isWideScreen) {
      return _buildNavigationRail();
    } else {
      return _buildBottomNavigation();
    }
  }

  Widget _buildNavigationRail() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: widget.appBarTitle,
        actions: widget.appBarActions,
      ),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: _onDestinationSelected,
            labelType: NavigationRailLabelType.all,
            destinations: widget.items
                .map((item) => NavigationRailDestination(
                      icon: Icon(item.unselectedIcon),
                      selectedIcon: Icon(item.selectedIcon),
                      label: Text(item.label),
                    ))
                .toList(),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: widget.items.map((item) => item.page).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: widget.appBarTitle,
        actions: widget.appBarActions,
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: widget.items.map((item) => item.page).toList(),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onDestinationSelected,
        destinations: widget.items
            .map((item) => NavigationDestination(
                  icon: Icon(item.unselectedIcon),
                  selectedIcon: Icon(item.selectedIcon),
                  label: item.label,
                ))
            .toList(),
      ),
    );
  }
}
