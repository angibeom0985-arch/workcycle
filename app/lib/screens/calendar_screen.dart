import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../models/shift_pattern.dart';

class CalendarScreen extends StatefulWidget {
  final ShiftPattern shiftPattern;
  final VoidCallback onBackToSetup;

  const CalendarScreen({
    super.key,
    required this.shiftPattern,
    required this.onBackToSetup,
  });

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _focusedDay;
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
  }

  Color _getColorForStatus(DayStatus? status) {
    switch (status) {
      case DayStatus.day:
        return Colors.amber[100]!;
      case DayStatus.night:
        return Colors.indigo[100]!;
      case DayStatus.off:
        return Colors.red[100]!;
      default:
        return Colors.transparent;
    }
  }

  Color _getTextColorForStatus(DayStatus? status) {
    switch (status) {
      case DayStatus.day:
        return Colors.amber[900]!;
      case DayStatus.night:
        return Colors.indigo[900]!;
      case DayStatus.off:
        return Colors.red[700]!;
      default:
        return Colors.black87;
    }
  }

  String _getTextForStatus(DayStatus? status) {
    switch (status) {
      case DayStatus.day:
        return '주간';
      case DayStatus.night:
        return '야간';
      case DayStatus.off:
        return '휴무';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Colors.grey[50]!, Colors.blue[50]!, Colors.purple[50]!],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // 상단 툴바
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat('yyyy년 MM월').format(_focusedDay),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: widget.onBackToSetup,
                        icon: const Icon(Icons.settings, size: 18),
                        label: const Text('설정'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[600],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            _focusedDay = DateTime.now();
                            _selectedDay = DateTime.now();
                          });
                        },
                        icon: const Icon(Icons.today, size: 18),
                        label: const Text('오늘'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 달력
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: TableCalendar(
                        firstDay: DateTime.utc(2020, 1, 1),
                        lastDay: DateTime.utc(2030, 12, 31),
                        focusedDay: _focusedDay,
                        selectedDayPredicate: (day) =>
                            isSameDay(_selectedDay, day),
                        calendarFormat: CalendarFormat.month,
                        startingDayOfWeek: StartingDayOfWeek.sunday,
                        headerVisible: false,
                        calendarStyle: CalendarStyle(
                          cellMargin: const EdgeInsets.all(4),
                          cellPadding: const EdgeInsets.all(0),
                          defaultDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          selectedDecoration: BoxDecoration(
                            color: const Color(0xFF2563EB),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          todayDecoration: BoxDecoration(
                            color: const Color(0xFF2563EB).withOpacity(0.3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          weekendTextStyle: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        daysOfWeekStyle: DaysOfWeekStyle(
                          weekdayStyle: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.bold,
                          ),
                          weekendStyle: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        calendarBuilders: CalendarBuilders(
                          defaultBuilder: (context, day, focusedDay) {
                            final status = widget.shiftPattern.getShiftStatus(
                              day,
                            );
                            return _buildCalendarDay(day, status, false);
                          },
                          selectedBuilder: (context, day, focusedDay) {
                            final status = widget.shiftPattern.getShiftStatus(
                              day,
                            );
                            return _buildCalendarDay(day, status, true);
                          },
                          todayBuilder: (context, day, focusedDay) {
                            final status = widget.shiftPattern.getShiftStatus(
                              day,
                            );
                            return _buildCalendarDay(
                              day,
                              status,
                              false,
                              isToday: true,
                            );
                          },
                        ),
                        onDaySelected: (selectedDay, focusedDay) {
                          setState(() {
                            _selectedDay = selectedDay;
                            _focusedDay = focusedDay;
                          });
                        },
                        onPageChanged: (focusedDay) {
                          setState(() {
                            _focusedDay = focusedDay;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // 범례
            Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildLegendItem(
                        '주간',
                        Colors.amber[100]!,
                        Colors.amber[200]!,
                      ),
                      _buildLegendItem(
                        '야간',
                        Colors.indigo[100]!,
                        Colors.indigo[200]!,
                      ),
                      _buildLegendItem(
                        '휴무',
                        Colors.red[100]!,
                        Colors.red[200]!,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarDay(
    DateTime day,
    DayStatus? status,
    bool isSelected, {
    bool isToday = false,
  }) {
    final statusText = _getTextForStatus(status);
    final bgColor = _getColorForStatus(status);
    final textColor = _getTextColorForStatus(status);

    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isSelected
            ? const Color(0xFF2563EB)
            : isToday
            ? const Color(0xFF2563EB).withOpacity(0.3)
            : bgColor,
        borderRadius: BorderRadius.circular(8),
        border: isToday && !isSelected
            ? Border.all(color: const Color(0xFF2563EB), width: 2)
            : null,
      ),
      child: Stack(
        children: [
          // 날짜
          Positioned(
            top: 4,
            left: 4,
            child: Text(
              '${day.day}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
          ),
          // 상태 텍스트
          if (statusText.isNotEmpty)
            Center(
              child: Text(
                statusText,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : textColor,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color, Color borderColor) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: borderColor, width: 1),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1F2937),
          ),
        ),
      ],
    );
  }
}
