import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Line_Chart extends StatelessWidget {
  const Line_Chart({required this.isShowingMainData});

  final bool isShowingMainData;

  @override
  Widget build(BuildContext context) {
    return LineChart(
      isShowingMainData ? sampleData1 : sampleData2,
      duration: const Duration(milliseconds: 250),
    );
  }

  LineChartData get sampleData1 => LineChartData(
        lineTouchData: lineTouchData1,
        gridData: gridData,
        titlesData: titlesData1,
        borderData: borderData,
        lineBarsData: lineBarsData1,
        minX: 0,
        maxX: 14,
        maxY: 4,
        minY: 0,
      );

  LineChartData get sampleData2 => LineChartData(
        lineTouchData: lineTouchData2,
        gridData: gridData,
        titlesData: titlesData2,
        lineBarsData: lineBarsData2,
        minX: 0,
        maxX: 13,
        maxY: 17,
        minY: 0,
      );

  LineTouchData get lineTouchData1 => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(

            //tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
            ),
      );

  FlTitlesData get titlesData1 => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(),
        ),
      );

  List<LineChartBarData> get lineBarsData1 => [
        lineChartBarData1_1,
        lineChartBarData1_2,
        lineChartBarData1_3,
      ];

  LineTouchData get lineTouchData2 => const LineTouchData(
        enabled: false,
      );

  FlTitlesData get titlesData2 => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(),
        ),
      );

  List<LineChartBarData> get lineBarsData2 => [
        lineChartBarData2_1,
        lineChartBarData2_2,
        lineChartBarData2_3,
      ];

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontSize: 10,
    );
    String text;
    switch (value.toInt()) {
      case 5:
        text = '5kg';
        break;
      case 10:
        text = '10kg';
        break;
      case 15:
        text = '15kg';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.center);
  }

  SideTitles leftTitles() => SideTitles(
        getTitlesWidget: leftTitleWidgets,
        showTitles: true,
        interval: 1,
        reservedSize: 40,
      );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontSize: 6,
    );
    Widget text;
    switch (value.toInt()) {
      case 1:
        text = const Text('31th', style: style);
        break;
      case 2:
        text = const Text('2nd', style: style);
        break;
      case 3:
        text = const Text('5th', style: style);
        break;
      case 4:
        text = const Text('8th', style: style);
        break;
      case 5:
        text = const Text('11th', style: style);
        break;
      case 6:
        text = const Text('14th', style: style);
        break;
      case 7:
        text = const Text('17th', style: style);
        break;
      case 8:
        text = const Text('20th', style: style);
        break;
      case 9:
        text = const Text('23th', style: style);
        break;
      case 10:
        text = const Text('26th', style: style);
        break;
      case 11:
        text = const Text('29th', style: style);
        break;
      case 12:
        text = const Text('3rd', style: style);
        break;
      default:
        text = const Text('');
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: text,
    );
  }

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: 1,
        getTitlesWidget: bottomTitleWidgets,
      );

  FlGridData get gridData => const FlGridData(show: false);

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(color: Colors.black, width: 4),
          left: const BorderSide(color: Colors.transparent),
          right: const BorderSide(color: Colors.transparent),
          top: const BorderSide(color: Colors.transparent),
        ),
      );

  LineChartBarData get lineChartBarData1_1 => LineChartBarData(
        isCurved: true,
        curveSmoothness: 0,
        color: Colors.blue,
        barWidth: 1,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: const [
          FlSpot(1, 1),
          FlSpot(2, 1),
          FlSpot(3, 1),
          FlSpot(4, 1),
          FlSpot(5, 1),
          FlSpot(6, 1),
          FlSpot(7, 1),
          FlSpot(8, 1),
          FlSpot(9, 1),
          FlSpot(10, 1),
          FlSpot(11, 1),
          FlSpot(12, 1),
        ],
      );

  LineChartBarData get lineChartBarData1_2 => LineChartBarData(
        isCurved: true,
        curveSmoothness: 0,
        color: Colors.green,
        barWidth: 1,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: false),
        spots: const [
          FlSpot(1, 1),
          FlSpot(2, 1),
          FlSpot(3, 1),
          FlSpot(4, 1),
          FlSpot(5, 1),
          FlSpot(6, 1),
          FlSpot(7, 1),
          FlSpot(8, 1),
          FlSpot(9, 1),
          FlSpot(10, 1),
          FlSpot(11, 1),
          FlSpot(12, 1),
        ],
      );

  LineChartBarData get lineChartBarData1_3 => LineChartBarData(
        isCurved: true,
        curveSmoothness: 0,
        color: Colors.red,
        barWidth: 1,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: false),
        spots: const [
          FlSpot(1, 1),
          FlSpot(2, 1),
          FlSpot(3, 1),
          FlSpot(4, 1),
          FlSpot(5, 1),
          FlSpot(6, 1),
          FlSpot(7, 1),
          FlSpot(8, 1),
          FlSpot(9, 1),
          FlSpot(10, 1),
          FlSpot(11, 1),
          FlSpot(12, 1),
        ],
      );

  LineChartBarData get lineChartBarData2_1 => LineChartBarData(
        isCurved: true,
        curveSmoothness: 0,
        color: Colors.blue,
        barWidth: 1,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: const [
          FlSpot(1, 1),
          FlSpot(2, 3),
          FlSpot(3, 4),
          FlSpot(4, 2),
          FlSpot(5, 1.8),
          FlSpot(6, 4),
          FlSpot(7, 7),
          FlSpot(8, 5),
          FlSpot(9, 3),
          FlSpot(10, 2),
          FlSpot(11, 1),
          FlSpot(12, 2.2),
        ],
      );

  LineChartBarData get lineChartBarData2_2 => LineChartBarData(
        isCurved: true,
        curveSmoothness: 0,
        color: Colors.green,
        barWidth: 1,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: false),
        spots: const [
          FlSpot(1, 12),
          FlSpot(2, 11),
          FlSpot(3, 14),
          FlSpot(4, 9),
          FlSpot(5, 11),
          FlSpot(6, 10),
          FlSpot(7, 12),
          FlSpot(8, 13),
          FlSpot(9, 14),
          FlSpot(10, 11),
          FlSpot(11, 10),
          FlSpot(12, 12),
        ],
      );

  LineChartBarData get lineChartBarData2_3 => LineChartBarData(
        isCurved: true,
        curveSmoothness: 0,
        color: Colors.red,
        barWidth: 1,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: false),
        spots: const [
          FlSpot(1, 3.8),
          FlSpot(2, 2),
          FlSpot(3, 1.9),
          FlSpot(4, 2),
          FlSpot(5, 1),
          FlSpot(6, 5),
          FlSpot(7, 1),
          FlSpot(8, 2),
          FlSpot(9, 4),
          FlSpot(10, 3.3),
          FlSpot(11, 2),
          FlSpot(12, 4),
        ],
      );
}
