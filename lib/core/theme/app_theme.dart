import 'package:flutter/material.dart';

/// Modern financial app theme using Material 3 design system
class AppTheme {
  // ============================================
  // COLOUR PALETTE
  // ============================================
  
  // Primary Brand Colors
  static const Color primaryBlue = Color(0xFF2E5BFF);
  static const Color primaryBlueDark = Color(0xFF1E3FCC);
  static const Color primaryBlueLight = Color(0xFF5C7FFF);
  
  // Accent Colors
  static const Color accentPurple = Color(0xFF8B5CF6);
  static const Color accentTeal = Color(0xFF06B6D4);
  static const Color accentIndigo = Color(0xFF6366F1);
  
  // Background Colors
  static const Color backgroundLight = Color(0xFFF7F8FA);
  static const Color backgroundWhite = Color(0xFFFFFFFF);
  static const Color backgroundGrey = Color(0xFFF5F5F5);
  static const Color surfaceLight = Color(0xFFFAFAFA);
  
  // Dark Mode Backgrounds
  static const Color backgroundDark = Color(0xFF0F0F0F);
  static const Color surfaceDark = Color(0xFF1A1A1A);
  static const Color surfaceDarkElevated = Color(0xFF242424);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF0A0A0A);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color textDisabled = Color(0xFFD1D5DB);
  
  // Dark Mode Text
  static const Color textPrimaryDark = Color(0xFFFAFAFA);
  static const Color textSecondaryDark = Color(0xFFD1D5DB);
  static const Color textTertiaryDark = Color(0xFF9CA3AF);
  
  // Semantic Colors
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFF34D399);
  static const Color successDark = Color(0xFF059669);
  
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFF87171);
  static const Color errorDark = Color(0xFFDC2626);
  
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFBBF24);
  static const Color warningDark = Color(0xFFD97706);
  
  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFF60A5FA);
  static const Color infoDark = Color(0xFF2563EB);
  
  // Financial Risk Colors (LTV Indicators)
  static const Color riskLow = Color(0xFF10B981);
  static const Color riskMedium = Color(0xFF3B82F6);
  static const Color riskHigh = Color(0xFFF97316);
  static const Color riskVeryHigh = Color(0xFFEF4444);
  
  // Chart & Graph Colors
  static const Color chartPrimary = Color(0xFF2E5BFF);
  static const Color chartSecondary = Color(0xFF8B5CF6);
  static const Color chartTertiary = Color(0xFF06B6D4);
  static const Color chartQuaternary = Color(0xFFF59E0B);
  static const Color chartGreen = Color(0xFF10B981);
  static const Color chartRed = Color(0xFFEF4444);
  static const Color chartOrange = Color(0xFFF97316);
  
  // Border Colors
  static const Color borderLight = Color(0xFFE5E7EB);
  static const Color borderMedium = Color(0xFFD1D5DB);
  static const Color borderDark = Color(0xFF9CA3AF);
  
  // Overlay Colors
  static const Color overlayLight = Color(0x0A000000);
  static const Color overlayMedium = Color(0x1F000000);
  static const Color overlayHeavy = Color(0x3D000000);
  
  // ============================================
  // SPACING SYSTEM
  // ============================================
  
  // Base spacing unit: 4px
  static const double space1 = 4.0;   // 4px
  static const double space2 = 8.0;   // 8px
  static const double space3 = 12.0;  // 12px
  static const double space4 = 16.0;  // 16px
  static const double space5 = 20.0;  // 20px
  static const double space6 = 24.0;  // 24px
  static const double space8 = 32.0;  // 32px
  static const double space10 = 40.0; // 40px
  static const double space12 = 48.0; // 48px
  static const double space16 = 64.0; // 64px
  
  // Semantic spacing
  static const double spacingXs = space1;
  static const double spacingSm = space2;
  static const double spacingMd = space4;
  static const double spacingLg = space6;
  static const double spacingXl = space8;
  static const double spacing2xl = space12;
  
  // Component-specific spacing
  static const double cardPadding = space4;
  static const double cardPaddingLg = space6;
  static const double sectionSpacing = space6;
  static const double listItemSpacing = space3;
  static const double buttonPadding = space4;
  
  // ============================================
  // BORDER RADIUS
  // ============================================
  
  static const double radiusXs = 4.0;
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 20.0;
  static const double radius2xl = 24.0;
  static const double radiusFull = 9999.0;
  
  // Component-specific radius
  static const double cardRadius = radiusLg;
  static const double buttonRadius = radiusMd;
  static const double inputRadius = radiusMd;
  static const double chipRadius = radiusFull;
  static const double dialogRadius = radiusXl;
  
  // ============================================
  // ELEVATION & SHADOWS
  // ============================================
  
  static const double elevationNone = 0.0;
  static const double elevationXs = 1.0;
  static const double elevationSm = 2.0;
  static const double elevationMd = 4.0;
  static const double elevationLg = 8.0;
  static const double elevationXl = 12.0;
  
  // ============================================
  // TYPOGRAPHY SCALE
  // ============================================
  
  // Font sizes
  static const double fontSizeXs = 12.0;
  static const double fontSizeSm = 14.0;
  static const double fontSizeBase = 16.0;
  static const double fontSizeLg = 18.0;
  static const double fontSizeXl = 20.0;
  static const double fontSize2xl = 24.0;
  static const double fontSize3xl = 30.0;
  static const double fontSize4xl = 36.0;
  static const double fontSize5xl = 48.0;
  
  // Line heights
  static const double lineHeightTight = 1.25;
  static const double lineHeightNormal = 1.5;
  static const double lineHeightRelaxed = 1.75;
  
  // Font weights
  static const FontWeight fontWeightRegular = FontWeight.w400;
  static const FontWeight fontWeightMedium = FontWeight.w500;
  static const FontWeight fontWeightSemiBold = FontWeight.w600;
  static const FontWeight fontWeightBold = FontWeight.w700;
  static const FontWeight fontWeightExtraBold = FontWeight.w800;
  
  // ============================================
  // HELPER METHODS
  // ============================================
    if (ltv < 60) return ltvLow;
    if (ltv < 80) return ltvMedium;
    if (ltv < 90) return ltvHigh;
    return ltvVeryHigh;
  }

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryBlue,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: backgroundGrey,
    cardTheme: CardThemeData(
      color: cardWhite,
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cardRadius),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: cardWhite,
      foregroundColor: textPrimary,
      elevation: 0,
      centerTitle: true,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 42,
        fontWeight: FontWeight.bold,
        color: textPrimary,
      ),
      displayMedium: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.bold,
        color: textPrimary,
      ),
      headlineMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      bodyLarge: TextStyle(fontSize: 16, color: textPrimary),
      bodyMedium: TextStyle(fontSize: 14, color: textSecondary),
      labelMedium: TextStyle(fontSize: 13, color: textSecondary),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryBlue,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: const Color(0xFF121212),
    cardTheme: CardThemeData(
      color: const Color(0xFF1E1E1E),
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cardRadius),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E),
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),
  );
}
