import 'dart:async';
import 'package:flutter/material.dart';
import 'auth_screen.dart';
import 'color_typography.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final PageController _pageController = PageController(viewportFraction: 1.0);
  int _currentPage = 0;
  late Timer _timer;

  final List<String> _images = [
    'assets/bana.png',
    'assets/toma.png',
    'assets/ono.png',
  ];

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!_pageController.hasClients) return;
      _currentPage = (_currentPage + 1) % _images.length;
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _goToAuth() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AuthScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.forest900,
      body: Stack(
        children: [
          // ─── 1. Full-screen hero carousel ───────────────────────
          Positioned.fill(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _images.length,
              onPageChanged: (i) => setState(() => _currentPage = i),
              itemBuilder: (context, index) {
                return Image.asset(
                  _images[index],
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Container(color: AppColors.forest800),
                );
              },
            ),
          ),

          // ─── 2. Atmospheric gradients ───────────────────────────
          // Top vignette
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.center,
                  colors: [
                    Colors.black.withOpacity(0.6),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // Bottom heavy gradient into forest background
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    AppColors.forest900,
                    AppColors.forest900.withOpacity(0.9),
                    AppColors.forest900.withOpacity(0.5),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.35, 0.6, 0.85],
                ),
              ),
            ),
          ),
          // Subtle edge vignette
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.2,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.35),
                  ],
                  stops: const [0.55, 1.0],
                ),
              ),
            ),
          ),

          // ─── 3. Content ─────────────────────────────────────────
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                const Spacer(),
                _buildContent(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Header: Logo + Skip ────────────────────────────────────────
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // ─── Brand block (logo + name) ────────────────────────
          Row(
            children: [
              // Bare logo — no container, no box, no shadow
              SizedBox(
                width: 120,
                height: 120,
                child: Image.asset(
                  'assets/logo.png',
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.eco,
                    color: AppColors.mint400,
                    size: 56,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                ' ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.4,
                ),
              ),
            ],
          ), // ← closes brand Row

          // ─── Skip pill ────────────────────────────────────────
          _GlassPill(
            onTap: _goToAuth,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Skip',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.chevron_right,
                  size: 14,
                  color: Colors.white.withOpacity(0.7),
                ),
              ],
            ),
          ),
        ],
      ), // ← closes outer Row
    ); // ← closes Padding
  } // ← closes _buildHeader

  // ─── Bottom content ─────────────────────────────────────────────
  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Feature pills
          const Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _FeaturePill(label: 'Direct Farm Trade', showDot: true),
              _FeaturePill(label: 'Verified Quality'),
              _FeaturePill(label: 'Safe Products'),
            ],
          ),
          const SizedBox(height: 20),

          // Headline with gradient accent
          LayoutBuilder(
            builder: (context, constraints) {
              final shader = const LinearGradient(
                colors: [
                  AppColors.mint400,
                  AppColors.emerald200,
                ],
              ).createShader(
                Rect.fromLTWH(0, 0, constraints.maxWidth, 40),
              );

              return RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    height: 1.15,
                    letterSpacing: -0.8,
                    color: Colors.white,
                  ),
                  children: [
                    const TextSpan(text: 'Trade your groceries '),
                    TextSpan(
                      text: 'directly.',
                      style: TextStyle(
                        foreground: Paint()..shader = shader,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 12),

          // Subtitle
          Text(
            'A platform where you can buy and sell fresh produce at '
            'competitive prices. Connect with farmers, local grocers, '
            'and businesses seamlessly.',
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Colors.grey.shade300,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 20),

          // Step indicators
          Row(
            children: List.generate(_images.length, (i) {
              final active = i == _currentPage;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.only(right: 6),
                width: active ? 32 : 8,
                height: 6,
                decoration: BoxDecoration(
                  color: active
                      ? AppColors.mint400
                      : Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(3),
                  boxShadow: active
                      ? [
                          BoxShadow(
                            color: AppColors.mint400.withOpacity(0.5),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
              );
            }),
          ),
          const SizedBox(height: 24),

          // Primary CTA — gradient button
          GestureDetector(
            onTap: _goToAuth,
            child: Container(
              height: 56,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [
                    AppColors.emerald600,
                    AppColors.mint500,
                    AppColors.emerald600,
                  ],
                ),
                border: Border.all(
                  color: AppColors.emerald400.withOpacity(0.3),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.emerald600.withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Get Started',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Secondary CTA — glass button
          _GlassButton(
            onTap: () {},
            label: 'Explore Marketplace',
          ),

          const SizedBox(height: 10),

          // Footer note
          Center(
            child: Text(
              'trade with us today',
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 8),

          // iOS home indicator
          Center(
            child: Container(
              width: 128,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Reusable Glass Pill ─────────────────────────────────────────
class _GlassPill extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final VoidCallback? onTap;

  const _GlassPill({
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: Colors.white.withOpacity(0.18)),
        ),
        child: child,
      ),
    );
  }
}

// ─── Feature Pill (emerald text) ─────────────────────────────────
class _FeaturePill extends StatelessWidget {
  final String label;
  final bool showDot;

  const _FeaturePill({required this.label, this.showDot = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withOpacity(0.18)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDot) ...[
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: AppColors.emerald400,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.emerald200,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Glass Button ────────────────────────────────────────────────
class _GlassButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _GlassButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.22)),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}