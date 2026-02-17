# UK Mortgage Calculator

A clean, accurate, offline mortgage calculator built specifically for UK property buyers.

**Price:** £3.99 one-time payment  
**No ads. No subscriptions. No login. No tracking.**

---

## Features

### Core Calculations
✅ **Monthly mortgage repayments** - Accurate payment calculations  
✅ **Stamp duty calculator** - England/NI, Scotland (LBTT), Wales (LTT)  
✅ **Loan to Value (LTV)** - With color-coded risk indicators  

### Visualizations
📊 **Dynamic mortgage graph** - Balance over time  
📈 **Principal vs Interest** - Stacked visualization  
📋 **Full amortization table** - Monthly and yearly views  

### User Controls
🏠 Property price: £50,000 - £2,000,000  
💰 Deposit: 5% - 50%  
📈 Interest rate: 1% - 8%  
⏱️ Term: 5 - 40 years  
🏴󐁧󐁢󐁥󐁮󐁧󐁿 Region: England/NI, Scotland, Wales  

### Quality Features
🚀 **Works fully offline** - No internet required  
🎨 **Clean, intuitive interface** - Professional design  
🌙 **Dark mode support** - Easy on the eyes  
💾 **Saves your preferences** - Default region and term  

---

## Screenshots

### Calculator Screen
- Large, prominent monthly payment display
- Easy-to-use sliders with text input
- Real-time calculations
- LTV risk indicator with color coding

### Visualization
- **Graph Tab**: Shows mortgage balance declining over time, or principal vs interest breakdown
- **Table Tab**: Complete amortization schedule with monthly/yearly toggle

### Settings
- Default region selector
- Default term preferences
- Dark mode toggle
- Reset to defaults option

---

## Technical Details

### Architecture
```
lib/
├── core/
│   └── theme/
│       └── app_theme.dart          # Design system & colors
├── domain/
│   ├── models/
│   │   └── mortgage_calculation.dart  # Data models
│   └── services/
│       ├── mortgage_calculator.dart   # Core calculations
│       └── settings_service.dart      # Persistent settings
└── presentation/
    ├── screens/
    │   ├── calculator_screen.dart     # Main calculator
    │   └── settings_screen.dart       # Settings
    └── widgets/
        ├── calculator_widgets.dart    # Input controls
        └── visualization_widgets.dart # Graph & table
```

### Formulas Used

**Monthly Payment:**
```
r = annual_rate / 12
n = term_years * 12
P = L × [r(1+r)^n] / [(1+r)^n − 1]
```

**Loan to Value:**
```
LTV = (loan / property_price) × 100
```

**Stamp Duty:**
- England/NI: Standard SDLT rates with first-time buyer relief
- Scotland: LBTT rates
- Wales: LTT rates

---

## Design System

### Colors
- **Primary Blue:** #2E5BFF
- **Background:** #F7F8FA
- **Cards:** #FFFFFF
- **Text Primary:** #111111
- **Text Secondary:** #666666

### LTV Risk Colors
- **< 60%:** Green (Low risk)
- **60-80%:** Blue (Medium risk)
- **80-90%:** Orange (High risk)
- **> 90%:** Red (Very high risk)

---

## Getting Started

### Prerequisites
- Flutter SDK 3.8.1 or higher
- Dart 3.0 or higher

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd mortgage_app
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

### Building for Release

**iOS:**
```bash
flutter build ios --release
```

**Android:**
```bash
flutter build appbundle --release
```

---

## Testing

Run the unit tests:
```bash
flutter test
```

Tests cover:
- Monthly payment calculations
- LTV calculations
- Stamp duty for all UK regions
- Amortization schedule generation

---

## Dependencies

- **fl_chart** (^0.69.0) - Beautiful charts and graphs
- **shared_preferences** (^2.3.5) - Local settings storage

---

## App Store Optimization

### Title
UK Mortgage Calculator

### Subtitle
Stamp Duty, LTV & Payment Planner

### Keywords
- mortgage calculator
- UK mortgage
- stamp duty calculator
- LTV calculator
- house payment calculator
- property calculator
- mortgage planner

### Description
Calculate your UK mortgage payments instantly with our clean, ad-free calculator. Features accurate stamp duty calculations for England, Scotland, and Wales, plus visual breakdowns of your mortgage over time.

**Perfect for:**
- First-time buyers
- Property investors
- Remortgaging homeowners
- Estate agents
- Financial advisors

**Why choose this app:**
✓ Works offline
✓ No ads or tracking
✓ One-time purchase
✓ Professional and trustworthy
✓ Accurate UK stamp duty
✓ Visual mortgage breakdown

---

## Roadmap

### Version 1.1
- [ ] Export amortization table to PDF/CSV
- [ ] Overpayment calculator
- [ ] Compare multiple scenarios

### Version 1.2
- [ ] Widgets for home screen
- [ ] Interest rate notifications
- [ ] Historical rate charts

---

## Disclaimer

This calculator provides estimates only. Actual mortgage terms, rates, and stamp duty may vary. Always consult with a qualified mortgage advisor or financial professional before making property purchase decisions.

---

## License

Copyright © 2026. All rights reserved.

---

## Support

For support or feature requests, please contact: [your-email@example.com]

---

## Version History

**v1.0.0** (February 2026)
- Initial release
- Core mortgage calculations
- Stamp duty for all UK regions
- Graph and table visualizations
- Settings with dark mode
