import 'package:shared_preferences/shared_preferences.dart';

class StreakService {
  static const String _streakKey = 'daily_streak';
  static const String _lastCompletedDateKey = 'last_completed_date';

  static const int minimumSteps = 100;

  /// Returns the current streak.
  Future<int> getStreak() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_streakKey) ?? 0;
  }

  Future<int> updateStreak(int steps) async {
    final prefs = await SharedPreferences.getInstance();
    int streak = prefs.getInt(_streakKey) ?? 0;
    final String? lastCompletedDate =
    prefs.getString(_lastCompletedDateKey);
    final DateTime now = DateTime.now();
    final String today =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    // User has not reached 100 steps yet today.
    if (steps < minimumSteps) {
      return streak;
    }

    // Already counted today's successful goal.
    if (lastCompletedDate == today) {
      return streak;
    }

    // If there is a previous completed day, check whether yesterday
    // was the previous successful day.
    if (lastCompletedDate != null) {
      final DateTime lastDate = DateTime.parse(lastCompletedDate);

      final DateTime lastDateOnly =
      DateTime(lastDate.year, lastDate.month, lastDate.day);

      final DateTime todayOnly =
      DateTime(now.year, now.month, now.day);

      final int difference =
          todayOnly.difference(lastDateOnly).inDays;

      if (difference == 1) {
        // Consecutive day.
        streak++;
      } else if (difference > 1) {
        // One or more days were missed.
        streak = 1;
      }
    } else {
      // First successful day.
      streak = 1;
    }

    await prefs.setInt(_streakKey, streak);
    await prefs.setString(_lastCompletedDateKey, today);

    return streak;
  }

  /// Resets the streak manually if needed.
  Future<void> resetStreak() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt(_streakKey, 0);
    await prefs.remove(_lastCompletedDateKey);
  }
}