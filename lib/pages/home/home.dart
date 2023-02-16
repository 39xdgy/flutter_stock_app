import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:fortune_cookie/models/user.dart';
import 'package:intl/intl.dart';
import 'stock_datail_page.dart';
import 'package:http/http.dart' as http;
import 'stock_datail_page.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  String _ticker = '';
  List<Map<String, dynamic>> _timePriceData = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fortune Cookie'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Text(
                'Welcome to Fortune Cookie!',
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ),
            // Container(
            //   padding: const EdgeInsets.all(16.0),
            //   height: 200,
            //   width: 400,
            //   child: LineChart(
            //     LineChartData(
            //       lineTouchData: LineTouchData(
            //         enabled: false,
            //       ),
            //       gridData: FlGridData(
            //         show: false,
            //       ),
            //       titlesData: FlTitlesData(
            //         bottomTitles: AxisTitles(
            //           sideTitles: SideTitles(
            //             showTitles: true,
            //             reservedSize: 22,
            //             getTitlesWidget: (value, meta) {
            //               print(value);
            //               return Text(
            //                 value.toString(),
            //               );
            //             },
            //           ),
            //         ),
            //         leftTitles: AxisTitles(
            //           sideTitles: SideTitles(
            //             showTitles: true,
            //             reservedSize: 22,
            //             getTitlesWidget: (value, meta) {
            //               return Text(
            //                 value.toString(),
            //               );
            //             },
            //           ),
            //         ),
            //       ),
            //       borderData: FlBorderData(
            //         show: true,
            //       ),
            //       minX: 0,
            //       maxX: 10,
            //       minY: 0,
            //       maxY: 11,
            //       lineBarsData: [
            //         LineChartBarData(
            //           spots: [
            //             FlSpot(0, 0),
            //             FlSpot(1, 1),
            //             FlSpot(2, 4),
            //             FlSpot(3, 5),
            //             FlSpot(4, 7),
            //             FlSpot(5, 8),
            //             //FlSpot(6, 8),
            //             //FlSpot(7, 8),
            //             FlSpot(8, 11),
            //             FlSpot(9, 9),
            //             FlSpot(10, 10),
            //           ],
            //           isCurved: true,
            //           barWidth: 5,
            //           isStrokeCapRound: true,
            //           dotData: FlDotData(
            //             show: false,
            //           ),
            //           belowBarData: BarAreaData(
            //             show: true,
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            Container(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                style: TextStyle(color: Colors.white, fontSize: 22),
                decoration: InputDecoration(
                  labelStyle: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                  labelText: 'Ticker',
                ),
                onChanged: (value) {
                  setState(() {
                    _ticker = value;
                  });
                },
              ),
            ),
            ElevatedButton(
              child: Text('Search'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StockWidget(ticker: _ticker),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
