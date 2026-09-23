import 'package:intl/intl.dart';

/// Formatter for Indian Rupee (INR) currency display.
class CurrencyFormatter {
  CurrencyFormatter._();

  static final NumberFormat _inrFormatter = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );

  static final NumberFormat _inrFormatterWithDecimals = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 2,
  );

  /// Format as integer amount (e.g. ₹ 27,400)
  static String format(num amount) {
    return _inrFormatter.format(amount).replaceAll('₹', '₹ ');
  }

  /// Format with exact paise (e.g. ₹ 27,400.50)
  static String formatWithDecimals(num amount) {
    return _inrFormatterWithDecimals.format(amount).replaceAll('₹', '₹ ');
  }

  /// Format positive/negative adjustments (e.g. + ₹ 1,200 or - ₹ 4,200)
  static String formatAdjustment(num amount) {
    if (amount >= 0) {
      return '+ ${format(amount)}';
    } else {
      return '- ${format(amount.abs())}';
    }
  }
}
