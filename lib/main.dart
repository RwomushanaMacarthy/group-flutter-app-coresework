import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'auth_screen.dart';
import 'customer_home_screen.dart';
import 'farmer_dashboard_screen.dart';
import 'orders_screen.dart';
import 'color_typography.dart';

void main() {
  runApp(const AgroTradeApp());
}

class AgroTradeApp extends StatelessWidget {
  const AgroTradeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgroTrade',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
      home: const SplashScreen(),
    );
  }

  // ─── Theme ──────────────────────────────────────────────────────
  ThemeData _buildTheme() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.brand700,
      primary: AppColors.brand700,
      onPrimary: Colors.white,
      secondary: AppColors.brand500,
      onSecondary: Colors.white,
      surface: Colors.white,
      onSurface: AppColors.slate900,
      error: AppColors.statusRejectedText,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.surfaceScaffoldOld,
      fontFamily: 'Roboto',

      // ─── AppBar ────────────────────────────────────────────────
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.slate900,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.slate900,
        ),
        iconTheme: IconThemeData(color: AppColors.slate900),
      ),

      // ─── Elevated Buttons ──────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.brand700,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadii.mdR,
          ),
          textStyle: AppTypography.buttonSmall.copyWith(color: Colors.white),
        ),
      ),

      // ─── Outlined Buttons ──────────────────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.brand700,
          side: const BorderSide(color: AppColors.brand700),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadii.mdR,
          ),
        ),
      ),

      // ─── Text Buttons ──────────────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.brand700,
          textStyle: AppTypography.buttonSmall,
        ),
      ),

      // ─── Input Fields ──────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: AppRadii.mdR,
          borderSide: const BorderSide(color: AppColors.slate200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadii.mdR,
          borderSide: const BorderSide(color: AppColors.slate200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadii.mdR,
          borderSide: const BorderSide(color: AppColors.brand600, width: 2),
        ),
        hintStyle: const TextStyle(
          color: AppColors.slate400,
          fontSize: 13,
        ),
      ),

      // ─── Checkbox ──────────────────────────────────────────────
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.brand700;
          }
          return Colors.white;
        }),
        checkColor: WidgetStateProperty.all(Colors.white),
        side: const BorderSide(color: AppColors.slate300, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),

      // ─── Divider ───────────────────────────────────────────────
      dividerTheme: const DividerThemeData(
        color: AppColors.slate200,
        thickness: 1,
        space: 16,
      ),

      // ─── SnackBar ──────────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.brand700,
        contentTextStyle: const TextStyle(color: Colors.white, fontSize: 13),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.mdR),
        actionTextColor: AppColors.brand200,
      ),

      // ─── Bottom Navigation (Material, kept for legacy fallback) ─
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.brand700,
        unselectedItemColor: AppColors.slate500,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),

      // ─── Progress Indicator ────────────────────────────────────
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.brand700,
      ),

      // ─── Text Selection ────────────────────────────────────────
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: AppColors.brand700,
        selectionColor: AppColors.brand200,
        selectionHandleColor: AppColors.brand700,
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  DEV-ONLY: Main Screen Switcher (for previewing all screens)
// ═══════════════════════════════════════════════════════════════════
/// To use: change `home: const SplashScreen()` above to
/// `home: const MainScreenSwitcher()`.
class MainScreenSwitcher extends StatefulWidget {
  const MainScreenSwitcher({super.key});

  @override
  State<MainScreenSwitcher> createState() => _MainScreenSwitcherState();
}

class _MainScreenSwitcherState extends State<MainScreenSwitcher> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    SplashScreen(),
    AuthScreen(),
    CustomerHomeScreen(),
    FarmerDashboardScreen(),
    OrdersScreen(),
  ];

  final List<String> _screenTitles = const [
    "Splash Screen",
    "Auth (Login/Register)",
    "Customer Home",
    "Farmer Dashboard",
    "Orders",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.brand800,
        foregroundColor: Colors.white,
        title: Text(
          "Preview: ${_screenTitles[_currentIndex]}",
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          PopupMenuButton<int>(
            icon: const Icon(Icons.screen_share, color: Colors.white),
            onSelected: (int index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context) => List.generate(
              _screens.length,
              (index) => PopupMenuItem(
                value: index,
                child: Text(_screenTitles[index]),
              ),
            ),
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
    );
  }
}