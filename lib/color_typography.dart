import 'package:flutter/material.dart';

// ═══════════════════════════════════════════════════════════════════
//  APP COLORS — Single source of truth for the whole app
// ═══════════════════════════════════════════════════════════════════
class AppColors {
  // ─────────────────────────────────────────────────────────────────
  //  BRAND GREEN (used in splash, auth, customer, farmer)
  // ─────────────────────────────────────────────────────────────────
  static const brand50  = Color(0xFFF0FDF4);
  static const brand100 = Color(0xFFDCFCE7);
  static const brand200 = Color(0xFFBBF7D0);
  static const brand300 = Color(0xFF86EFAC);
  static const brand400 = Color(0xFF4ADE80);
  static const brand500 = Color(0xFF22C55E);
  static const brand600 = Color(0xFF16A34A);
  static const brand700 = Color(0xFF15803D);
  static const brand800 = Color(0xFF166534);
  static const brand900 = Color(0xFF14532D);

  // Legacy aliases used by old screens (kept for backward compatibility)
  static const primaryGreen = brand700;      // was 0xFF008955
  static const secondaryGreen = Color(0xFF4CAF50);

  // ─────────────────────────────────────────────────────────────────
  //  FOREST DEEP (splash screen dark background)
  // ─────────────────────────────────────────────────────────────────
  static const forest900 = Color(0xFF071A12);
  static const forest800 = Color(0xFF0C2D20);
  static const forest700 = Color(0xFF144633);

  // ─────────────────────────────────────────────────────────────────
  //  MINT / EMERALD ACCENTS (splash + farmer highlights)
  // ─────────────────────────────────────────────────────────────────
  static const mint400    = Color(0xFF34D399);
  static const mint500    = Color(0xFF10B981);
  static const mint600    = Color(0xFF059669);
  static const emerald200 = Color(0xFFA7F3D0);
  static const emerald400 = Color(0xFF34D399);
  static const emerald600 = Color(0xFF059669);

  // ─────────────────────────────────────────────────────────────────
  //  STONE (warm grays — auth screen body)
  // ─────────────────────────────────────────────────────────────────
  static const stone50  = Color(0xFFFAFAF9);
  static const stone100 = Color(0xFFF5F5F4);
  static const stone200 = Color(0xFFE7E5E4);
  static const stone300 = Color(0xFFD6D3D1);
  static const stone400 = Color(0xFFA8A29E);
  static const stone500 = Color(0xFF78716C);
  static const stone600 = Color(0xFF57534E);
  static const stone700 = Color(0xFF44403C);
  static const stone800 = Color(0xFF292524);
  static const stone900 = Color(0xFF1C1917);

  // ─────────────────────────────────────────────────────────────────
  //  SLATE (cool grays — customer home + farmer dashboard)
  // ─────────────────────────────────────────────────────────────────
  static const slate50  = Color(0xFFF8FAFC);
  static const slate100 = Color(0xFFF1F5F9);
  static const slate200 = Color(0xFFE2E8F0);
  static const slate300 = Color(0xFFCBD5E1);
  static const slate400 = Color(0xFF94A3B8);
  static const slate500 = Color(0xFF64748B);
  static const slate600 = Color(0xFF475569);
  static const slate700 = Color(0xFF334155);
  static const slate800 = Color(0xFF1E293B);
  static const slate900 = Color(0xFF0F172A);

  // ─────────────────────────────────────────────────────────────────
  //  AMBER (badges, farmer callout)
  // ─────────────────────────────────────────────────────────────────
  static const amber50  = Color(0xFFFFFBEB);
  static const amber100 = Color(0xFFFEF3C7);
  static const amber200 = Color(0xFFFDE68A);
  static const amber500 = Color(0xFFF59E0B);
  static const amber600 = Color(0xFFD97706);
  static const amber700 = Color(0xFFB45309);

  // ─────────────────────────────────────────────────────────────────
  //  STATUS / SEMANTIC COLORS (order status pills)
  // ─────────────────────────────────────────────────────────────────
  // Pending (orange)
  static const statusPendingBg   = Color(0xFFFFF7ED);
  static const statusPendingText = Color(0xFFC2410C);

  // Accepted (green)
  static const statusAcceptedBg   = brand50;
  static const statusAcceptedText = brand700;

  // Delivered (blue)
  static const statusDeliveredBg   = Color(0xFFEFF6FF);
  static const statusDeliveredText = Color(0xFF1D4ED8);

  // Rejected / error (rose)
  static const statusRejectedBg   = Color(0xFFFFE4E6);
  static const statusRejectedText = Color(0xFFE11D48);

  // ─────────────────────────────────────────────────────────────────
  //  FUNCTIONAL / UTILITY
  // ─────────────────────────────────────────────────────────────────
  static const textDark    = Color(0xFF333333);  // legacy
  static const textLight   = Color(0xFF757575);  // legacy
  static const backgroundWhite     = Colors.white;
  static const imagePlaceholder    = Color(0xFFE0E0E0);
  static const surfaceScaffold     = Color(0xFFFAFAFA);  // customer home
  static const surfaceScaffoldOld  = Color(0xFFF7F9F7);  // legacy main.dart

  // ─────────────────────────────────────────────────────────────────
  //  SOCIAL BRAND COLORS (auth screen)
  // ─────────────────────────────────────────────────────────────────
  static const googleBlue   = Color(0xFF4285F4);
  static const googleRed    = Color(0xFFEA4335);
  static const googleYellow = Color(0xFFFBBC05);
  static const googleGreen  = Color(0xFF34A853);
  static const facebookBlue = Color(0xFF1877F2);
  static const linkedinBlue = Color(0xFF0A66C2);

  // ─────────────────────────────────────────────────────────────────
  //  NOTIFICATION DOT
  // ─────────────────────────────────────────────────────────────────
  static const notificationDot = Color(0xFFF43F5E);

  // ─────────────────────────────────────────────────────────────────
  //  iOS HOME INDICATOR BAR
  // ─────────────────────────────────────────────────────────────────
  static const homeBarLight = stone300;   // auth
  static const homeBarDark  = slate300;   // customer
}

// ═══════════════════════════════════════════════════════════════════
//  APP TYPOGRAPHY
// ═══════════════════════════════════════════════════════════════════
class AppTypography {
  // ── Headlines ────────────────────────────────────────────────────
  static const TextStyle headline = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w800,
    color: AppColors.textDark,
    height: 1.2,
    letterSpacing: -0.5,
  );

  static const TextStyle displayLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    height: 1.15,
    letterSpacing: -0.8,
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
  );

  static const TextStyle displaySmall = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
  );

  // ── Section Titles ──────────────────────────────────────────────
  static const TextStyle sectionTitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.2,
  );

  static const TextStyle sectionSubtitle = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
  );

  // ── Body ────────────────────────────────────────────────────────
  static const TextStyle body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textLight,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  static const TextStyle bodyTiny = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 1.35,
  );

  // ── Labels ──────────────────────────────────────────────────────
  static const TextStyle label = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
  );

  static const TextStyle overline = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.2,
  );

  // ── Buttons ─────────────────────────────────────────────────────
  static const TextStyle buttonText = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryGreen,
  );

  static const TextStyle buttonLarge = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );

  static const TextStyle buttonSmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w700,
  );

  // ── Prices ──────────────────────────────────────────────────────
  static const TextStyle price = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w900,
    color: AppColors.brand700,
    letterSpacing: -0.2,
  );

  static const TextStyle priceLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w800,
    color: AppColors.brand700,
  );

  static const TextStyle priceUnit = TextStyle(
    fontSize: 9.5,
    fontWeight: FontWeight.w500,
    color: AppColors.slate600,
  );

  // ── Badges ──────────────────────────────────────────────────────
  static const TextStyle badge = TextStyle(
    fontSize: 9.5,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.3,
  );

  static const TextStyle badgeTiny = TextStyle(
    fontSize: 9,
    fontWeight: FontWeight.w700,
  );
}

// ═══════════════════════════════════════════════════════════════════
//  APP SHADOWS (reusable, since HTML uses many subtle drop shadows)
// ═══════════════════════════════════════════════════════════════════
class AppShadows {
  static List<BoxShadow> card = [
    BoxShadow(
      color: Colors.black.withOpacity(0.03),
      blurRadius: 6,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> elevated = [
    BoxShadow(
      color: Colors.black.withOpacity(0.04),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> brandGlow = [
    BoxShadow(
      color: AppColors.brand700.withOpacity(0.35),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> heroGlow = [
    BoxShadow(
      color: AppColors.brand900.withOpacity(0.18),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> darkGlow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.5),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> softSmall = [
    BoxShadow(
      color: Colors.black.withOpacity(0.02),
      blurRadius: 4,
      offset: const Offset(0, 1),
    ),
  ];
}

// ═══════════════════════════════════════════════════════════════════
//  APP RADII (reusable border radii)
// ═══════════════════════════════════════════════════════════════════
class AppRadii {
  static const double xs  = 6;
  static const double sm  = 10;
  static const double md  = 12;
  static const double lg  = 16;
  static const double xl  = 18;
  static const double xxl = 20;
  static const double pill = 999;

  static BorderRadius get xsR  => BorderRadius.circular(xs);
  static BorderRadius get smR  => BorderRadius.circular(sm);
  static BorderRadius get mdR  => BorderRadius.circular(md);
  static BorderRadius get lgR  => BorderRadius.circular(lg);
  static BorderRadius get xlR  => BorderRadius.circular(xl);
  static BorderRadius get xxlR => BorderRadius.circular(xxl);
  static BorderRadius get pillR => BorderRadius.circular(pill);
}