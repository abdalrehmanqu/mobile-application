import 'package:floor/floor.dart';
import 'package:json_annotation/json_annotation.dart';

class DateTimeConverter extends TypeConverter<DateTime, int>
    implements JsonConverter<DateTime?, String?> {
  DateTimeConverter();

  @override
  DateTime decode(int databaseValue) =>
      DateTime.fromMillisecondsSinceEpoch(databaseValue, isUtc: true)
          .toLocal();

  @override
  int encode(DateTime value) => value.toUtc().millisecondsSinceEpoch;

  @override
  DateTime? fromJson(String? json) {
    if (json == null) return null;
    return DateTime.parse(json).toLocal();
  }

  @override
  String? toJson(DateTime? date) {
    if (date == null) return null;
    return date.toUtc().toIso8601String();
  }
}

class NullableDateTimeConverter extends TypeConverter<DateTime?, int?> {
  NullableDateTimeConverter();

  @override
  DateTime? decode(int? databaseValue) {
    if (databaseValue == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(databaseValue, isUtc: true)
        .toLocal();
  }

  @override
  int? encode(DateTime? value) {
    if (value == null) return null;
    return value.toUtc().millisecondsSinceEpoch;
  }
}
