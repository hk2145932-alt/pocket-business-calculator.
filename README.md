# Pocket Business Calculator

A clean Flutter business calculator with a quick calculator and practical tools for small businesses, sellers, freelancers, and entrepreneurs.

## Included calculators

- Quick Calculator
- Profit Margin
- Markup
- Discount
- Sales Tax / VAT / GST style percentage calculation
- ROI
- Break-even Units
- Percentage
- Compound Growth

## Design

The project uses a blue/navy/green fintech palette matching the included Pocket Business Calculator logo.

Logo asset:

`assets/images/app_logo.png`

## Run the project

This repository contains the Flutter source code. If Android/iOS/web platform folders are not present yet, generate them once:

```bash
flutter create . --platforms=android,ios,web,windows
flutter pub get
flutter run
```

If you only need Android and iOS:

```bash
flutter create . --platforms=android,ios
flutter pub get
flutter run
```

## Push to GitHub

```bash
git init
git add .
git commit -m "Initial Pocket Business Calculator app"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/pocket-business-calculator.git
git push -u origin main
```

Replace `YOUR_USERNAME` with your GitHub username.

## Suggested next features

- Calculation history
- Currency selector
- Save/favorite calculators
- Dark mode
- Invoice calculator
- Loan / EMI calculator
- Profit target calculator
- Tip / commission calculator
- Share/export result
- Local persistence

## App icon

The generated logo is included as an app asset. You can also use it as the launcher icon when configuring Android/iOS launcher assets.

## License

MIT
