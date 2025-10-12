class ShiftPattern {
  final int dayShifts;
  final int nightShifts;
  final int offDays;
  final DateTime startDate;

  ShiftPattern({
    required this.dayShifts,
    required this.nightShifts,
    required this.offDays,
    required this.startDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'dayShifts': dayShifts,
      'nightShifts': nightShifts,
      'offDays': offDays,
      'startDate': startDate.toIso8601String(),
    };
  }

  factory ShiftPattern.fromJson(Map<String, dynamic> json) {
    return ShiftPattern(
      dayShifts: json['dayShifts'] as int,
      nightShifts: json['nightShifts'] as int,
      offDays: json['offDays'] as int,
      startDate: DateTime.parse(json['startDate'] as String),
    );
  }

  ShiftPattern copyWith({
    int? dayShifts,
    int? nightShifts,
    int? offDays,
    DateTime? startDate,
  }) {
    return ShiftPattern(
      dayShifts: dayShifts ?? this.dayShifts,
      nightShifts: nightShifts ?? this.nightShifts,
      offDays: offDays ?? this.offDays,
      startDate: startDate ?? this.startDate,
    );
  }

  int get cycleLength => dayShifts + nightShifts + offDays;
}

enum DayStatus {
  off,
  day,
  night,
  future,
}

extension ShiftPatternExtension on ShiftPattern {
  DayStatus? getShiftStatus(DateTime date) {
    if (cycleLength == 0) return null;

    final normalizedDate = DateTime(date.year, date.month, date.day);
    final normalizedStart = DateTime(startDate.year, startDate.month, startDate.day);

    if (normalizedDate.isBefore(normalizedStart)) {
      return DayStatus.future;
    }

    final dayDiff = normalizedDate.difference(normalizedStart).inDays;
    final positionInCycle = dayDiff % cycleLength;

    if (positionInCycle < dayShifts) {
      return DayStatus.day;
    } else if (positionInCycle < dayShifts + nightShifts) {
      return DayStatus.night;
    } else {
      return DayStatus.off;
    }
  }
}
