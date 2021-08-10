import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:stacked/stacked.dart';
import 'package:stockup/ui/components/bottom_navigation/bottom_navigation.dart';
import 'package:stockup/ui/user_home/user_home_view_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class UserHomeView extends StatelessWidget {
  static const int index = 0;
  const UserHomeView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UserHomeViewModel>.reactive(
      disposeViewModel: false,
      initialiseSpecialViewModelsOnce: true,
      onModelReady: (model) => model.init(),
      fireOnModelReadyOnce: true,
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text('Home'),
          centerTitle: true,
        ),
        body: ListView(
          children: [
            if (model.expiredItems.length > 0)
              SummaryTile(
                title: model.expiredTitleMessage,
                details: model.expiredDetailMessage,
                leftColor: Colors.red,
                rightColor: Colors.redAccent,
                onTap: model.viewItems,
              )
            else if (model.expiredItems.length == 0)
              SummaryTile(
                title: 'You have no expired items',
                details: ['Keep it up!'],
                leftColor: Colors.lightGreen,
                rightColor: Colors.green,
                onTap: () {},
              ),
            if (model.expiringItems.length > 0)
              SummaryTile(
                // TODO: Replace with expiring soon details from model (remember to send top 5 only)
                title: model.expiringTitleMessage,
                details: model.expiringDetailMessage,
                leftColor: Colors.orange,
                rightColor: Colors.orangeAccent,
                onTap: model.viewItems,
              )
            else
              SummaryTile(
                title: "You don't have any items expiring soon",
                details: ['You can relax'],
                leftColor: Colors.lightGreen,
                rightColor: Colors.green,
                onTap: () {},
              ),
            if (model.totalItems == 0)
              SummaryTile(
                title: 'Your personal list is empty',
                details: ["Let's scan some items!"],
                leftColor: Colors.lightGreen,
                rightColor: Colors.green,
                onTap: model.add,
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SfCartesianChart(
                    title: ChartTitle(
                      text: 'Food Wastage',
                      // textStyle: TextStyle(color: Colors.white),
                    ),
                    tooltipBehavior: TooltipBehavior(
                      enable: true,
                      // textStyle: TextStyle(color: Colors.white),
                    ),
                    primaryXAxis: CategoryAxis(),
                    series: <LineSeries<dynamic, String>>[
                      LineSeries<dynamic, String>(
                        name: 'Expired items',
                        dataSource: model.expiredData,
                        xValueMapper: (dynamic data, _) =>
                            intl.DateFormat('dd MMM').format(data.time),
                        yValueMapper: (dynamic data, _) => data.amount,
                      )
                    ],
                  ),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[Colors.grey.shade300, Colors.grey.shade300],
                  ),
                ),
              ),
            ),
            Card(
              child: SfCircularChart(
                title: ChartTitle(
                  text: 'Food Wastage by Category',
                  // textStyle: const TextStyle(fontSize: 20),
                ),
                legend: Legend(
                  isVisible: true,
                  overflowMode: LegendItemOverflowMode.wrap,
                  position: LegendPosition.bottom,
                ),
                series: <CircularSeries>[
                  DoughnutSeries<DoughnutData, String>(
                    dataSource: getDoughnutData(),
                    xValueMapper: (DoughnutData data, _) => data.category,
                    yValueMapper: (DoughnutData data, _) => data.amount,
                    dataLabelSettings: DataLabelSettings(
                      isVisible: true,
                      labelPosition: ChartDataLabelPosition.outside,
                    ),
                  ),
                ],
                tooltipBehavior: TooltipBehavior(enable: true),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FractionallySizedBox(
                widthFactor: 0.9,
                child: OutlinedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red)),
                  child: Text(
                    'Logout',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    model.signOut();
                  },
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigation(currentIndex: 0),
      ),
      viewModelBuilder: () => UserHomeViewModel(),
    );
  }
}

/// Data source for SF Circular Chart
List<DoughnutData> getDoughnutData() {
  final List<DoughnutData> data = [
    DoughnutData('Category 1', 1),
    DoughnutData('Category 2', 2),
    DoughnutData('Category 3', 3),
  ];
  return data;
}

/// Data type for SF Circular Chart
class DoughnutData {
  final String category;
  final int amount;

  DoughnutData(this.category, this.amount);
}

class SummaryTile extends StatelessWidget {
  const SummaryTile({
    Key key,
    @required this.title,
    @required this.details,
    @required this.leftColor,
    @required this.rightColor,
    @required this.onTap,
  }) : super(key: key);

  final String title;
  final List<String> details;
  final Color leftColor;
  final Color rightColor;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            title: Text(
              this.title,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8, left: 4, bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (String detail in this.details)
                    Text(
                      detail,
                      style: TextStyle(color: Colors.white),
                    ),
                ],
              ),
            ),
            onTap: this.onTap,
          ),
        ),
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(10),
        // ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              this.leftColor,
              this.rightColor,
            ],
          ),
        ),
      ),
    );
  }
}

class HomeTile extends StatelessWidget {
  final colorLeft;
  final colorRight;
  final List<String> text;

  const HomeTile({
    Key key,
    @required this.colorLeft,
    @required this.colorRight,
    @required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.only(top: 10, right: 15, bottom: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorLeft,
              colorRight,
            ],
          ),
        ),
        child: ListTile(
          title: Text(
            text[0],
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 40,
              color: Colors.white,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (String detail in text.sublist(1))
                Text(
                  detail,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
