import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:wallet_tracker/edit_budget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class Constants {
  static const String option1 = 'Edit Budget';
  static const String option2 = 'Show Transactions';
  static const String option3 = 'Logout';

  static const List<String> choices = <String>[
    option1,
    option2,
    option3,
  ];
}

class _MyHomePageState extends State<MyHomePage> {
  void menuchoiceoption(String choice) {
    if (choice == Constants.option1) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditBudget()),
      );
    } else if (choice == Constants.option2) {
    } else if (choice == Constants.option3) {}
  }

  Material balanceGrid(
      IconData icon, String heading, String balance, double size) {
    return Material(
      color: Color.fromRGBO(64, 75, 96, 0.9),
      elevation: 10.0,
      shadowColor: Colors.black,
      borderRadius: BorderRadius.circular(7.5),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 7.5, left: 7.5),
              child: Text(
                heading,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Material(
                  child: Icon(
                    icon,
                    color: Colors.grey,
                    size: 30,
                  ),
                ),
                Text(
                  balance,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: size,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  final Color leftBarColor = Color(0xff53fdd7);
  final Color rightBarColor = Color(0xffff5182);
  final double width = 7;

  List<BarChartGroupData> rawBarGroups;
  List<BarChartGroupData> showingBarGroups;

  StreamController<BarTouchResponse> barTouchedResultStreamController;

  int touchedGroupIndex;

  @override
  void initState() {
    super.initState();
    final barGroup1 = makeGroupData(0, 5, 7);
    final barGroup2 = makeGroupData(1, 2, 10);
    final barGroup3 = makeGroupData(2, 8, 6);
    final barGroup4 = makeGroupData(3, 2, 1.6);
    final barGroup5 = makeGroupData(4, 1.7, 0.6);
    final barGroup6 = makeGroupData(5, 10, 5);
    final barGroup7 = makeGroupData(6, 19, 11);

    final items = [
      barGroup1,
      barGroup2,
      barGroup3,
      barGroup4,
      barGroup5,
      barGroup6,
      barGroup7,
    ];

    rawBarGroups = items;

    showingBarGroups = rawBarGroups;

    barTouchedResultStreamController = StreamController();
    barTouchedResultStreamController.stream
        .distinct()
        .listen((BarTouchResponse response) {
      if (response == null) {
        return;
      }

      if (response.spot == null) {
        setState(() {
          touchedGroupIndex = -1;
          showingBarGroups = List.of(rawBarGroups);
        });
        return;
      }

      touchedGroupIndex =
          showingBarGroups.indexOf(response.spot.touchedBarGroup);

      setState(() {
        if (response.touchInput is FlLongPressEnd) {
          touchedGroupIndex = -1;
          showingBarGroups = List.of(rawBarGroups);
        } else {
          showingBarGroups = List.of(rawBarGroups);
          if (touchedGroupIndex != -1) {
            double sum = 0;
            for (BarChartRodData rod
                in showingBarGroups[touchedGroupIndex].barRods) {
              sum += rod.y;
            }
            double avg =
                sum / showingBarGroups[touchedGroupIndex].barRods.length;

            showingBarGroups[touchedGroupIndex] =
                showingBarGroups[touchedGroupIndex].copyWith(
              barRods: showingBarGroups[touchedGroupIndex].barRods.map((rod) {
                return rod.copyWith(y: avg);
              }).toList(),
            );
          }
        }
      });
    });
  }

  Material chartsGrid() {
    return Material(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.5)),
      color: Color.fromRGBO(64, 75, 96, 0.9),
      elevation: 10,
      shadowColor: Colors.black,
      child: Card(
        elevation: 0,
        color: Color.fromRGBO(64, 75, 96, 0.9),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  makeTransactionsIcon(),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Weekly Analysis",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: FlChart(
                    chart: BarChart(BarChartData(
                      maxY: 20,
                      barTouchData: BarTouchData(
                        touchTooltipData: TouchTooltipData(
                            tooltipBgColor: Colors.grey,
                            getTooltipItems: (spots) {
                              return spots.map((TouchedSpot spot) {
                                return null;
                              }).toList();
                            }),
                        touchResponseSink:
                            barTouchedResultStreamController.sink,
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: SideTitles(
                          showTitles: true,
                          textStyle: TextStyle(
                              color: const Color(0xff7589a2),
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                          margin: 20,
                          getTitles: (double value) {
                            switch (value.toInt()) {
                              case 0:
                                return 'Mon';
                              case 1:
                                return 'Tue';
                              case 2:
                                return 'Wed';
                              case 3:
                                return 'Thu';
                              case 4:
                                return 'Fri';
                              case 5:
                                return 'Sat';
                              case 6:
                                return 'Sun';
                            }
                          },
                        ),
                        leftTitles: SideTitles(
                          showTitles: true,
                          textStyle: TextStyle(
                              color: const Color(0xff7589a2),
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                          margin: 32,
                          reservedSize: 14,
                          getTitles: (value) {
                            if (value == 0) {
                              return '1K';
                            } else if (value == 5) {
                              return '5K';
                            } else if (value == 10) {
                              return '10K';
                            } else if (value == 15) {
                              return '15K';
                            } else if (value == 20) {
                              return '20K';
                            } else {
                              return '';
                            }
                          },
                        ),
                      ),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      barGroups: showingBarGroups,
                    )),
                  ),
                ),
              ),
              SizedBox(
                height: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
            title: Center(
                child: new Text(
              'Dashboard',
              style: TextStyle(
                fontSize: 20,
              ),
            )),
            centerTitle: true,
            actions: <Widget>[
              PopupMenuButton<String>(
                icon: Icon(Icons.track_changes),
                padding: EdgeInsets.fromLTRB(0, 5, 5, 0),
                onSelected: menuchoiceoption,
                itemBuilder: (BuildContext context) {
                  return Constants.choices.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
              )
            ]),
        body: Material(
          color: Color.fromRGBO(58, 66, 86, 1.0),
          child: StaggeredGridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
            padding: EdgeInsets.symmetric(horizontal: 7, vertical: 7),
            children: <Widget>[
              balanceGrid(Icons.attach_money, "Wallet Balance", "5000", 80),
              balanceGrid(Icons.attach_money, "Weekly Limit", "600", 40),
              balanceGrid(Icons.attach_money, "Monthly Limit", "2500", 40),
              chartsGrid(),
            ],
            staggeredTiles: [
              StaggeredTile.extent(2, 140),
              StaggeredTile.extent(1, 100),
              StaggeredTile.extent(1, 100),
              StaggeredTile.extent(2, 500),
            ],
          ),
        ));
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(barsSpace: 4, x: x, barRods: [
      BarChartRodData(
        y: y1,
        color: leftBarColor,
        width: width,
        isRound: true,
      ),
      BarChartRodData(
        y: y2,
        color: rightBarColor,
        width: width,
        isRound: true,
      ),
    ]);
  }

  Widget makeTransactionsIcon() {
    double width = 4.5;
    double space = 3.5;
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
        SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 42,
          color: Colors.white.withOpacity(1),
        ),
        SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
      ],
    );
  }
}
