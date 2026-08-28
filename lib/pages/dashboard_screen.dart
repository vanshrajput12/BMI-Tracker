import 'package:bmi_project/models/user_profile_model.dart';
import 'package:bmi_project/services/dashboard_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/step_counter_service.dart';
import '../models/weight_entry_model.dart';
import '../ui_helper/bmi_chart_helper.dart';
import '../ui_helper/statCard_helper.dart';
import '../ui_helper/weight_history_chart_helper.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DashboardService _service = DashboardService();
  final StepCounterService _stepCounterService = StepCounterService();

  UserProfile? _profile;
  List<WeightEntry> _weightHistory = [];
  bool _isLoading = true;
  String? _loadError;
  int _steps = 0;

  @override
  void initState() {
    super.initState();
    _startStepCounter();
    _loadUserData();
  }
  void _startStepCounter() {
    _stepCounterService.startStepCounter((steps) {
      if (!mounted) return;

      setState(() {
        _steps = steps;
      });
    });
  }

  Future<void> _loadUserData() async {
    try {
      setState(() {
        _isLoading = true;
        _loadError = null;
      });

      final profile = await _service.getUserProfile();
      final history = await _service.getWeightHistory();

      if (!mounted) return;

      setState(() {
        _profile = profile;
        _weightHistory = history;
        _isLoading = false;
      });

      // No profile document exists yet for this user — send them to
      // complete the details form instead of showing a broken dashboard.
      if (profile == null && mounted) {
        Navigator.of(context).pushReplacementNamed('/details');
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _loadError = 'Could not load your data. Please try again.';
      });
    }
  }

  double get _bmi {
    if (_profile == null) {
      return 0;
    }

    if (_profile!.heightCm <= 0 || _profile!.weightKg <= 0) {
      return 0;
    }

    final heightM = _profile!.heightCm / 100;
    return _profile!.weightKg / (heightM * heightM);
  }

  String get _bmiCategory {
    if (_bmi == 0) {
      return 'Not available';
    }

    if (_bmi < 18.5) {
      return 'Underweight';
    }

    if (_bmi < 25) {
      return 'Normal weight';
    }

    if (_bmi < 30) {
      return 'Overweight';
    }

    return 'Obese';
  }

  Color get _bmiCategoryColor {
    if (_bmi < 18.5) {
      return const Color(0xFF378ADD);
    }

    if (_bmi < 25) {
      return const Color(0xFF63C922);
    }

    if (_bmi < 30) {
      return const Color(0xFFEF9F27);
    }

    return const Color(0xFFE24B4A);
  }

  Future<void> _refresh() async {
    await _loadUserData();

  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: const Center(child: CircularProgressIndicator()),
      );
    }


    if (_profile == null) {
      return Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _loadError ?? "Couldn't load your profile.",
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 15),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _loadUserData,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 20),
                _buildStepCard(),
                const SizedBox(height: 16),
                _buildBmiCard(),
                const SizedBox(height: 16),
                _buildStats(),
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 10),
                Text(
                  'Weight history',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 30),
                WeightHistoryChart(entries: _weightHistory),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome Chief',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              _profile!.name,
              style: GoogleFonts.poppins(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: _showProfileSwitcher,
          child: CircleAvatar(
            radius: 26,
            backgroundColor: Colors.orange,
            child: Text(
              _profile!.initials,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBmiCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          BmiGauge(bmi: _bmi),
          const SizedBox(height: 8),
          Text(
            _bmi.toStringAsFixed(1),
            style: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: _bmiCategoryColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _bmiCategory,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: _bmiCategoryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    return Row(
      children: [
        Expanded(
          child: StatCard(
            label: 'Weight',
            value: '${_profile!.weightKg.toStringAsFixed(1)} kg',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: StatCard(
            label: 'Height',
            value: '${_profile!.heightCm.toStringAsFixed(0)} cm',
          ),
        ),
      ],
    );
  }
  Widget _buildStepCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.directions_walk,
              color: Colors.orange,
              size: 30,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Steps Today',
                  style: GoogleFonts.poppins(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$_steps',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '/ 10,000',
            style: GoogleFonts.poppins(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  void _showProfileSwitcher() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey.shade900,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Switch Profile',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.black,
                  child: Text(
                    _profile!.initials,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(
                  _profile!.name,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: const Icon(Icons.check_circle, color: Colors.green),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              const Divider(color: Colors.grey),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.add, color: Colors.white),
                ),
                title: Text(
                  'Add New Profile',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('No other profile available.'),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}