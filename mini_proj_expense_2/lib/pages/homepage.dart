import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mini_proj_expense_2/controllers/db_helper.dart';
import 'package:mini_proj_expense_2/pages/addTransaction.dart';
import 'package:mini_proj_expense_2/pages/allExpense.dart';
import 'package:mini_proj_expense_2/pages/allIncome.dart';
import 'package:mini_proj_expense_2/pages/cardManager.dart';
import 'package:mini_proj_expense_2/pages/search.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DbHelper dbHelper = DbHelper();
  int totalBalance = 0;
  int totalIncome = 0;
  int totalExpense = 0;
  List<FlSpot> dataSet = [];
  DateTime today = DateTime.now();
  double d1 = 0;
  double d2 = 0;
  List<FlSpot> getPlotPoints(Map entireData) {
    dataSet = [];
    entireData.forEach((key, value) {
      if (value['type'] == 'expense' &&
          (value['date'] as DateTime).month == today.month) {
        //d1 = value['date'].toDouble();
        //d2 = value['amount'].toDouble();
        //print("$d1 + $d2");

        dataSet.add(
          FlSpot((value['date'] as DateTime).day.toDouble(),
              value['amount'].toDouble()),
        );
      }
    });
    return dataSet;
  }

  getTotalBalance(Map entireData) {
    totalExpense = 0;
    totalIncome = 0;
    totalBalance = 0;
    entireData.forEach((key, value) {
      //print(value);
      //print("Total Balance $totalBalance");
      //print("Total Expense $totalExpense");
      //print("Total Income $totalIncome");
      if (value['type'] == 'Income') {
        totalBalance += (value['amount'] as int);
        totalIncome += (value['amount'] as int);
      } else if (value['type'] == 'Expense') {
        totalBalance -= (value['amount'] as int);
        totalExpense += (value['amount'] as int);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(24, 24, 24, 1.0),
      appBar: AppBar(toolbarHeight: 0.0),
      body: FutureBuilder<Map>(
        future: dbHelper.fetch(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Unexpected Error"),
            );
          } else if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return Center(
                child: Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(5, 5),
                        color: Colors.black,
                        blurRadius: 20,
                      ),
                      BoxShadow(
                          offset: Offset(-4, -4),
                          color: Color.fromARGB(255, 49, 49, 49),
                          blurRadius: 20)
                    ],
                    color: Color.fromARGB(255, 45, 45, 45),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "Press '+' to add values",
                    style: GoogleFonts.lato(color: Colors.grey, fontSize: 18),
                  ),
                ),
              );
            } else {
              getTotalBalance(snapshot.data!);
              getPlotPoints(snapshot.data!);
              return ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Row(
                              children: [
                                Container(
                                  child: Text(
                                    "Hi There",
                                    style: GoogleFonts.roboto(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    ".",
                                    style: GoogleFonts.roboto(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.deepPurple),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => Search()));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(5, 5),
                                  color: Colors.black,
                                  blurRadius: 20,
                                ),
                                BoxShadow(
                                    offset: Offset(-4, -4),
                                    color: Color.fromARGB(255, 49, 49, 49),
                                    blurRadius: 20)
                              ],
                              color: Color.fromARGB(255, 45, 45, 45),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: EdgeInsets.all(8),
                            child: Icon(
                              Icons.search,
                              size: 28,
                              color: Colors.deepPurple,
                            ),
                            margin: EdgeInsets.only(right: 8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    margin: EdgeInsets.all(12.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 23, 23, 23),
                        boxShadow: [
                          new BoxShadow(
                            color: Color.fromARGB(255, 0, 0, 0),
                            blurRadius: 20.0,
                            offset: Offset(6, 6),
                          ),
                          new BoxShadow(
                            color: Color.fromARGB(255, 36, 36, 36),
                            blurRadius: 20.0,
                            offset: Offset(-6, -6),
                          ),
                        ],
                        borderRadius: BorderRadius.all(Radius.circular(24)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 8),
                        child: Column(
                          children: [
                            Text(
                              "Total Balance",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.roboto(
                                  fontSize: 26,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 6),
                            Text(
                              "Rs. $totalBalance",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 26,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  cardIncome(totalIncome.toString()),
                                  cardExpense(totalExpense.toString()),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  /*const Padding(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      "Expenses",
                      style: TextStyle(
                          fontSize: 32,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  //
                  //
                  //

                  dataSet.length < 2
                      ? Container(
                          margin: EdgeInsets.all(12),
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.4),
                                  spreadRadius: 5,
                                  blurRadius: 6,
                                  offset: Offset(0, 4),
                                )
                              ]),
                          //height: 400,
                          child: Text("Not Enough Data To Plot Chart"),
                        )
                      : Container(
                          margin: EdgeInsets.all(12),
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.4),
                                  spreadRadius: 5,
                                  blurRadius: 6,
                                  offset: Offset(0, 4),
                                )
                              ]),
                          height: 400,
                          child: LineChart(
                            LineChartData(
                                borderData: FlBorderData(show: false),
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: getPlotPoints(snapshot.data!),
                                    isCurved: false,
                                    barWidth: 2.5,
                                    color: Colors.orange,
                                  ),
                                ]),
                          ),
                        ),
                  //
                  //
                  d*/
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(12, 12, 0, 12),
                        child: Text(
                          "Recent",
                          style: GoogleFonts.roboto(
                              fontSize: 32,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 12, 12, 12),
                        child: Text(
                          ".",
                          style: GoogleFonts.roboto(
                              fontSize: 32,
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  ListView.builder(
                      reverse: true,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.length + 1,
                      itemBuilder: (context, index) {
                        dbHelper.compactAll();
                        Map dataAtIndex;
                        try {
                          dataAtIndex = snapshot.data![index];
                        } catch (e) {
                          return Container();
                        }
                        //DateTime date1=dataAtIndex['date'];
                        if (dataAtIndex['amount'] != 0) {
                          if (dataAtIndex['type'] == 'Income')
                            return incomeTile(
                                dataAtIndex['amount'],
                                dataAtIndex['note'],
                                dataAtIndex['date'],
                                dataAtIndex['type'],
                                index);
                          else
                            return expenseTile(
                              dataAtIndex['amount'],
                              dataAtIndex['note'],
                              dataAtIndex['date'],
                              dataAtIndex['type'],
                              index,
                            );
                        } else {
                          return Container();
                        }
                      })
                ],
              );
            }
          } else {
            return Center(
              child: Text("Loading"),
            );
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => AddTransaction()))
              .whenComplete(() {
            setState(() {});
          });
        },
        child: Icon(
          Icons.add,
          size: 32.0,
        ),
      ),
    );
  }

  Widget cardIncome(String value) {
    return InkWell(
      onTap: (() {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => allIncome()));
      }),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  offset: Offset(5, 5),
                  color: Colors.black,
                  blurRadius: 20,
                ),
                BoxShadow(
                    offset: Offset(-4, -4),
                    color: Color.fromARGB(255, 49, 49, 49),
                    blurRadius: 20)
              ],
              color: Color.fromARGB(255, 45, 45, 45),
              borderRadius: BorderRadius.circular(20),
            ),
            padding: EdgeInsets.all(6),
            child: Icon(
              Icons.arrow_downward,
              size: 28,
              color: Colors.green,
            ),
            margin: EdgeInsets.only(right: 8),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Income",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                value,
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget cardExpense(String value) {
    return InkWell(
      onTap: (() {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => AllExpense()));
      }),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "Expense",
                style: GoogleFonts.roboto(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                value,
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  offset: Offset(5, 5),
                  color: Colors.black,
                  blurRadius: 20,
                ),
                BoxShadow(
                    offset: Offset(-4, -4),
                    color: Color.fromARGB(255, 49, 49, 49),
                    blurRadius: 20)
              ],
              color: Color.fromARGB(255, 45, 45, 45),
              borderRadius: BorderRadius.circular(20),
            ),
            padding: EdgeInsets.all(6),
            child: Icon(
              Icons.arrow_upward,
              size: 28,
              color: Colors.red,
            ),
            margin: EdgeInsets.only(left: 8),
          ),
        ],
      ),
    );
  }

  Widget expenseTile(
      int value, String note, DateTime date, String type, int index) {
    print("index $index");
    String formattedDate = DateFormat.yMMMd().format(date);
    return Container(
      margin: EdgeInsets.fromLTRB(8, 12, 8, 12),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            offset: Offset(5, 5),
            color: Colors.black,
            blurRadius: 20,
          ),
          BoxShadow(
              offset: Offset(-4, -4),
              color: Color.fromARGB(255, 49, 49, 49),
              blurRadius: 20)
        ],
        color: Color.fromRGBO(24, 24, 24, 1.0),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.arrow_circle_up_rounded,
                size: 28,
                color: Colors.red,
              ),
              SizedBox(
                width: 4.0,
              ),
              Text(
                "$note",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "$formattedDate",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                    fontWeight: FontWeight.normal),
              ),
            ],
          ),
          Text(
            "-$value",
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
          ),
          IconButton(
              onPressed: () async {
                print("expense tile");
                await dbHelper.deleteOne(index);
                //dbHelper.addData(0, DateTime.now(), "", "");
                dbHelper.addData(0, DateTime.now(), "", "");
                setState(() {});
              },
              icon: Icon(Icons.delete))
        ],
      ),
    );
  }

  Widget incomeTile(
      int value, String note, DateTime date, String type, int index) {
    print("index $index");
    String formattedDate = DateFormat.yMMMd().format(date);
    //container
    return Container(
      margin: EdgeInsets.fromLTRB(8, 12, 8, 12),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Color.fromRGBO(24, 24, 24, 1.0),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            offset: Offset(5, 5),
            color: Colors.black,
            blurRadius: 10,
          ),
          BoxShadow(
              offset: Offset(-4, -4),
              color: Color.fromARGB(255, 49, 49, 49),
              blurRadius: 20)
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(
                Icons.arrow_circle_down_rounded,
                size: 28,
                color: Colors.green,
              ),
              const SizedBox(
                width: 4.0,
              ),
              Text(
                "$note",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "$formattedDate",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                    fontWeight: FontWeight.normal),
              ),
            ],
          ),
          Text(
            "+$value",
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
          ),
          IconButton(
              onPressed: () async {
                print("Income tile");
                await dbHelper.deleteOne(index);
                //dbHelper.addData(0, DateTime.now(), "", "");
                dbHelper.addData(0, DateTime.now(), "", "");
                setState(() {});
              },
              icon: Icon(Icons.delete))
        ],
      ),
    );
  }
}
