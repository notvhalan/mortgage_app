import 'package:flutter/material.dart';

/// Modern financial app theme using Material 3 design system
class AppTheme {
  // ============================================
  // COLOUR PALETTE
  // ============================================

  // Primary Brand Colors
  static const Color primaryBlue = Color(0xFF0D9488);
  static const Color primaryBlueDark = Color(0xFF0F766E);
  static const Color primaryBlueLight = Color(0xFF14B8A6);

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
  static const Color chartPrimary = Color(0xFF0D9488);
  static const Color chartSecondary = Color(0xFF8B5CF6);
  static const Color chartTertiary = Color(0xFF06B6D4);
  static const Color chartQuaternary = Color(0xFFF59E0B);
  static const Color chartGreen = Color(0xFF10B981);
  static const Color chartRed = Color(0xFFEF4444);
  static const Color chartOrange = Color(0xFFF97316);

  // Graph color aliases (for backward compatibility)
  static const Color graphPrincipal = chartPrimary;
  static const Color graphInterest = chartSecondary;

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
  static const double space1 = 4.0; // 4px
  static const double space2 = 8.0; // 8px
  static const double space3 = 12.0; // 12px
  static const double space4 = 16.0; // 16px
  static const double space5 = 20.0; // 20px
  static const double space6 = 24.0; // 24px
  static const double space8 = 32.0; // 32px
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
  // THEME ALIASES (for Material 3 theme definitions)
  // ============================================

  // Color aliases
  static const Color primaryLight = primaryBlueLight;
  static const Color primaryDark = primaryBlueDark;
  static const Color accentGreen = success;
  static const Color accentGreenLight = successLight;
  static const Color accentGreenDark = successDark;
  static const Color accentOrange = chartOrange;
  static const Color accentOrangeLight = warningLight;
  static const Color accentOrangeDark = warningDark;
  static const Color errorRed = error;
  static const Color errorRedLight = errorLight;
  static const Color errorRedDark = errorDark;
  static const Color shadowLight = overlayLight;
  static const Color shadowDark = overlayHeavy;
  static const Color cardWhite = backgroundWhite;
  static const Color borderLightSubtle = Color(0xFFF3F4F6);
  static const Color borderDarkSubtle = Color(0xFF374151);

  // Spacing aliases
  static const double spacingXSmall = spacingXs;
  static const double spacingSmall = spacingSm;
  static const double spacingMedium = spacingMd;
  static const double spacingLarge = spacingLg;

  // Radius aliases
  static const double radiusSmall = radiusSm;
  static const double radiusMedium = radiusMd;
  static const double radiusLarge = radiusLg;

  // Elevation aliases
  static const double elevation0 = elevationNone;
  static const double elevation1 = elevationXs;
  static const double elevation2 = elevationSm;
  static const double elevation3 = elevationMd;

  // Typography aliases
  static const double fontSizeCaption = fontSizeXs;
  static const double fontSizeSmall = fontSizeSm;
  static const double fontSizeBody = fontSizeBase;
  static const double fontSizeH4 = fontSizeLg;
  static const double fontSizeH3 = fontSizeXl;
  static const double fontSizeH2 = fontSize2xl;
  static const double fontSizeH1 = fontSize3xl;
  static const double fontSizeDisplay3 = fontSize3xl;
  static const double fontSizeDisplay2 = fontSize4xl;
  static const double fontSizeDisplay1 = fontSize5xl;

  // Line height aliases
  static const double lineHeightSnug = lineHeightTight;

  // ============================================
  // HELPER METHODS
  // ============================================

  /// Returns color based on Loan-to-Value ratio risk
  static Color getLTVColor(double ltv) {
    if (ltv < 60) return riskLow;
    if (ltv < 80) return riskMedium;
    if (ltv < 90) return riskHigh;
    return riskVeryHigh;
  }

  /// Returns risk label for Loan-to-Value ratio
  static String getLTVRiskLabel(double ltv) {
    if (ltv < 60) return 'Low Risk';
    if (ltv < 80) return 'Medium Risk';
    if (ltv < 90) return 'High Risk';
    return 'Very High Risk';
  }

  /// Returns appropriate text color for given background
  static Color getTextColorForBackground(Color background) {
    return background.computeLuminance() > 0.5 ? textPrimary : Colors.white;
  }

  // ============================================
  // LIGHT THEME
  // ============================================

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    // Color Scheme
    colorScheme: ColorScheme.light(
      primary: primaryBlue,
      onPrimary: Colors.white,
      primaryContainer: primaryLight,
      onPrimaryContainer: primaryDark,
      secondary: accentGreen,
      onSecondary: Colors.white,
      secondaryContainer: accentGreenLight,
      onSecondaryContainer: accentGreenDark,
      tertiary: accentPurple,
      onTertiary: Colors.white,
      error: errorRed,
      onError: Colors.white,
      errorContainer: errorRedLight,
      onErrorContainer: errorRedDark,
      surface: surfaceLight,
      onSurface: textPrimary,
      surfaceContainerHighest: surfaceLight,
      outline: borderLight,
      outlineVariant: borderLightSubtle,
      shadow: shadowLight,
    ),

    // Scaffold
    scaffoldBackgroundColor: backgroundGrey,

    // AppBar
    appBarTheme: AppBarTheme(
      backgroundColor: cardWhite,
      foregroundColor: textPrimary,
      surfaceTintColor: Colors.transparent,
      elevation: elevation0,
      centerTitle: true,
      titleTextStyle: const TextStyle(
        fontSize: fontSizeH2,
        fontWeight: fontWeightSemiBold,
        color: textPrimary,
        letterSpacing: -0.5,
      ),
      iconTheme: const IconThemeData(color: textPrimary, size: 24),
    ),

    // Card
    cardTheme: CardThemeData(
      color: cardWhite,
      elevation: elevation1,
      shadowColor: shadowLight,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusLarge),
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: spacingSmall,
        vertical: spacingXSmall,
      ),
    ),

    // Elevated Button
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        disabledBackgroundColor: surfaceLight,
        disabledForegroundColor: textTertiary,
        elevation: elevation1,
        shadowColor: shadowLight,
        padding: const EdgeInsets.symmetric(
          horizontal: spacingLarge,
          vertical: spacingMedium,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
        ),
        textStyle: const TextStyle(
          fontSize: fontSizeBody,
          fontWeight: fontWeightSemiBold,
          letterSpacing: 0.5,
        ),
      ),
    ),

    // Text Button
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryBlue,
        disabledForegroundColor: textTertiary,
        padding: const EdgeInsets.symmetric(
          horizontal: spacingMedium,
          vertical: spacingSmall,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusSmall),
        ),
        textStyle: const TextStyle(
          fontSize: fontSizeBody,
          fontWeight: fontWeightMedium,
          letterSpacing: 0.25,
        ),
      ),
    ),

    // Outlined Button
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryBlue,
        disabledForegroundColor: textTertiary,
        side: const BorderSide(color: borderLight, width: 1.5),
        padding: const EdgeInsets.symmetric(
          horizontal: spacingLarge,
          vertical: spacingMedium,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
        ),
        textStyle: const TextStyle(
          fontSize: fontSizeBody,
          fontWeight: fontWeightMedium,
          letterSpacing: 0.25,
        ),
      ),
    ),

    // Input Decoration
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceLight,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: spacingMedium,
        vertical: spacingMedium,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
        borderSide: const BorderSide(color: borderLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
        borderSide: const BorderSide(color: borderLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
        borderSide: const BorderSide(color: primaryBlue, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
        borderSide: const BorderSide(color: errorRed),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
        borderSide: const BorderSide(color: errorRed, width: 2),
      ),
      labelStyle: const TextStyle(
        fontSize: fontSizeBody,
        color: textSecondary,
        fontWeight: fontWeightRegular,
      ),
      hintStyle: const TextStyle(
        fontSize: fontSizeBody,
        color: textTertiary,
        fontWeight: fontWeightRegular,
      ),
      errorStyle: const TextStyle(
        fontSize: fontSizeCaption,
        color: errorRed,
        fontWeight: fontWeightRegular,
      ),
    ),

    // Chip
    chipTheme: ChipThemeData(
      backgroundColor: surfaceLight,
      selectedColor: primaryLight,
      disabledColor: surfaceLight,
      deleteIconColor: textSecondary,
      labelStyle: const TextStyle(
        fontSize: fontSizeSmall,
        color: textPrimary,
        fontWeight: fontWeightMedium,
      ),
      secondaryLabelStyle: const TextStyle(
        fontSize: fontSizeSmall,
        color: textSecondary,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: spacingSmall,
        vertical: spacingXSmall,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusSmall),
      ),
      side: const BorderSide(color: borderLight),
    ),

    // Dialog
    dialogTheme: DialogThemeData(
      backgroundColor: cardWhite,
      elevation: elevation3,
      shadowColor: shadowLight,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusLarge),
      ),
      titleTextStyle: const TextStyle(
        fontSize: fontSizeH3,
        fontWeight: fontWeightSemiBold,
        color: textPrimary,
        letterSpacing: -0.5,
      ),
      contentTextStyle: const TextStyle(
        fontSize: fontSizeBody,
        color: textSecondary,
        height: lineHeightRelaxed,
      ),
    ),

    // Bottom Navigation Bar
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: cardWhite,
      selectedItemColor: primaryBlue,
      unselectedItemColor: textTertiary,
      selectedIconTheme: const IconThemeData(size: 28, color: primaryBlue),
      unselectedIconTheme: const IconThemeData(size: 24, color: textTertiary),
      selectedLabelStyle: const TextStyle(
        fontSize: fontSizeCaption,
        fontWeight: fontWeightSemiBold,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: fontSizeCaption,
        fontWeight: fontWeightRegular,
      ),
      type: BottomNavigationBarType.fixed,
      elevation: elevation2,
    ),

    // Slider
    sliderTheme: SliderThemeData(
      activeTrackColor: const Color(0xFF3FC7D6),
      inactiveTrackColor: borderLight,
      thumbColor: Colors.white,
      overlayColor: const Color(0xFF67D3C8).withValues(alpha: 0.18),
      valueIndicatorColor: const Color(0xFF3FC7D6),
      valueIndicatorTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: fontSizeSmall,
        fontWeight: fontWeightMedium,
      ),
      trackHeight: 2,
      trackShape: const GradientSliderTrackShape(),
      thumbShape: const RoundSliderThumbShape(
        enabledThumbRadius: 8,
        elevation: 3,
      ),
      overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
    ),

    // Divider
    dividerTheme: const DividerThemeData(
      color: borderLight,
      thickness: 1,
      space: spacingMedium,
    ),

    // Text Theme
    textTheme: const TextTheme(
      // Display styles
      displayLarge: TextStyle(
        fontSize: fontSizeDisplay1,
        fontWeight: fontWeightBold,
        color: textPrimary,
        height: lineHeightTight,
        letterSpacing: -1.5,
      ),
      displayMedium: TextStyle(
        fontSize: fontSizeDisplay2,
        fontWeight: fontWeightBold,
        color: textPrimary,
        height: lineHeightTight,
        letterSpacing: -1,
      ),
      displaySmall: TextStyle(
        fontSize: fontSizeDisplay3,
        fontWeight: fontWeightSemiBold,
        color: textPrimary,
        height: lineHeightTight,
        letterSpacing: -0.5,
      ),

      // Headline styles
      headlineLarge: TextStyle(
        fontSize: fontSizeH1,
        fontWeight: fontWeightBold,
        color: textPrimary,
        height: lineHeightSnug,
        letterSpacing: -0.5,
      ),
      headlineMedium: TextStyle(
        fontSize: fontSizeH2,
        fontWeight: fontWeightSemiBold,
        color: textPrimary,
        height: lineHeightSnug,
        letterSpacing: -0.25,
      ),
      headlineSmall: TextStyle(
        fontSize: fontSizeH3,
        fontWeight: fontWeightSemiBold,
        color: textPrimary,
        height: lineHeightNormal,
      ),

      // Title styles
      titleLarge: TextStyle(
        fontSize: fontSizeH4,
        fontWeight: fontWeightMedium,
        color: textPrimary,
        height: lineHeightNormal,
      ),
      titleMedium: TextStyle(
        fontSize: fontSizeBody,
        fontWeight: fontWeightMedium,
        color: textPrimary,
        height: lineHeightNormal,
        letterSpacing: 0.15,
      ),
      titleSmall: TextStyle(
        fontSize: fontSizeSmall,
        fontWeight: fontWeightMedium,
        color: textPrimary,
        height: lineHeightNormal,
        letterSpacing: 0.1,
      ),

      // Body styles
      bodyLarge: TextStyle(
        fontSize: fontSizeBody,
        fontWeight: fontWeightRegular,
        color: textPrimary,
        height: lineHeightRelaxed,
        letterSpacing: 0.15,
      ),
      bodyMedium: TextStyle(
        fontSize: fontSizeSmall,
        fontWeight: fontWeightRegular,
        color: textSecondary,
        height: lineHeightRelaxed,
        letterSpacing: 0.25,
      ),
      bodySmall: TextStyle(
        fontSize: fontSizeCaption,
        fontWeight: fontWeightRegular,
        color: textSecondary,
        height: lineHeightNormal,
        letterSpacing: 0.4,
      ),

      // Label styles
      labelLarge: TextStyle(
        fontSize: fontSizeSmall,
        fontWeight: fontWeightMedium,
        color: textPrimary,
        letterSpacing: 0.5,
      ),
      labelMedium: TextStyle(
        fontSize: fontSizeCaption,
        fontWeight: fontWeightMedium,
        color: textSecondary,
        letterSpacing: 0.5,
      ),
      labelSmall: TextStyle(
        fontSize: fontSizeCaption,
        fontWeight: fontWeightRegular,
        color: textTertiary,
        letterSpacing: 0.5,
      ),
    ),

    // Icon Theme
    iconTheme: const IconThemeData(color: textPrimary, size: 24),
  );

  // ============================================
  // DARK THEME
  // ============================================

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    // Color Scheme
    colorScheme: ColorScheme.dark(
      primary: primaryBlue,
      onPrimary: Colors.white,
      primaryContainer: primaryDark,
      onPrimaryContainer: primaryLight,
      secondary: accentGreen,
      onSecondary: Colors.black,
      secondaryContainer: accentGreenDark,
      onSecondaryContainer: accentGreenLight,
      tertiary: accentPurple,
      onTertiary: Colors.black,
      error: errorRed,
      onError: Colors.white,
      errorContainer: errorRedDark,
      onErrorContainer: errorRedLight,
      surface: surfaceDark,
      onSurface: Colors.white,
      surfaceContainerHighest: surfaceDarkElevated,
      outline: borderDark,
      outlineVariant: borderDarkSubtle,
      shadow: shadowDark,
    ),

    // Scaffold
    scaffoldBackgroundColor: const Color(0xFF121212),

    // AppBar
    appBarTheme: AppBarTheme(
      backgroundColor: surfaceDark,
      foregroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: elevation0,
      centerTitle: true,
      titleTextStyle: const TextStyle(
        fontSize: fontSizeH2,
        fontWeight: fontWeightSemiBold,
        color: Colors.white,
        letterSpacing: -0.5,
      ),
      iconTheme: const IconThemeData(color: Colors.white, size: 24),
    ),

    // Card
    cardTheme: CardThemeData(
      color: surfaceDark,
      elevation: elevation1,
      shadowColor: shadowDark,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusLarge),
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: spacingSmall,
        vertical: spacingXSmall,
      ),
    ),

    // Elevated Button
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        disabledBackgroundColor: surfaceDarkElevated,
        disabledForegroundColor: textTertiary,
        elevation: elevation1,
        shadowColor: shadowDark,
        padding: const EdgeInsets.symmetric(
          horizontal: spacingLarge,
          vertical: spacingMedium,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
        ),
        textStyle: const TextStyle(
          fontSize: fontSizeBody,
          fontWeight: fontWeightSemiBold,
          letterSpacing: 0.5,
        ),
      ),
    ),

    // Text Button
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryLight,
        disabledForegroundColor: textTertiary,
        padding: const EdgeInsets.symmetric(
          horizontal: spacingMedium,
          vertical: spacingSmall,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusSmall),
        ),
        textStyle: const TextStyle(
          fontSize: fontSizeBody,
          fontWeight: fontWeightMedium,
          letterSpacing: 0.25,
        ),
      ),
    ),

    // Outlined Button
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryLight,
        disabledForegroundColor: textTertiary,
        side: const BorderSide(color: borderDark, width: 1.5),
        padding: const EdgeInsets.symmetric(
          horizontal: spacingLarge,
          vertical: spacingMedium,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
        ),
        textStyle: const TextStyle(
          fontSize: fontSizeBody,
          fontWeight: fontWeightMedium,
          letterSpacing: 0.25,
        ),
      ),
    ),

    // Input Decoration
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceDarkElevated,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: spacingMedium,
        vertical: spacingMedium,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
        borderSide: const BorderSide(color: borderDark),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
        borderSide: const BorderSide(color: borderDark),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
        borderSide: const BorderSide(color: primaryBlue, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
        borderSide: const BorderSide(color: errorRed),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
        borderSide: const BorderSide(color: errorRed, width: 2),
      ),
      labelStyle: const TextStyle(
        fontSize: fontSizeBody,
        color: Color(0xFFB0B0B0),
        fontWeight: fontWeightRegular,
      ),
      hintStyle: const TextStyle(
        fontSize: fontSizeBody,
        color: textTertiary,
        fontWeight: fontWeightRegular,
      ),
      errorStyle: const TextStyle(
        fontSize: fontSizeCaption,
        color: errorRed,
        fontWeight: fontWeightRegular,
      ),
    ),

    // Chip
    chipTheme: ChipThemeData(
      backgroundColor: surfaceDarkElevated,
      selectedColor: primaryDark,
      disabledColor: surfaceDarkElevated,
      deleteIconColor: Color(0xFFB0B0B0),
      labelStyle: const TextStyle(
        fontSize: fontSizeSmall,
        color: Colors.white,
        fontWeight: fontWeightMedium,
      ),
      secondaryLabelStyle: const TextStyle(
        fontSize: fontSizeSmall,
        color: Color(0xFFB0B0B0),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: spacingSmall,
        vertical: spacingXSmall,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusSmall),
      ),
      side: const BorderSide(color: borderDark),
    ),

    // Dialog
    dialogTheme: DialogThemeData(
      backgroundColor: surfaceDark,
      elevation: elevation3,
      shadowColor: shadowDark,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusLarge),
      ),
      titleTextStyle: const TextStyle(
        fontSize: fontSizeH3,
        fontWeight: fontWeightSemiBold,
        color: Colors.white,
        letterSpacing: -0.5,
      ),
      contentTextStyle: const TextStyle(
        fontSize: fontSizeBody,
        color: Color(0xFFB0B0B0),
        height: lineHeightRelaxed,
      ),
    ),

    // Bottom Navigation Bar
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: surfaceDark,
      selectedItemColor: primaryLight,
      unselectedItemColor: textTertiary,
      selectedIconTheme: const IconThemeData(size: 28, color: primaryLight),
      unselectedIconTheme: const IconThemeData(size: 24, color: textTertiary),
      selectedLabelStyle: const TextStyle(
        fontSize: fontSizeCaption,
        fontWeight: fontWeightSemiBold,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: fontSizeCaption,
        fontWeight: fontWeightRegular,
      ),
      type: BottomNavigationBarType.fixed,
      elevation: elevation2,
    ),

    // Slider
    sliderTheme: SliderThemeData(
      activeTrackColor: const Color(0xFF3FC7D6),
      inactiveTrackColor: borderDark,
      thumbColor: Colors.white,
      overlayColor: const Color(0xFF67D3C8).withValues(alpha: 0.18),
      valueIndicatorColor: const Color(0xFF3FC7D6),
      valueIndicatorTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: fontSizeSmall,
        fontWeight: fontWeightMedium,
      ),
      trackHeight: 2,
      trackShape: const GradientSliderTrackShape(),
      thumbShape: const RoundSliderThumbShape(
        enabledThumbRadius: 8,
        elevation: 3,
      ),
      overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
    ),

    // Divider
    dividerTheme: const DividerThemeData(
      color: borderDark,
      thickness: 1,
      space: spacingMedium,
    ),

    // Text Theme
    textTheme: const TextTheme(
      // Display styles
      displayLarge: TextStyle(
        fontSize: fontSizeDisplay1,
        fontWeight: fontWeightBold,
        color: Colors.white,
        height: lineHeightTight,
        letterSpacing: -1.5,
      ),
      displayMedium: TextStyle(
        fontSize: fontSizeDisplay2,
        fontWeight: fontWeightBold,
        color: Colors.white,
        height: lineHeightTight,
        letterSpacing: -1,
      ),
      displaySmall: TextStyle(
        fontSize: fontSizeDisplay3,
        fontWeight: fontWeightSemiBold,
        color: Colors.white,
        height: lineHeightTight,
        letterSpacing: -0.5,
      ),

      // Headline styles
      headlineLarge: TextStyle(
        fontSize: fontSizeH1,
        fontWeight: fontWeightBold,
        color: Colors.white,
        height: lineHeightSnug,
        letterSpacing: -0.5,
      ),
      headlineMedium: TextStyle(
        fontSize: fontSizeH2,
        fontWeight: fontWeightSemiBold,
        color: Colors.white,
        height: lineHeightSnug,
        letterSpacing: -0.25,
      ),
      headlineSmall: TextStyle(
        fontSize: fontSizeH3,
        fontWeight: fontWeightSemiBold,
        color: Colors.white,
        height: lineHeightNormal,
      ),

      // Title styles
      titleLarge: TextStyle(
        fontSize: fontSizeH4,
        fontWeight: fontWeightMedium,
        color: Colors.white,
        height: lineHeightNormal,
      ),
      titleMedium: TextStyle(
        fontSize: fontSizeBody,
        fontWeight: fontWeightMedium,
        color: Colors.white,
        height: lineHeightNormal,
        letterSpacing: 0.15,
      ),
      titleSmall: TextStyle(
        fontSize: fontSizeSmall,
        fontWeight: fontWeightMedium,
        color: Colors.white,
        height: lineHeightNormal,
        letterSpacing: 0.1,
      ),

      // Body styles
      bodyLarge: TextStyle(
        fontSize: fontSizeBody,
        fontWeight: fontWeightRegular,
        color: Colors.white,
        height: lineHeightRelaxed,
        letterSpacing: 0.15,
      ),
      bodyMedium: TextStyle(
        fontSize: fontSizeSmall,
        fontWeight: fontWeightRegular,
        color: Color(0xFFB0B0B0),
        height: lineHeightRelaxed,
        letterSpacing: 0.25,
      ),
      bodySmall: TextStyle(
        fontSize: fontSizeCaption,
        fontWeight: fontWeightRegular,
        color: Color(0xFFB0B0B0),
        height: lineHeightNormal,
        letterSpacing: 0.4,
      ),

      // Label styles
      labelLarge: TextStyle(
        fontSize: fontSizeSmall,
        fontWeight: fontWeightMedium,
        color: Colors.white,
        letterSpacing: 0.5,
      ),
      labelMedium: TextStyle(
        fontSize: fontSizeCaption,
        fontWeight: fontWeightMedium,
        color: Color(0xFFB0B0B0),
        letterSpacing: 0.5,
      ),
      labelSmall: TextStyle(
        fontSize: fontSizeCaption,
        fontWeight: fontWeightRegular,
        color: textTertiary,
        letterSpacing: 0.5,
      ),
    ),

    // Icon Theme
    iconTheme: const IconThemeData(color: Colors.white, size: 24),
  );
}

// ============================================================
// GRADIENT SLIDER TRACK
// ============================================================

/// Apple-style teal gradient applied to the active portion of every Slider.
const LinearGradient sliderGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFF9FE6DE), Color(0xFF67D3C8), Color(0xFF3FC7D6)],
);

/// Custom [SliderTrackShape] that paints the active track with [sliderGradient]
/// and the inactive track in the theme's [inactiveTrackColor].
class GradientSliderTrackShape extends SliderTrackShape
    with BaseSliderTrackShape {
  const GradientSliderTrackShape();

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isDiscrete = false,
    bool isEnabled = false,
  }) {
    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    final Radius radius = Radius.circular(trackRect.height / 2);

    // Full-width inactive background
    context.canvas.drawRRect(
      RRect.fromRectAndRadius(trackRect, radius),
      Paint()
        ..color = sliderTheme.inactiveTrackColor ?? const Color(0xFFE5E7EB),
    );

    // Active portion — gradient from left edge to thumb
    final double activeEnd = thumbCenter.dx.clamp(
      trackRect.left,
      trackRect.right,
    );
    if (activeEnd > trackRect.left) {
      context.canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTRB(
            trackRect.left,
            trackRect.top,
            activeEnd,
            trackRect.bottom,
          ),
          radius,
        ),
        Paint()..shader = sliderGradient.createShader(trackRect),
      );
    }
  }
}
