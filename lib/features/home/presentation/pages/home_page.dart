import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:larid/core/l10n/app_localizations.dart';
import 'package:larid/core/theme/app_theme.dart';
import 'package:larid/core/di/service_locator.dart';
import 'package:larid/features/map/presentation/pages/map_page.dart';
import 'package:larid/features/summary/presentation/pages/summary_page.dart';
import 'package:larid/features/summary/presentation/bloc/summary_bloc.dart';
import 'package:larid/features/summary/presentation/bloc/summary_event.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  AnimationController? _animationController;
  List<Animation<double>> _animations = [];
  final SummaryBloc _summaryBloc = getIt<SummaryBloc>();

  // Pages to be shown in the bottom navigation - preload and keep them alive
  late final List<Widget> _pages = [
    // Wrap pages with widgets to maintain their state
    const KeepAlivePage(child: MapPage()),
    // Provide the SummaryBloc to the SummaryPage
    BlocProvider.value(value: _summaryBloc, child: const SummaryPage()),
  ];

  @override
  void initState() {
    super.initState();
    // Configure system UI overlay styling
    _configureSystemUIOverlay();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _animations = List.generate(
      2,
      (index) => Tween<double>(begin: 1.0, end: 1.2).animate(
        CurvedAnimation(
          parent: _animationController!,
          curve: Interval(
            index * 0.5,
            0.5 + index * 0.5,
            curve: Curves.easeOutBack,
          ),
        ),
      ),
    );

    _animationController!.forward();
  }

  void _configureSystemUIOverlay() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light, // iOS settings
        systemNavigationBarColor:
            Colors.transparent, // Transparent for edge-to-edge
        systemNavigationBarIconBrightness: Brightness.light,
        systemNavigationBarDividerColor: Colors.transparent,
      ),
    );

    // Enable edge-to-edge mode
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
      overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
    );
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;

    setState(() {
      _selectedIndex = index;
    });

    if (_animationController != null) {
      _animationController!.reset();
      _animationController!.forward();
    }

    // Refresh data when Summary tab is selected
    if (index == 1) {
      // Summary page index
      // Directly refresh using the bloc
      debugPrint('Tab changed to Summary - refreshing data directly via bloc');
      _summaryBloc.add(const LoadSummaryData());
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final bottomInset = MediaQuery.of(context).viewPadding.bottom;

    return Scaffold(
      // Use IndexedStack to keep all pages alive and maintain their state
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: Container(
        height: 65.0 + (bottomInset > 0 ? bottomInset : 0.0),
        decoration: BoxDecoration(
          color: AppColors.primary,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.only(bottom: bottomInset),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(
                context,
                0,
                Icons.map_outlined,
                Icons.map,
                localizations.map,
                _animations.isNotEmpty ? _animations[0] : null,
              ),
              _buildNavItem(
                context,
                1,
                Icons.insert_chart_outlined,
                Icons.insert_chart,
                localizations.summary,
                _animations.length > 1 ? _animations[1] : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    int index,
    IconData inactiveIcon,
    IconData activeIcon,
    String label,
    Animation<double>? animation,
  ) {
    final isSelected = _selectedIndex == index;
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: screenWidth / 2,
        height: 60,
        alignment: Alignment.center,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.symmetric(
            horizontal: isSelected ? 16.0 : 0.0,
            vertical: 8.0,
          ),
          decoration: BoxDecoration(
            color:
                isSelected ? Colors.white.withOpacity(0.2) : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon with animation
              _buildAnimatedIcon(
                isSelected,
                activeIcon,
                inactiveIcon,
                animation,
              ),

              // Text appears only for selected tab with animation
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: isSelected ? null : 0,
                curve: Curves.easeOut,
                child: AnimatedOpacity(
                  opacity: isSelected ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child:
                      isSelected
                          ? Padding(
                            padding: const EdgeInsets.only(
                              left: 8.0,
                              right: 4.0,
                            ),
                            child: Text(
                              label,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.clip,
                            ),
                          )
                          : const SizedBox.shrink(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedIcon(
    bool isSelected,
    IconData activeIcon,
    IconData inactiveIcon,
    Animation<double>? animation,
  ) {
    // Just use an Icon directly without a circle container
    Widget iconWidget = Icon(
      isSelected ? activeIcon : inactiveIcon,
      color: Colors.white,
      size: isSelected ? 24 : 22,
    );

    if (animation != null && isSelected) {
      return AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return Transform.scale(scale: animation.value, child: iconWidget);
        },
      );
    }

    return iconWidget;
  }
}

// Helper class to keep pages alive when switching tabs
class KeepAlivePage extends StatefulWidget {
  final Widget child;

  const KeepAlivePage({Key? key, required this.child}) : super(key: key);

  @override
  State<KeepAlivePage> createState() => _KeepAlivePageState();
}

class _KeepAlivePageState extends State<KeepAlivePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    return widget.child;
  }
}
