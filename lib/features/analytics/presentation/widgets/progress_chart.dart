import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/utils/app_theme.dart';
import '../../../workout/domain/entities/workout.dart';

class ProgressChart extends StatelessWidget {
  final List<Workout> workouts;

  const ProgressChart({super.key, required this.workouts});

  @override
  Widget build(BuildContext context) {
    if (workouts.isEmpty) {
      return const SizedBox.shrink();
    }

    // Sort workouts by date
    final sortedWorkouts = List<Workout>.from(workouts)
      ..sort((a, b) => a.date.compareTo(b.date));

    // Take last 7 workouts for visibility
    final displayWorkouts = sortedWorkouts.length > 7
        ? sortedWorkouts.sublist(sortedWorkouts.length - 7)
        : sortedWorkouts;

    return AspectRatio(
      aspectRatio: 1.70,
      child: Padding(
        padding: const EdgeInsets.only(
          right: 18,
          left: 12,
          top: 24,
          bottom: 12,
        ),
        child: LineChart(
          LineChartData(
            gridData: const FlGridData(show: false),
            titlesData: FlTitlesData(
              show: true,
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  interval: 1,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index < 0 || index >= displayWorkouts.length) {
                      return const SizedBox.shrink();
                    }
                    return SideTitleWidget(
                      meta: meta,
                      child: Text(
                        DateFormat('MM/dd').format(displayWorkouts[index].date),
                        style: const TextStyle(fontSize: 10),
                      ),
                    );
                  },
                ),
              ),
              leftTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: true, reservedSize: 40),
              ),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(color: const Color(0xff37434d)),
            ),
            minX: 0,
            maxX: (displayWorkouts.length - 1).toDouble(),
            minY: 0,
            maxY: displayWorkouts.fold(
                    0.0,
                    (max, e) =>
                        e.caloriesBurned > max ? e.caloriesBurned : max) *
                1.2,
            lineBarsData: [
              LineChartBarData(
                spots: displayWorkouts.asMap().entries.map((e) {
                  return FlSpot(e.key.toDouble(), e.value.caloriesBurned);
                }).toList(),
                isCurved: true,
                color: AppTheme.primaryColor,
                barWidth: 3,
                isStrokeCapRound: true,
                dotData: const FlDotData(show: true),
                belowBarData: BarAreaData(
                  show: true,
                  color: AppTheme.primaryColor.withOpacity(0.3),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
