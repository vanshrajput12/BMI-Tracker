import 'package:bmi_project/models/user_profile_model.dart';
import 'package:bmi_project/services/dashboard_service.dart';
import 'package:bmi_project/ui_helper/statCard_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/weight_entry_model.dart';
import '../ui_helper/bmi_chart_helper.dart';
import '../ui_helper/weight_history_chart_helper.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DashboardService _service = DashboardService();
  static const Color _backgroundColor = Color(0xFF111111);
  static const Color _cardColor = Color(0xFF151515);
  static const Color _borderColor = Color(0xFF292929);
  static const Color _accentColor = Color(0xFFFF9800);

  UserProfile? _profile;
  List<WeightEntry> _weightHistory = [];

  bool _isLoading = true;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    _loadUserData();
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
    if (_profile == null) return 0;

    if (_profile!.heightCm <= 0 || _profile!.weightKg <= 0) {
      return 0;
    }

    final heightM = _profile!.heightCm / 100;

    return _profile!.weightKg / (heightM * heightM);
  }

  String get _bmiCategory {
    if (_bmi == 0) return 'Not available';

    if (_bmi < 18.5) return 'Underweight';
    if (_bmi < 25) return 'Normal weight';
    if (_bmi < 30) return 'Overweight';

    return 'Obese';
  }

  Color get _bmiCategoryColor {
    if (_bmi < 18.5) {
      return Colors.blue;
    }

    if (_bmi < 25) {
      return Colors.green;
    }

    if (_bmi < 30) {
      return Colors.orange;
    }

    return Colors.red;
  }

  Future<void> _refresh() async {
    await _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: _backgroundColor,
        body: Center(
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            color: _accentColor,
          ),
        ),
      );
    }

    if (_profile == null) {
      return Scaffold(
        backgroundColor: _backgroundColor,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline_rounded,
                  color: Colors.white54,
                  size: 48,
                ),

                const SizedBox(height: 16),

                Text(
                  _loadError ?? "Couldn't load your profile.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: _loadUserData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _accentColor,
                    foregroundColor: Colors.black,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    'Retry',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: _backgroundColor,

      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refresh,
          color: _accentColor,
          backgroundColor: _cardColor,

          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),

            padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                _buildBmiCard(),
                const SizedBox(height: 18),
                _buildStats(),
                const SizedBox(height: 28),
                _buildSectionHeader(),
                const SizedBox(height: 14),
                _buildWeightHistoryCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // HEADER
  // ------------------------------------------------------------

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Welcome back',
                    style: GoogleFonts.poppins(
                      color: Colors.white54,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(width: 6),

                  const Text('👋', style: TextStyle(fontSize: 14)),
                ],
              ),

              const SizedBox(height: 3),

              Text(
                _profile!.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.4,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                'Let’s check your health today',
                style: GoogleFonts.poppins(
                  color: Colors.white38,
                  fontSize: 11.5,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 12),

        GestureDetector(
          onTap: _showProfileSwitcher,

          child: Container(
            width: 52,
            height: 52,

            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _accentColor,

              border: Border.all(
                color: Colors.white.withValues(alpha: 0.12),
                width: 2,
              ),

              boxShadow: [
                BoxShadow(
                  color: _accentColor.withValues(alpha: 0.20),
                  blurRadius: 16,
                  spreadRadius: 1,
                ),
              ],
            ),

            child: Center(
              child: Text(
                _profile!.initials,
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // BMI CARD
  // ------------------------------------------------------------

  Widget _buildBmiCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 22),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: _borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.30),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),

      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: _accentColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),

                child: const Icon(
                  Icons.monitor_heart_outlined,
                  color: _accentColor,
                  size: 21,
                ),
              ),

              const SizedBox(width: 11),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your BMI',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  Text(
                    'Body Mass Index',
                    style: GoogleFonts.poppins(
                      color: Colors.white38,
                      fontSize: 10.5,
                    ),
                  ),
                ],
              ),

              const Spacer(),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),

                decoration: BoxDecoration(
                  color: _bmiCategoryColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(20),
                ),

                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: _bmiCategoryColor,
                        shape: BoxShape.circle,
                      ),
                    ),

                    const SizedBox(width: 6),

                    Text(
                      _bmiCategory,
                      style: GoogleFonts.poppins(
                        color: _bmiCategoryColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),
          SizedBox(height: 185, child: BmiGauge(bmi: _bmi)),
          const SizedBox(height: 4),
          Text(
            _bmi.toStringAsFixed(1),
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 38,
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),

          const SizedBox(height: 5),
          Text(
            'Current BMI',
            style: GoogleFonts.poppins(
              color: Colors.white38,
              fontSize: 11,
              fontWeight: FontWeight(600),
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
            label: "Weight",
            value: '${_profile!.weightKg.toStringAsFixed(1)} kg',
            icon: Icons.monitor_weight_outlined,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: StatCard(
            label: "Height",
            value: '${_profile!.heightCm.toStringAsFixed(0)} cm',
            icon: Icons.height_rounded,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader() {
    return Row(
      children: [
        Container(
          width: 4,
          height: 22,
          decoration: BoxDecoration(
            color: _accentColor,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          'Weight History',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),

        const Spacer(),

        Text(
          '${_weightHistory.length} entries',
          style: GoogleFonts.poppins(color: Colors.white38, fontSize: 10.5),
        ),
      ],
    );
  }

  Widget _buildWeightHistoryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 18, 12, 12),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _borderColor),
      ),

      child: _weightHistory.isEmpty
          ? SizedBox(
              height: 180,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.show_chart_rounded,
                      color: Colors.white24,
                      size: 40,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'No weight history yet',
                      style: GoogleFonts.poppins(
                        color: Colors.white54,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Add your weight to start tracking',
                      style: GoogleFonts.poppins(
                        color: Colors.white24,
                        fontSize: 10.5,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : WeightHistoryChart(entries: _weightHistory),
    );
  }

  void _showProfileSwitcher() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFF151515),
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),

              const SizedBox(height: 22),
              Text(
                'Profile',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 5),
              Text(
                'Manage your health profile',
                style: GoogleFonts.poppins(color: Colors.white38, fontSize: 11),
              ),

              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.06),
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 23,
                      backgroundColor: _accentColor,
                      child: Text(
                        _profile!.initials,
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),

                    const SizedBox(width: 13),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _profile!.name,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          Text(
                            'Current profile',
                            style: GoogleFonts.poppins(
                              color: Colors.white38,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Icon(
                      Icons.check_circle_rounded,
                      color: Colors.green,
                      size: 22,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              InkWell(
                borderRadius: BorderRadius.circular(18),

                onTap: () {
                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: const Color(0xFF222222),

                      behavior: SnackBarBehavior.floating,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),

                      content: Text(
                        'No other profile available.',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  );
                },

                child: Container(
                  padding: const EdgeInsets.all(14),

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.06),
                    ),
                  ),

                  child: Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,

                        decoration: BoxDecoration(
                          color: _accentColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(13),
                        ),

                        child: const Icon(
                          Icons.person_add_alt_1_rounded,
                          color: _accentColor,
                          size: 20,
                        ),
                      ),

                      const SizedBox(width: 13),

                      Expanded(
                        child: Text(
                          'Add New Profile',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      const Icon(
                        Icons.chevron_right_rounded,
                        color: Colors.white38,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
