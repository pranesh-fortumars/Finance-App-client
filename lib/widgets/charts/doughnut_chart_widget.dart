import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DoughnutChartWidget extends StatelessWidget {
  final List<String> labels;
  final List<double> values;
  final String? title;
  final List<Color>? colors;
  final Function(int, String)? onElementClick;

  const DoughnutChartWidget({
    super.key,
    required this.labels,
    required this.values,
    this.title,
    this.colors,
    this.onElementClick,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final total = values.fold(0.0, (sum, value) => sum + value);
    final sections = values.asMap().entries.map((entry) {
      final index = entry.key;
      final value = entry.value;
      final percentage = (value / total) * 100;

      return PieChartSectionData(
        color:
            colors?[index % (colors?.length ?? 1)] ?? _getDefaultColor(index),
        value: value,
        title: '${percentage.toStringAsFixed(1)}%',
        radius: 60,
        titleStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        titlePositionPercentageOffset: 0.6,
      );
    }).toList();

    return Container(
      height: 300,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                title!,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: isDark ? Colors.grey[100] : Colors.grey[900],
                ),
              ),
            ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: PieChart(
                    PieChartData(
                      sections: sections,
                      centerSpaceRadius: 40,
                      sectionsSpace: 2,
                      pieTouchData: PieTouchData(
                        enabled: false,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: labels.asMap().entries.map((entry) {
                      final index = entry.key;
                      final label = entry.value;
                      final value = values[index];
                      final percentage = (value / total) * 100;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color:
                                    colors?[index % (colors?.length ?? 1)] ??
                                    _getDefaultColor(index),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                label,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: isDark
                                      ? Colors.grey[300]
                                      : Colors.grey[700],
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              '${percentage.toStringAsFixed(1)}%',
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? Colors.grey[100]
                                    : Colors.grey[900],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getDefaultColor(int index) {
    final defaultColors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
    ];
    return defaultColors[index % defaultColors.length];
  }
}
