import 'package:intl/intl.dart';

class AppFormatters {
  static final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  static final DateFormat _timeFormat = DateFormat('HH:mm');
  static final DateFormat _timeWithSecondsFormat = DateFormat('HH:mm:ss');
  static final DateFormat _fullDateTimeFormat = DateFormat('dd/MM/yyyy HH:mm:ss');

  static String formatDate(DateTime dt) {
    return _dateFormat.format(dt);
  }

  static String formatTime(DateTime dt) {
    return _timeFormat.format(dt);
  }

  static String formatTimeWithSeconds(DateTime dt) {
    return _timeWithSecondsFormat.format(dt);
  }

  static String formatDateTime(DateTime dt) {
    return _fullDateTimeFormat.format(dt);
  }

  static String formatFullDate(DateTime dt) {
    try {
      final formatter = DateFormat("EEEE, d 'de' MMMM 'de' yyyy", 'pt_BR');
      final result = formatter.format(dt);
      // Capitalizar primeira letra
      return result[0].toUpperCase() + result.substring(1);
    } catch (_) {
      return formatDate(dt);
    }
  }

  static String formatDistance(double meters) {
    if (meters < 1000) {
      return '${meters.toStringAsFixed(1)} m';
    } else {
      return '${(meters / 1000).toStringAsFixed(2)} km';
    }
  }
}
