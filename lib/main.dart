import 'dart:async';
import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'customer_home_screen.dart';
import 'farmer_dashboard_screen.dart';
import 'color_typography.dart';
import 'app_state.dart';
import 'connectivity_banner.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppState.bootstrap();
  runApp(const AgroTradeApp());
}

class AgroTradeApp extends StatefulWidget {
  const AgroTradeApp({super.key});

  @override
  State<AgroTradeApp> createState() => _AgroTradeAppState();
}

class _AgroTradeAppState extends State<AgroTradeApp> {
  Timer? _connectivityTimer;

  @override
  void initState() {
    super.initState();
    _connectivityTimer = Timer.periodic(
      const Duration(seconds: 10),
      (_) => AppState.instance.refreshConnectivity(),
    );
  }

  @override
  void dispose() {
    _connectivityTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgroTrade',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
      home: const _RootRouter(),
    );
  }

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
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.brand700,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: AppRadii.mdR),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.brand700,
          side: const BorderSide(color: AppColors.brand700),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(borderRadius: AppRadii.mdR),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: AppColors.brand700),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
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
        hintStyle: const TextStyle(color: AppColors.slate400, fontSize: 13),
      ),
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
      dividerTheme: const DividerThemeData(
        color: AppColors.slate200,
        thickness: 1,
        space: 16,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.brand700,
        contentTextStyle: const TextStyle(color: Colors.white, fontSize: 13),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.mdR),
        actionTextColor: AppColors.brand200,
      ),
    );
  }
}

/// Routes based on current auth state.
class _RootRouter extends StatefulWidget {
  const _RootRouter();

  @override
  State<_RootRouter> createState() => _RootRouterState();
}

class _RootRouterState extends State<_RootRouter> {
  @override
  void initState() {
    super.initState();
    AppState.instance.addListener(_onAppStateChanged);
  }

  @override
  void dispose() {
    AppState.instance.removeListener(_onAppStateChanged);
    super.dispose();
  }

  void _onAppStateChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final s = AppState.instance;
    Widget home;
    
    if (!s.isLoggedIn) {
      home = const SplashScreen();
    } else if (s.currentUser!.role == 'farmer') {
      home = const FarmerDashboardScreen();
    } else {
      home = const CustomerHomeScreen();
    }

    return ConnectivityBanner(child: home);
  }
}