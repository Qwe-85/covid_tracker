import 'package:covid_tracker/Services/states_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pie_chart/pie_chart.dart';

import '../Model/WorldStatesModel.dart';

class WorldStateScreen extends StatefulWidget {
  const WorldStateScreen({Key? key}) : super(key: key);

  @override
  State<WorldStateScreen> createState() => _WorldStateScreenState();
}

class _WorldStateScreenState extends State<WorldStateScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(duration: const Duration(seconds: 3), vsync: this)
        ..repeat();

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  final colorList = <Color>[
    const Color(0xff4285f4),
    const Color(0xff1aa260),
    const Color(0xffde5246),
  ];

  @override
  Widget build(BuildContext context) {
    StatesServices statesServices = StatesServices();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: FutureBuilder(
            future: statesServices.fetchWorldStatesRecords(),
            builder: (context, AsyncSnapshot<WorldStatesModel> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SpinKitFadingCircle(
                  color: Colors.white,
                  size: 50,
                  controller: _controller,
                );
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                // Render your data here, for example:
                // WorldStatesModel worldStates = snapshot.data!;
                // Then use this model to display data accordingly.
                return Text('Data Loaded');
              } else {
                return Column(
                  children: [
                    PieChart(
                      dataMap: const {
                        "Total": 20,
                        "Recovered": 15,
                        "Deaths": 5,
                      },
                      chartRadius: MediaQuery.of(context).size.width / 3.2,
                      legendOptions: const LegendOptions(
                          legendPosition: LegendPosition.left),
                      animationDuration: const Duration(milliseconds: 1200),
                      chartType: ChartType.ring,
                      colorList: colorList,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height * .06),
                      child: Card(
                        child: Column(
                          children: [
                            ReusableRow(
                              title: 'Total',
                              value: '200',
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xff1aa260),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(child: Text('Track Countries')),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class ReusableRow extends StatelessWidget {
  final String title, value;
  ReusableRow({Key? key, required this.title, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              Text(value),
            ],
          ),
          const SizedBox(height: 5),
          const Divider(),
        ],
      ),
    );
  }
}
