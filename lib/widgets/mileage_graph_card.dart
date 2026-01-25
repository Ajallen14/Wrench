import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../models/bike_model.dart';

class MileageGraphCard extends StatelessWidget {
  final List<FuelEntry> entries;

  const MileageGraphCard({super.key, required this.entries});

  @override
  Widget build(BuildContext context) {
    // 1. Prepare Graph Data (Oldest -> Newest)
    final graphEntries = entries.reversed.toList();

    // 2. Find "Best" Mileage
    double maxMileage = 0;
    DateTime? bestDate;

    for (var entry in graphEntries) {
      if (entry.mileage > maxMileage) {
        maxMileage = entry.mileage;
        bestDate = entry.date;
      }
    }

    // 3. Create Spots for the Chart
    List<FlSpot> spots = [];
    for (int i = 0; i < graphEntries.length; i++) {
      spots.add(FlSpot(i.toDouble(), graphEntries[i].mileage));
    }

    // 4. CALCULATE MONTHLY AVERAGES
    Map<String, Map<String, double>> monthlyStats = {};

    for (var entry in graphEntries) {
      String monthKey = DateFormat('MMM yyyy').format(entry.date);

      if (!monthlyStats.containsKey(monthKey)) {
        monthlyStats[monthKey] = {'distance': 0.0, 'liters': 0.0};
      }
      monthlyStats[monthKey]!['distance'] =
          monthlyStats[monthKey]!['distance']! + entry.tripDistance;
      monthlyStats[monthKey]!['liters'] =
          monthlyStats[monthKey]!['liters']! + entry.liters;
    }

    // Newest Month First
    List<String> monthKeys = monthlyStats.keys.toList().reversed.toList();

    // Check for Dark Mode to set text colors correctly
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- HEADER: Best Mileage ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Best Mileage",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  Text(
                    "${maxMileage.toStringAsFixed(1)} km/L",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              if (bestDate != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    DateFormat('MMM yyyy').format(bestDate),
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 25),

          // --- CHART ---
          SizedBox(
            height: 150,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (touchedSpot) => Colors.green,
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        return LineTooltipItem(
                          "${spot.y.toStringAsFixed(1)} km/L",
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: Colors.green,
                    barWidth: 4,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.green.withOpacity(0.15),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 25),
          const Divider(),
          const SizedBox(height: 10),
          const Text(
            "Monthly Averages",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 10),

          // --- HORIZONTAL LIST: Monthly Stats ---
          SizedBox(
            height:
                110, // <--- FIXED: Increased from 80 to 110 to prevent overflow
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: monthKeys.length,
              itemBuilder: (context, index) {
                String key = monthKeys[index];
                double totalDist = monthlyStats[key]!['distance']!;
                double totalLit = monthlyStats[key]!['liters']!;
                double avg = totalDist / totalLit;

                return Container(
                  width: 100,
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.withOpacity(0.2)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        key,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        avg.toStringAsFixed(1),
                        // FIXED: Uses white text in dark mode, black in light mode
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      const Text(
                        "km/L",
                        style: TextStyle(fontSize: 10, color: Colors.green),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
