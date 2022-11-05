import 'package:awecg/repository/my_colors.dart';
import 'package:awecg/widget/menu_button.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InitScreen extends StatelessWidget {
  InitScreen({super.key});

  double menuButtonPadding = 5.dp;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          /*NavigationRail(
            elevation: 8,
            extended: false,
            leading: IconButton(n  
                icon: const Icon(
                  Icons.menu,
                ),
                onPressed: () {}),
            backgroundColor: MyColors.blueL,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(
                  Icons.share,
                ),
                label: Text('Share'),
              ),
              NavigationRailDestination(
                icon: Icon(
                  Icons.search,
                ),
                label: Text('Search'),
              ),
            ],
            trailing: IconButton(
                icon: const Icon(
                  Icons.settings,
                ),
                onPressed: () {}),
            selectedIndex: null,
          ),*/
          Container(
            width: 80.dp,
            color: MyColors.blueL,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(
                    top: menuButtonPadding,
                    bottom: menuButtonPadding,
                  ),
                  child: TextButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                    ),
                    child: Icon(
                      Icons.menu,
                      size: 40.dp,
                      color: MyColors.grayL,
                    ),
                    onPressed: () {},
                  ),
                ),
                Divider(
                  color: MyColors.grayL,
                  thickness: 0.5,
                  height: 1,
                  endIndent: 10.dp,
                  indent: 10.dp,
                ),
                Container(
                  padding: EdgeInsets.only(
                    top: menuButtonPadding,
                    bottom: menuButtonPadding,
                  ),
                  child: TextButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                    ),
                    child: Icon(
                      Icons.share,
                      size: 40.dp,
                      color: MyColors.grayL,
                    ),
                    onPressed: () {},
                  ),
                ),
                Divider(
                  color: MyColors.grayL,
                  thickness: 0.5,
                  height: 1,
                  endIndent: 10.dp,
                  indent: 10.dp,
                ),
                Container(
                  padding: EdgeInsets.only(
                    top: menuButtonPadding,
                    bottom: menuButtonPadding,
                  ),
                  child: TextButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                    ),
                    child: SvgPicture.asset(
                      'lib/assets/svg_files/up-and-down.svg',
                      width: 40.dp,
                      height: 40.dp,
                      color: MyColors.grayL,
                    ),
                    /*Icon(
                      Icons.insert_chart,
                      size: 40.dp,
                      color: MyColors.grayL,
                    ),*/
                    onPressed: () {},
                  ),
                ),
                Divider(
                  color: MyColors.grayL,
                  thickness: 0.5,
                  height: 1,
                  endIndent: 10.dp,
                  indent: 10.dp,
                ),
                Expanded(child: Container()),
                Container(
                  padding: EdgeInsets.only(
                    top: menuButtonPadding,
                    bottom: menuButtonPadding,
                  ),
                  child: TextButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                    ),
                    child: Icon(
                      Icons.settings,
                      size: 40.dp,
                      color: MyColors.grayL,
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(
                      top: 10.dp,
                      bottom: 10.dp,
                      left: 10.dp,
                      right: 10.dp,
                    ),
                    child: LineChart(
                      LineChartData(
                        lineTouchData: LineTouchData(
                          touchTooltipData: LineTouchTooltipData(
                              //maxContentWidth: 1,
                              tooltipBgColor: Colors.orange,
                              getTooltipItems: (touchedSpots) {
                                return touchedSpots
                                    .map((LineBarSpot touchedSpot) {
                                  final textStyle = TextStyle(
                                    color:
                                        touchedSpot.bar.gradient?.colors[0] ??
                                            touchedSpot.bar.color,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  );
                                  return LineTooltipItem(
                                      '${touchedSpot.x.toStringAsFixed(3)}, ${touchedSpot.y.toStringAsFixed(2)}',
                                      textStyle);
                                }).toList();
                              }),
                          handleBuiltInTouches: true,
                          getTouchLineStart: (data, index) => 0,
                        ),
                        lineBarsData: [
                          LineChartBarData(
                            show: true,
                            color: Colors.black,
                            spots: [
                              FlSpot(0, 0),
                              FlSpot(20, 10),
                            ],
                            isCurved: false,
                            isStrokeCapRound: true,
                            barWidth: 1,
                            belowBarData: BarAreaData(
                              show: false,
                            ),
                            dotData: FlDotData(show: false),
                          ),
                        ],
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            axisNameWidget: const Text(
                              'Voltage [mV]',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            sideTitles: SideTitles(
                              showTitles: true,
                              //getTitlesWidget: leftTitleWidgets,
                              reservedSize: 60,
                            ),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          bottomTitles: AxisTitles(
                            axisNameWidget: const Text(
                              'Time [s]',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            sideTitles: SideTitles(
                              showTitles: false,
                              //getTitlesWidget: bottomTitleWidgets,
                              reservedSize: 36,
                            ),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        gridData: FlGridData(
                          show: true,
                          drawHorizontalLine: true,
                          drawVerticalLine: true,
                          horizontalInterval: 1, // scale in mV (0.1 mV)
                          verticalInterval: 1, // scale to show
                          getDrawingHorizontalLine: (value) {
                            return value % 5 == 0
                                ? FlLine(
                                    color: Colors.black,
                                    strokeWidth: 0.5,
                                  )
                                : FlLine(
                                    color: Colors.black,
                                    strokeWidth: 0.1,
                                  );
                          },
                          getDrawingVerticalLine: (value) {
                            return value % 5 == 0
                                ? FlLine(
                                    color: Colors.black,
                                    strokeWidth: 0.5,
                                  )
                                : FlLine(
                                    color: Colors.black,
                                    strokeWidth: 0.1,
                                  );
                          },
                        ),
                        borderData: FlBorderData(show: true),
                        maxY: 50,
                        minY: -50,
                        minX: 0,
                        maxX: 100,
                      ),
                    ),
                  ),
                ),
                Container(
                  color: MyColors.blueL,
                  width: 200.dp,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
