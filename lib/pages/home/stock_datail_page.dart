import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:fortune_cookie/themes/stock_theme.dart' as StockTheme;
import 'package:animated_flip_counter/animated_flip_counter.dart';

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
  late Future history;
  String _period = '1d';
  String _interval = '1m';
  final StreamController<double> _priceController = StreamController<double>();
  final StreamController<String> _priceChangeController =
      StreamController<String>();
  final StreamController<String> _priceChangePercentController =
      StreamController<String>();
  double _currPrice = 0.0;
  double _firstPrice = 0.0;
  Color _priceChangeColor = Colors.white;
  IconData _priceChangeIcon = Icons.block;
  String _priceChangeText = "";
  double _maxX = 0;
  Map<int, double> _xAxisLabel = {};
  bool _loading = true;
  bool _touch = false;
  bool _1d = true;
  bool _1w = false;
  bool _1m = false;
  bool _3m = false;
  bool _1y = false;
  bool _5y = false;

  @override
  void initState() {
    //get first price and history first
    _getCurrPrice(widget.ticker);
    history = _getHistory(widget.ticker, _period, _interval);
    //refresh stock price every XX seconds
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (!_touch) {
        setState(() {
          _getCurrPrice(widget.ticker);
        });
        if (_period == '1d') {
          _getHistory(widget.ticker, _period, _interval);
        }
      }
    });

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
      for (int i = 0; i < data['Close'].keys.length; i++) {
        _xAxisLabel[i] = double.parse(data['Close'].keys.elementAt(i));

        double price = data['Close'][data['Close'].keys.elementAt(i)];
        stockData.add(
          FlSpot(i.toDouble(), price),
        );
      }

      //get the first time and price
      String firstTime = data['Close'].keys.first;
      double firstPrice = data['Close'][firstTime];

      //set the price change color
      setState(
        () {
          _spots = stockData;
          _firstPrice = firstPrice;
          //set price change text
          switch (period) {
            case '1d':
              _priceChangeText = "Today";
              break;
            case '5d':
              _priceChangeText = "Past Week";
              break;
            case '1mo':
              _priceChangeText = "Past Month";
              break;
            case '3mo':
              _priceChangeText = "Past 3 Months";
              break;
            case '1y':
              _priceChangeText = "Past Year";
              break;
            case '5y':
              _priceChangeText = "Past 5 Years";
              break;
            default:
              break;
          }
        },
      );
      //calculate price change
      double priceChange = _currPrice - _firstPrice;
      //calculate price change percentage
      double priceChangePercent = priceChange / _firstPrice * 0.01;

      //set dynamic price change text
      if (priceChange < 0) {
        _priceChangeController.add((-1 * priceChange).toStringAsFixed(2));
        _priceChangePercentController
            .add((-1 * priceChangePercent).toStringAsFixed(2));
        _priceChangeColor = StockTheme.priceDecreaseColor;
        _priceChangeIcon = Icons.arrow_drop_down;
      } else {
        _priceChangeController.add(priceChange.toStringAsFixed(2));
        _priceChangePercentController
            .add(priceChangePercent.toStringAsFixed(2));
        _priceChangeColor = StockTheme.priceIncreaseColor;
        _priceChangeIcon = Icons.arrow_drop_up;
      }
      return stockData;
    }
  }

  Future _getCurrPrice(String ticker) async {
    //FocusScope.of(context).requestFocus(FocusNode());
    var response =
        await http.get(Uri.parse('http://10.0.2.2:8000/quote?symbol=$ticker'));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      double currPrice = data['lastPrice'];
      _priceController.add(data['lastPrice']);
      //calculate price change
      double priceChange = currPrice - _firstPrice;
      //calculate price change percentage
      double priceChangePercent = priceChange / _firstPrice * 0.01;

      //set dynamic price change text

      if (priceChange < 0) {
        _priceChangeController.add((-1 * priceChange).toStringAsFixed(2));
        _priceChangePercentController
            .add((-1 * priceChangePercent).toStringAsFixed(2));
        _priceChangeColor = StockTheme.priceDecreaseColor;
        _priceChangeIcon = Icons.arrow_drop_down;
      } else {
        _priceChangeController.add(priceChange.toStringAsFixed(2));
        _priceChangePercentController
            .add(priceChangePercent.toStringAsFixed(2));
        _priceChangeColor = StockTheme.priceIncreaseColor;
        _priceChangeIcon = Icons.arrow_drop_up;
      }

      setState(
        () {
          _currPrice = currPrice;
        },
      );
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
      backgroundColor: StockTheme.screenBackground,
      appBar: AppBar(
        backgroundColor: StockTheme.screenBackground,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            color: _priceChangeColor,
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
              color: _priceChangeColor,
              size: 30,
            ),
            onPressed: () {
              print('Notification IconButton pressed ...');
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
                          fontSize: 22,
                          color: StockTheme.textColor,
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
                          color: StockTheme.textColor,
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(-0.9, 0),
                      child: StreamBuilder<double>(
                        stream: _priceController.stream,
                        builder: (BuildContext context,
                            AsyncSnapshot<double> snapshot) {
                          if (snapshot.hasData) {
                            return AnimatedFlipCounter(
                              prefix: "\$",
                              fractionDigits: 2,
                              value: snapshot.data ?? 0,
                              duration: Duration(milliseconds: 250),
                              textStyle: GoogleFonts.getFont(
                                'Inter',
                                fontWeight: FontWeight.w500,
                                fontSize: 32,
                                color: StockTheme.textColor,
                              ),
                            );
                          } else {
                            return Container();
                          }
                        },
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
                          width: 200,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Color(0x00FFFFFF),
                          ),
                          child: Align(
                            alignment: AlignmentDirectional(-1, 0),
                            child: StreamBuilder<String>(
                              stream: _priceChangeController.stream,
                              builder: (BuildContext context,
                                  AsyncSnapshot<String> snapshot) {
                                if (snapshot.hasData) {
                                  double priceChange =
                                      double.parse(snapshot.data!);
                                  double percent =
                                      100 * priceChange / _firstPrice;
                                  return Text(
                                      '\$${snapshot.data}(${percent.toStringAsFixed(2)}%)  $_priceChangeText',
                                      style: GoogleFonts.getFont(
                                        'Inter',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                        color: _priceChangeColor,
                                      ));
                                } else {
                                  return Container();
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                child: GestureDetector(
                  //when the user taps the chart, _touch will be set to true, when released, it will be set to false

                  onTapDown: (details) => _touch = true,
                  child: FutureBuilder(
                      future: history,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('Could not load chart');
                        } else {
                          return LineChart(
                            LineChartData(
                              maxX: _period == '1d' ? 390 : null,
                              lineTouchData: LineTouchData(
                                enabled: true,
                                handleBuiltInTouches: true,
                                touchCallback: (lineTouchEvent, touchResponse) {
                                  //print(lineTouchEvent);
                                  if (lineTouchEvent is FlTapUpEvent ||
                                      lineTouchEvent is FlLongPressEnd ||
                                      lineTouchEvent is FlPanEndEvent) {
                                    // Handle tap up event here
                                    _touch = false;
                                    setState(() {
                                      _getCurrPrice(widget.ticker);
                                    });
                                  }
                                },
                                getTouchedSpotIndicator:
                                    (LineChartBarData barData,
                                        List<int> spotIndexes) {
                                  return spotIndexes.map((spotIndex) {
                                    //touch line style
                                    return TouchedSpotIndicatorData(
                                      FlLine(
                                        color:
                                            _priceChangeColor.withOpacity(0.5),
                                        strokeWidth: 1,
                                      ),
                                      FlDotData(
                                        show: false,
                                      ),
                                    );
                                  }).toList();
                                },
                                touchTooltipData: LineTouchTooltipData(
                                  showOnTopOfTheChartBoxArea: true,
                                  fitInsideHorizontally: true,
                                  getTooltipItems:
                                      // line chart on touch function here
                                      (List<LineBarSpot> touchedBarSpots) {
                                    return touchedBarSpots.map((barSpot) {
                                      final flSpot = barSpot;
                                      var date =
                                          DateTime.fromMillisecondsSinceEpoch(
                                        _xAxisLabel[flSpot.x.toInt()]!.toInt(),
                                      );
                                      DateFormat formatter;
                                      switch (_period) {
                                        case '1d':
                                          formatter =
                                              DateFormat('yyyy-MM-dd HH:mm:ss');
                                          break;
                                        case '1w':
                                          formatter =
                                              DateFormat('yyyy-MM-dd HH:mm:ss');
                                          break;
                                        case '1mo':
                                          formatter =
                                              DateFormat('yyyy-MM-dd HH:mm:ss');
                                          break;
                                        case '3mo':
                                          formatter = DateFormat('yyyy-MM-dd');
                                          break;
                                        case '1y':
                                          formatter = DateFormat('yyyy-MM-dd');
                                          break;
                                        case '5y':
                                          formatter = DateFormat('yyyy-MM-dd');
                                          break;
                                        default:
                                          formatter =
                                              DateFormat('yyyy-MM-dd HH:mm:ss');
                                      }
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                        setState(
                                          () {
                                            if (_touch) {
                                              _priceChangeController.add(
                                                  (flSpot.y - _firstPrice)
                                                      .toStringAsFixed(2));
                                              _priceController.add(flSpot.y);
                                            }
                                          },
                                        );
                                      });
                                      return LineTooltipItem(
                                        formatter.format(date),
                                        TextStyle(
                                          color: StockTheme.textColor
                                              .withOpacity(0.6),
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
                                  //below bar neon effect
                                  shadow: Shadow(
                                    color: _priceChangeColor.withOpacity(0.3),
                                    offset: Offset(0, 8),
                                    blurRadius: 8,
                                  ),
                                  spots: _spots,
                                  gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        _priceChangeColor,
                                        _priceChangeColor,
                                      ]),
                                  barWidth: 2,
                                  isStrokeCapRound: true,
                                  dotData: FlDotData(
                                    show: false,
                                  ),
                                  // line chart below gradient color
                                  belowBarData: BarAreaData(
                                    gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          _priceChangeColor.withOpacity(0.2),
                                          _priceChangeColor.withOpacity(0),
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
                            color:
                                _1d ? _priceChangeColor : StockTheme.textColor,
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
                          color: _1w ? _priceChangeColor : StockTheme.textColor,
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
                          color: _1m ? _priceChangeColor : StockTheme.textColor,
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
                          color: _3m ? _priceChangeColor : StockTheme.textColor,
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
                          color: _1y ? _priceChangeColor : StockTheme.textColor,
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
                          color: _5y ? _priceChangeColor : StockTheme.textColor,
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
