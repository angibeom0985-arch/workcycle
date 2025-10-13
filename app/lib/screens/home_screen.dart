import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/shift_pattern.dart';
import '../services/storage_service.dart';
import 'calendar_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final StorageService _storageService = StorageService();

  ShiftPattern _shiftPattern = ShiftPattern(
    dayShifts: 2,
    nightShifts: 2,
    offDays: 4,
    startDate: DateTime.now(),
  );

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadShiftPattern();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadShiftPattern() async {
    final pattern = await _storageService.loadShiftPattern();
    if (pattern != null) {
      setState(() {
        _shiftPattern = pattern;
      });
      // 캘린더 탭으로 자동 이동
      _tabController.animateTo(1);
    }
  }

  Future<void> _saveAndNavigate() async {
    await _storageService.saveShiftPattern(_shiftPattern);
    _tabController.animateTo(1);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('근무 패턴이 저장되었습니다'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '교대근무 달력',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.settings), text: '설정'),
            Tab(icon: Icon(Icons.calendar_month), text: '달력'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // 설정 탭
          _buildSettingsTab(),
          // 달력 탭
          CalendarScreen(
            shiftPattern: _shiftPattern,
            onBackToSetup: () => _tabController.animateTo(0),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTab() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Colors.grey[50]!, Colors.blue[50]!, Colors.purple[50]!],
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 4,
                            height: 24,
                            decoration: BoxDecoration(
                              color: const Color(0xFF2563EB),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            '근무 패턴 설정',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // 주간 근무일
                      _buildNumberInput(
                        label: '주간 근무일',
                        value: _shiftPattern.dayShifts,
                        icon: Icons.wb_sunny,
                        color: Colors.amber,
                        onChanged: (value) {
                          setState(() {
                            _shiftPattern = _shiftPattern.copyWith(
                              dayShifts: value,
                            );
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      // 야간 근무일
                      _buildNumberInput(
                        label: '야간 근무일',
                        value: _shiftPattern.nightShifts,
                        icon: Icons.nightlight_round,
                        color: Colors.indigo,
                        onChanged: (value) {
                          setState(() {
                            _shiftPattern = _shiftPattern.copyWith(
                              nightShifts: value,
                            );
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      // 연속 휴무일
                      _buildNumberInput(
                        label: '연속 휴무일',
                        value: _shiftPattern.offDays,
                        icon: Icons.free_breakfast,
                        color: Colors.red,
                        onChanged: (value) {
                          setState(() {
                            _shiftPattern = _shiftPattern.copyWith(
                              offDays: value,
                            );
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      // 패턴 시작일
                      _buildDatePicker(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 사용법 안내
              Card(
                elevation: 2,
                color: Colors.blue[50],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.blue[700],
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '사용법',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.blue[900],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '주간, 야간, 휴무 주기를 입력하고 패턴 시작일을 선택하세요.',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.blue[800],
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 완료 버튼
              ElevatedButton(
                onPressed: _saveAndNavigate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
                child: const Text(
                  '완료',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 80), // 하단 여백
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNumberInput({
    required String label,
    required int value,
    required IconData icon,
    required Color color,
    required ValueChanged<int> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF6B7280),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: value > 0 ? () => onChanged(value - 1) : null,
                icon: const Icon(Icons.remove),
                color: const Color(0xFF2563EB),
              ),
              Expanded(
                child: Text(
                  '$value',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ),
              IconButton(
                onPressed: () => onChanged(value + 1),
                icon: const Icon(Icons.add),
                color: const Color(0xFF2563EB),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.calendar_today, size: 20, color: Colors.green),
            SizedBox(width: 8),
            Text(
              '패턴 시작일',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF6B7280),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final pickedDate = await showDatePicker(
              context: context,
              initialDate: _shiftPattern.startDate,
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: const ColorScheme.light(
                      primary: Color(0xFF2563EB),
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (pickedDate != null) {
              setState(() {
                _shiftPattern = _shiftPattern.copyWith(startDate: pickedDate);
              });
            }
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('yyyy-MM-dd').format(_shiftPattern.startDate),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const Icon(Icons.calendar_month, color: Color(0xFF2563EB)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
