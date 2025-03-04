import 'dart:ffi';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'constants.dart';
import 'util.dart';
import 'theme.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Retrieves the default theme for the platform
    final brightness = View.of(context).platformDispatcher.platformBrightness;
    // TextTheme textTheme = Theme.of(context).textTheme;
    // Use with Google Fonts package to use downloadable fonts
    TextTheme textTheme = createTextTheme(context, "Roboto", "Roboto");

    MaterialTheme theme = MaterialTheme(textTheme);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: brightness == Brightness.light ? theme.light() : theme.dark(),
      home: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.primaryFixed,
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.primaryFixedDim,
              title: Text("Location"),
            ),
            body: DaysPage(),
          );
        },
      ),
    );
  }
}

class DaysPage extends StatefulWidget {
  const DaysPage({super.key});

  @override
  State<DaysPage> createState() => _DaysPageState();
}
class _DaysPageState extends State<DaysPage> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.vertical,
      children: [
        Padding(
          padding: EdgeInsets.all(defaultPadding/4),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            StatsDataContainer(icon: Icons.water_drop_outlined),
            StatsDataContainer(icon: Icons.indeterminate_check_box_outlined),
          ],
        ),
        HourlyForecast(
          title: "Temperature",
          icon: Icons.ac_unit_sharp,
          timeData: [
          {"time": "Now", "icon": Icons.wb_sunny_outlined, "value": "7°C"},
          {"time": "10 AM", "icon": Icons.wb_sunny_outlined, "value": "8°C"},
          {"time": "11 AM", "icon": Icons.cloud_outlined, "value": "9°C"},
          {"time": "12 AM", "icon": Icons.cloud_outlined, "value": "10°C"},
          {"time": "1 PM", "icon": Icons.cloud_outlined, "value": "11°C"},
          {"time": "2 PM", "icon": Icons.wb_sunny_outlined, "value": "12°C"},
          {"time": "3 PM", "icon": Icons.wb_sunny_outlined, "value": "10°C"},
          {"time": "4 PM", "icon": Icons.wb_sunny_outlined, "value": "7°C"},
          {"time": "5 PM", "icon": Icons.wb_sunny_outlined, "value": "4°C"},
          {"time": "6 PM", "icon": Icons.wb_sunny_outlined, "value": "3°C"},
          {"time": "7 PM", "icon": Icons.cloud_outlined, "value": "2°C"},
          {"time": "8 PM", "icon": Icons.cloud_outlined, "value": "1°C"},
          {"time": "9 PM", "icon": Icons.cloud_outlined, "value": "1°C"},
          {"time": "10 PM", "icon": Icons.nights_stay_outlined, "value": "0°C"},
          {"time": "11 PM", "icon": Icons.nights_stay_outlined, "value": "0°C"},
          {"time": "12 PM", "icon": Icons.nights_stay_outlined, "value": "0°C"},
          {"time": "1 AM", "icon": Icons.nights_stay_outlined, "value": "-1°C"},
          {"time": "2 AM", "icon": Icons.nights_stay_outlined, "value": "-1°C"},
          {"time": "3 AM", "icon": Icons.nights_stay_outlined, "value": "-1°C"},
          {"time": "4 AM", "icon": Icons.nights_stay_outlined, "value": "0°C"},
          {"time": "5 AM", "icon": Icons.nights_stay_outlined, "value": "2°C"},
          {"time": "6 AM", "icon": Icons.nights_stay_outlined, "value": "4°C"},
          {"time": "7 AM", "icon": Icons.wb_sunny_outlined, "value": "6°C"},
          {"time": "8 AM", "icon": Icons.wb_sunny_outlined, "value": "9°C"},
          {"time": "9 AM", "icon": Icons.wb_sunny_outlined, "value": "10°C"},
          ],
        ),
        DayForecast(),
        HoursDataContainer(),
        HoursDataContainer(),
        HoursDataContainer(),
        HoursDataContainer(),
        HoursDataContainer(),
        HoursDataContainer(),
      ],
    );
  }
}

class DayForecast extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<Map<String, dynamic>> timeData;

  const DayForecast({
    super.key,
    this.icon = Icons.calendar_today,
    this.title = "Day forecast",
    this.timeData = const [],
  });

  @override
  Widget build(BuildContext context) {
    // Use provided data or fallback to default data for 7 days.
    final data = timeData.isNotEmpty ? timeData : _defaultData();

    // Extract temperatures and compute min/max.
    final temps = data.map((d) => d['temp'] as double).toList();
    final minTemp = temps.reduce(min);
    final maxTemp = temps.reduce(max);

    // Expand min/max by dividing by 0.8.
    final minY = minTemp / 0.8;
    final maxY = maxTemp / 0.8;
    final midY = (minY + maxY) / 2;

    // Day labels from data.
    final dayLabels = data.map((d) => d['day'] as String).toList();

    // Build the chart points.
    final spots = <FlSpot>[];
    for (int i = 0; i < data.length; i++) {
      final double temp = data[i]['temp'] as double;
      spots.add(FlSpot(i.toDouble(), temp));
    }

    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: MediaQuery.of(context).size.width / 2.3,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title Row (Icon + Text)
          Row(
            children: [
              Icon(icon, size: 24, color: colorScheme.onPrimaryContainer),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Temperature Line Graph
          SizedBox(
            height: 150,
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: data.length - 1,
                minY: minY,
                maxY: maxY,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 3,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.withOpacity(0.5),
                      strokeWidth: 2,
                    );
                  },
                ),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        const epsilon = 0.001;
                        if ((value - minY).abs() < epsilon ||
                            (value - midY).abs() < epsilon ||
                            (value - maxY).abs() < epsilon) {
                          return Text(
                            "${value.toStringAsFixed(0)}°",
                            style: TextStyle(
                              color: colorScheme.onPrimaryContainer,
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < dayLabels.length) {
                          return Text(
                            dayLabels[index],
                            style: TextStyle(
                              color: colorScheme.onPrimaryContainer,
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                // Configure touch interactions.
                lineTouchData: LineTouchData(
                  enabled: true,
                  handleBuiltInTouches: true,
                  touchTooltipData: LineTouchTooltipData(
                    tooltipRoundedRadius: 8,
                    tooltipPadding: const EdgeInsets.all(8),
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((touchedSpot) {
                        return LineTooltipItem(
                          "${touchedSpot.y.toStringAsFixed(1)}°",
                          TextStyle(
                            color: colorScheme.primaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }).toList();
                    },
                  ),
                  getTouchedSpotIndicator: (LineChartBarData barData, List<int> spotIndexes) {
                    return spotIndexes.map((index) {
                      return TouchedSpotIndicatorData(
                        // Vertical dashed line indicator.
                        FlLine(
                          color: colorScheme.onPrimaryFixed,
                          strokeWidth: 1,
                          dashArray: [5, 5],
                        ),
                        // Dot indicator at the touched spot.
                        FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) {
                            return FlDotCirclePainter(
                              radius: 4,
                              color: colorScheme.onPrimaryFixed,
                              strokeWidth: 2,
                              strokeColor: colorScheme.primaryContainer,
                            );
                          },
                        ),
                      );
                    }).toList();
                  },
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: colorScheme.onPrimaryFixed,
                    // Remove default dots.
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          colorScheme.onPrimaryFixed.withOpacity(0.4),
                          Colors.transparent,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Default data for 7 days (including "today").
  List<Map<String, dynamic>> _defaultData() {
    return [
      {'day': 'Mon', 'temp': -5.0},
      {'day': 'Tue', 'temp': -2.0},
      {'day': 'Wed', 'temp': 0.0},
      {'day': 'Thu', 'temp': 3.0},
      {'day': 'Fri', 'temp': 2.0},
      {'day': 'Sat', 'temp': 0.0},
      {'day': 'Sun', 'temp': 1.0},
    ];
  }
}
/*
Forecast(
  title: "Temperature",
  icon: "weather_icon",
  timeData: [
    {"time": "08:00 AM", "icon": Icons.wb_sunny, "value": "15°C"},
    {"time": "12:00 PM", "icon": Icons.wb_cloudy, "value": "18°C"},
    {"time": "06:00 PM", "icon": Icons.nights_stay, "value": "12°C"},
  ],
);
 */
class HourlyForecast extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<Map<String, dynamic>> timeData; // Growable list of time-based data

  const HourlyForecast({
    super.key,
    this.icon = Icons.ac_unit_outlined,
    this.title = "Stat",
    this.timeData = const [], // Default to empty list
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 2 - defaultPadding * 1.5,
      padding: EdgeInsets.all(defaultPadding),
      margin: EdgeInsets.symmetric(horizontal: defaultMargin, vertical: defaultMargin / 2),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryFixedDim,
        borderRadius: BorderRadius.circular(defaultBorder),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: defaultIconSize,
                height: defaultIconSize,
                child: Icon(
                  icon,
                  size: 40,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
              Text(
                "${title}",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryFixed,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 128,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 12),
              children: timeData.map((entry) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: defaultPadding/2),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(entry['time'].toString(), style: TextStyle(fontSize: 14)),
                      Icon(entry['icon'], size: 24),
                      Text(entry['value'].toString(), style: TextStyle(fontSize: 14)),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

/*
return ListView(
      scrollDirection: Axis.vertical,
      children: [
        Padding(
          padding: EdgeInsets.all(defaultPadding/4),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            StatsDataContainer(),
            StatsDataContainer(),
          ],
        ),
      ],
    );
 */
class StatsDataContainer extends StatelessWidget {
  final String title;
  final String value;
  final String change;
  final IconData icon; // Now correctly using IconData

  const StatsDataContainer({
    super.key,
    this.title = "Stat",
    this.value = "-5",
    this.change = "20%",
    this.icon = Icons.science_outlined, // Default to a valid IconData
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 2 - defaultPadding * 1.5,
      padding: EdgeInsets.all(defaultPadding),
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: defaultMargin / 2),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryFixedDim,
        borderRadius: BorderRadius.circular(defaultBorder),
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: defaultIconSize,
              height: defaultIconSize,
              child: Icon(
                icon,
                size: 40,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${title}",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryFixed,
                    ),
                  ),
                  Text(
                    "${value}",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryFixed,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "${change}",
                  textAlign: TextAlign.end,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryFixed,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class HoursDataContainer extends StatelessWidget {
  final String time;
  final String weather;
  final String maximum;
  final String minimum;
  final String icon;

  const HoursDataContainer({
    super.key,
    this.time = "Time",
    this.weather = "Weather",
    this.maximum = "Max",
    this.minimum = "Min",
    this.icon = "default_icon",
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all(defaultPadding),
          margin: EdgeInsets.symmetric(
            horizontal: defaultMargin,
            vertical: defaultMargin / 2,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryFixedDim,
            borderRadius: BorderRadius.circular(defaultBorder),
          ),
          child: IntrinsicHeight(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // DATA INSERTION
                      Text(
                        "${time}",
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimaryFixed,
                        ),
                      ),
                      Text(
                        "${weather}",
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimaryFixed,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // DATA INSERTION
                    Text(
                      '${maximum}',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimaryFixed,
                      ),
                    ),
                    Text(
                      '${minimum}',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimaryFixed,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 4),
                VerticalDivider(
                  width: defaultDivider,
                  thickness: 1,
                  color: Theme.of(context).colorScheme.onPrimaryFixed,
                  indent: 8,
                  endIndent: 8,
                ),
                SizedBox(width: defaultDivider),
                SizedBox(
                  // DATA INSERTION
                  width: defaultIconSize,
                  height: defaultIconSize,
                  child: Icon(
                    Icons.wb_cloudy_rounded,
                    size: 40,
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
                ),
                SizedBox(width: defaultDivider * 4),
              ],
            ),
          ),
        ),
        // Positioned dropdown icon
        Positioned(
          // DATA INSERTION FOR ICON
          top: 4,
          right: 4,
          child: IconButton(
            icon: Icon(
              Icons.arrow_drop_down_circle,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            iconSize: 16,
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}
/*  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}*/
