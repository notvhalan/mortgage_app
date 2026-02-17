# Development Guide

## Quick Start

### Run the app
```bash
flutter run
```

### Run tests
```bash
flutter test
```

### Build release
```bash
# Android
flutter build appbundle --release

# iOS
flutter build ios --release
```

---

## Project Structure

### Core Logic
- `lib/domain/services/mortgage_calculator.dart` - All calculation formulas
- `lib/domain/models/mortgage_calculation.dart` - Data models

### UI Components
- `lib/presentation/screens/calculator_screen.dart` - Main screen
- `lib/presentation/screens/settings_screen.dart` - Settings screen
- `lib/presentation/widgets/calculator_widgets.dart` - Input controls
- `lib/presentation/widgets/visualization_widgets.dart` - Graph & table

### Theme
- `lib/core/theme/app_theme.dart` - Colors, typography, spacing

---

## Key Features Implementation

### 1. Real-time Calculations
The calculator updates instantly as sliders move. No "Calculate" button needed.

```dart
void _calculate() {
  final deposit = propertyPrice * (depositPercentage / 100);
  
  setState(() {
    calculation = MortgageCalculator.calculate(
      propertyPrice: propertyPrice,
      deposit: deposit,
      interestRate: interestRate,
      termYears: termYears,
      region: region,
    );
  });
}
```

### 2. Stamp Duty
Correctly implements all UK regions:
- England/NI - SDLT with first-time buyer relief
- Scotland - LBTT
- Wales - LTT

### 3. LTV Color Coding
- < 60% = Green (low risk)
- 60-80% = Blue (medium)
- 80-90% = Orange (high)
- >90% = Red (very high)

### 4. Amortization Schedule
Generates complete payment schedule showing:
- Monthly breakdown
- Yearly summary
- Principal vs interest split
- Remaining balance

---

## Testing Strategy

### Unit Tests
Test all calculation logic:
```bash
flutter test test/widget_test.dart
```

### Manual Testing Checklist
- [ ] Monthly payment displays correctly
- [ ] Stamp duty matches HMRC calculators
- [ ] LTV updates in real-time
- [ ] Graph renders smoothly
- [ ] Table scrolls properly
- [ ] Settings persist after restart
- [ ] Dark mode works correctly
- [ ] All sliders respond
- [ ] Region selector works

---

## Customization

### Colors
Edit `lib/core/theme/app_theme.dart`:
```dart
static const Color primaryBlue = Color(0xFF2E5BFF);
static const Color backgroundGrey = Color(0xFFF7F8FA);
```

### Slider Ranges
Edit `lib/presentation/screens/calculator_screen.dart`:
```dart
InputSlider(
  label: 'Property Price',
  value: propertyPrice,
  min: 50000,    // Change minimum
  max: 2000000,  // Change maximum
  ...
)
```

### Default Values
Edit initial state:
```dart
double propertyPrice = 300000;
double depositPercentage = 10;
double interestRate = 4.5;
int termYears = 25;
```

---

## Performance Optimization

### Chart Performance
Using fl_chart with:
- Yearly data points (not monthly) for graphs
- Curve smoothing
- Limited grid lines

### Settings Storage
Using shared_preferences for:
- Default region
- Default term
- Dark mode preference

---

## Future Enhancements

### Priority 1 (v1.1)
1. **Overpayment Calculator**
   - Add optional overpayment slider
   - Show time/interest saved
   
2. **Export Feature**
   - PDF export of amortization table
   - CSV export for Excel

3. **Comparison Mode**
   - Side-by-side comparison of 2 scenarios

### Priority 2 (v1.2)
1. **Widgets**
   - Home screen widget showing saved calculation
   
2. **Notifications**
   - Alert when interest rates change

3. **Historical Charts**
   - Show historical UK interest rates

---

## App Store Submission

### iOS App Store

1. **Prepare Assets**
   - App icon (1024x1024)
   - Screenshots (various sizes)
   - App preview video (optional)

2. **App Store Connect**
   - Set price: £3.99
   - Add description
   - Add keywords
   - Set age rating: 4+

3. **Build & Upload**
```bash
flutter build ios --release
```

### Google Play Store

1. **Prepare Assets**
   - App icon (512x512)
   - Feature graphic (1024x500)
   - Screenshots
   - Privacy policy URL

2. **Play Console**
   - Set price: £3.99
   - Add description
   - Add screenshots
   - Set content rating

3. **Build & Upload**
```bash
flutter build appbundle --release
```

---

## Troubleshooting

### Charts not displaying
- Check fl_chart is installed: `flutter pub get`
- Verify data has values
- Check container has defined height

### Settings not saving
- iOS: Check Info.plist permissions
- Android: Check AndroidManifest.xml

### Calculations seem wrong
- Verify formula in mortgage_calculator.dart
- Check for integer division issues
- Test with known values

---

## Support & Maintenance

### Regular Updates
- Update stamp duty thresholds annually (Budget day)
- Update dependencies: `flutter pub upgrade`
- Test on new iOS/Android versions

### User Feedback
- Monitor app store reviews
- Track common feature requests
- Fix critical bugs within 48 hours

---

## Code Quality

### Formatting
```bash
dart format .
```

### Analysis
```bash
flutter analyze
```

### Linting
Already configured in `analysis_options.yaml`

---

## Deployment Checklist

Before each release:
- [ ] All tests pass
- [ ] No analyzer warnings
- [ ] Version number updated in pubspec.yaml
- [ ] Changelog updated
- [ ] Screenshots updated
- [ ] Tested on physical devices
- [ ] Privacy policy reviewed
- [ ] Stamp duty rates verified
- [ ] Performance tested

---

## Contact

For development questions or contributions, contact the development team.
