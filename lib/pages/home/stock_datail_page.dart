import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class StockWidget extends StatefulWidget {
  var ticker;

  StockWidget({
    super.key,
    required this.ticker,
  });

  @override
  _StockWidgetState createState() => _StockWidgetState();
}

class _StockWidgetState extends State<StockWidget> {
  List<FlSpot> _spots = [];
  late Timer timer;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  late Future priceInit;
  late Future history;
  String _period = '1d';
  String _interval = '1m';
  String price = "";
  String _priceChange = "";
  String _priceChangePercent = "";
  Color _priceChangeColor = Colors.white;
  IconData _priceChangeIcon = Icons.block;
  String _priceChangeText = "";

  bool _1d = true;
  bool _1w = false;
  bool _1m = false;
  bool _3m = false;
  bool _1y = false;
  bool _5y = false;

  @override
  void initState() {
    priceInit = _getPrice(widget.ticker);
    //refresh stock price every XX seconds
    timer = Timer.periodic(Duration(seconds: 30), (_) {
      setState(() {
        priceInit = _getPrice(widget.ticker);
      });
    });
    history = _getHistory(widget.ticker, _period, _interval);
    super.initState();
  }

  Future _getHistory(String ticker, String period, String interval) async {
    //FocusScope.of(context).requestFocus(FocusNode());
    var response = await http.get(Uri.parse(
        'http://10.0.2.2:8000/history?symbol=$ticker&interval=$interval&period=$period'));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      //format the history data to FLchart format
      List<FlSpot> stockData = [];
      for (var time in data['Close'].keys) {
        stockData.add(
          FlSpot(double.parse(time), data['Close'][time]),
        );
      }
      //get the last time and price
      String lastTime = data['Close'].keys.last;
      String currPrice = data['Close'][lastTime].toString();

      //get the first time and price
      String firstTime = data['Close'].keys.first;
      String firstPrice = data['Close'][firstTime].toString();

      //calculate price change
      double priceChange = double.parse(currPrice) - double.parse(firstPrice);

      //calculate price change percentage
      double priceChangePercent =
          (double.parse(currPrice) - double.parse(firstPrice)) /
              double.parse(firstPrice);

      setState(() {
        _spots = stockData;
        //set dynamic price change text
        if (priceChange < 0) {
          _priceChange = (-1 * priceChange).toStringAsFixed(2);
          _priceChangePercent = (-1 * priceChangePercent).toStringAsFixed(2);
          _priceChangeColor = Color.fromARGB(255, 230, 72, 1);
          _priceChangeIcon = Icons.arrow_drop_down;
        } else {
          _priceChange = priceChange.toStringAsFixed(2);
          _priceChangePercent = priceChangePercent.toStringAsFixed(2);
          _priceChangeColor = Color.fromARGB(255, 0, 200, 6);
          _priceChangeIcon = Icons.arrow_drop_up;
        }
      });
      return stockData;
    }
  }

  //get realtime price and set state
  Future _getPrice(String ticker) async {
    //FocusScope.of(context).requestFocus(FocusNode());
    var response = await http.get(Uri.parse(
        'http://10.0.2.2:8000/history?symbol=$ticker&interval=1m&period=1d'));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      //print(data['Close'].keys.last);
      String lastTime = data['Close'].keys.last;
      String currPrice = data['Close'][lastTime].toString();

      setState(() {
        price = double.parse(currPrice).toStringAsFixed(2);
      });
      return currPrice;
    }
  }

  @override
  void dispose() {
    _unfocusNode.dispose();
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            color: Color(0xFFF23333),
            size: 30,
          ),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications_none,
              color: Color(0xFFF23333),
              size: 30,
            ),
            onPressed: () {
              print('IconButton pressed ...');
            },
          ),
        ],
        centerTitle: false,
        elevation: 2,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                height: 16,
              ),
              Container(
                width: 436.5,
                height: 211.4,
                decoration: BoxDecoration(
                  color: Color(0x00FFFFFF),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Align(
                      alignment: AlignmentDirectional(-0.9, 0),
                      child: Text(
                        widget.ticker,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Align(
                      alignment: AlignmentDirectional(-0.9, 0),
                      child: Text(
                        widget.ticker,
                        style: GoogleFonts.getFont(
                          'Inter',
                          fontWeight: FontWeight.w500,
                          fontSize: 32,
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(-0.9, 0),
                      child: Text(
                        '\$$price',
                        style: GoogleFonts.getFont(
                          'Inter',
                          fontWeight: FontWeight.w500,
                          fontSize: 32,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Align(
                          alignment: AlignmentDirectional(0, 0),
                          child: Container(
                            width: 40,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                            ),
                            child: Align(
                              alignment: AlignmentDirectional(0, 0),
                              child: Icon(
                                _priceChangeIcon,
                                color: _priceChangeColor,
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 100,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Color(0x00FFFFFF),
                          ),
                          child: Align(
                            alignment: AlignmentDirectional(-1, 0),
                            child: Text(
                              '\$$_priceChange ($_priceChangePercent%)',
                              style: GoogleFonts.getFont(
                                'Inter',
                                color: _priceChangeColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 60,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Color(0x00FFFFFF),
                          ),
                          child: Align(
                            alignment: AlignmentDirectional(-1, 0),
                            child: Text(
                              'Past week',
                              style: GoogleFonts.getFont(
                                'Inter',
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                child: FutureBuilder(
                    future: history,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Could not load chart');
                      } else {
                        return LineChart(
                          LineChartData(
                            lineTouchData: LineTouchData(
                              getTouchedSpotIndicator:
                                  (LineChartBarData barData,
                                      List<int> spotIndexes) {
                                return spotIndexes.map((spotIndex) {
                                  return TouchedSpotIndicatorData(
                                    FlLine(
                                      color: Color(0xFFF23333).withOpacity(0.2),
                                      strokeWidth: 1,
                                    ),
                                    FlDotData(
                                      show: false,
                                    ),
                                  );
                                }).toList();
                              },
                              touchTooltipData: LineTouchTooltipData(
                                getTooltipItems:
                                    (List<LineBarSpot> touchedBarSpots) {
                                  return touchedBarSpots.map((barSpot) {
                                    final flSpot = barSpot;
                                    if (flSpot.x == 0) {
                                      return LineTooltipItem(
                                        '0',
                                        TextStyle(
                                          color: Color(0xFFF23333),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      );
                                    }
                                    return LineTooltipItem(
                                      '\$${flSpot.y.toStringAsFixed(2)}',
                                      TextStyle(
                                        color: Color(0xFFF23333),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  }).toList();
                                },
                                tooltipBgColor: Colors.transparent,
                              ),
                            ),
                            gridData: FlGridData(show: false),
                            borderData: FlBorderData(show: false),
                            titlesData: FlTitlesData(
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              leftTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                              topTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                              rightTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                            ),
                            lineBarsData: [
                              LineChartBarData(
                                spots: _spots,
                                color: Color(0xFFF23333),
                                barWidth: 2,
                                isStrokeCapRound: true,
                                dotData: FlDotData(
                                  show: false,
                                ),
                                belowBarData: BarAreaData(
                                  gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Color(0xFFF23333).withOpacity(0.1),
                                        Color(0xFFF23333).withOpacity(0),
                                      ]),
                                  show: true,
                                ),
                              )
                            ],
                          ),
                        );
                      }
                    }),
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                width: double.infinity,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _1d = true;
                          _1w = false;
                          _1m = false;
                          _3m = false;
                          _1y = false;
                          _5y = false;
                          _period = '1d';
                          _interval = '1m';
                          history =
                              _getHistory(widget.ticker, _period, _interval);
                        });
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color: Colors.transparent,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Text('1D',
                          style: GoogleFonts.getFont(
                            'Inter',
                            color: _1d
                                ? Color(0xFFF23333)
                                : Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                          )),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _1d = false;
                          _1w = true;
                          _1m = false;
                          _3m = false;
                          _1y = false;
                          _5y = false;
                          _period = '5d';
                          _interval = '5m';
                          history =
                              _getHistory(widget.ticker, _period, _interval);
                        });
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color: Colors.transparent,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Text(
                        '1W',
                        style: GoogleFonts.getFont(
                          'Inter',
                          color: _1w
                              ? Color(0xFFF23333)
                              : Color.fromARGB(255, 0, 0, 0),
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _1d = false;
                          _1w = false;
                          _1m = true;
                          _3m = false;
                          _1y = false;
                          _5y = false;
                          _period = '1mo';
                          _interval = '1h';
                          history =
                              _getHistory(widget.ticker, _period, _interval);
                        });
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color: Colors.transparent,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Text(
                        '1M',
                        style: GoogleFonts.getFont(
                          'Inter',
                          color: _1m
                              ? Color(0xFFF23333)
                              : Color.fromARGB(255, 0, 0, 0),
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _1d = false;
                          _1w = false;
                          _1m = false;
                          _3m = true;
                          _1y = false;
                          _5y = false;
                          _period = '3mo';
                          _interval = '1d';
                          history =
                              _getHistory(widget.ticker, _period, _interval);
                        });
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color: Colors.transparent,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Text(
                        '3M',
                        style: GoogleFonts.getFont(
                          'Inter',
                          color: _3m
                              ? Color(0xFFF23333)
                              : Color.fromARGB(255, 0, 0, 0),
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _1d = false;
                          _1w = false;
                          _1m = false;
                          _3m = false;
                          _1y = true;
                          _5y = false;
                          _period = '1y';
                          _interval = '1d';
                          history =
                              _getHistory(widget.ticker, _period, _interval);
                        });
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color: Colors.transparent,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Text(
                        '1Y',
                        style: GoogleFonts.getFont(
                          'Inter',
                          color: _1y
                              ? Color(0xFFF23333)
                              : Color.fromARGB(255, 0, 0, 0),
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _1d = false;
                          _1w = false;
                          _1m = false;
                          _3m = false;
                          _1y = false;
                          _5y = true;
                          _period = '5y';
                          _interval = '1wk';
                          history =
                              _getHistory(widget.ticker, _period, _interval);
                        });
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color: Colors.transparent,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Text(
                        '5Y',
                        style: GoogleFonts.getFont(
                          'Inter',
                          color: _5y
                              ? Color(0xFFF23333)
                              : Color.fromARGB(255, 0, 0, 0),
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
