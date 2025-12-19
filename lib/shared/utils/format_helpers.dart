import 'package:flutter_practice13/core/models/app_settings_model.dart';

class FormatHelpers {
  static String formatCurrency(double amount, Currency currency) {
    return '${amount.toStringAsFixed(2)} ${currency.symbol}';
  }

  static String formatDistance(int distance, DistanceUnit unit) {
    if (unit == DistanceUnit.miles) {
      final miles = (distance * 0.621371).round();
      return '$miles ${unit.abbreviation}';
    }
    return '$distance ${unit.abbreviation}';
  }

  static String getCurrencyLabel(Currency currency) {
    switch (currency) {
      case Currency.rub:
        return 'руб.';
      case Currency.usd:
        return '\$';
      case Currency.eur:
        return '€';
    }
  }
}


