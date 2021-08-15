import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stockup/models/models.dart';
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
          actions: [
            PopupMenuButton(
              icon: Icon(Icons.settings),
              itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                PopupMenuItem(
                  child: Container(
                    child: Row(
                      children: [
                        Text('Logout'),
                        IconButton(
                          icon: Icon(
                            Icons.logout,
                            color: Colors.red.shade200,
                          ),
                          onPressed: () {
                            model.signOut();
                          },
                        ),
                      ],
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        body: ListView(
          children: [
            Card(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Container(
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                model.name,
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                'Welcome to StockUP',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          color: Colors.white,
                          child: ExpansionTile(
                            leading: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: model.expiredItems.length == 0
                                  ? Icon(
                                      Icons.check_circle_rounded,
                                      color: Colors.green,
                                    )
                                  : Icon(
                                      Icons.cancel_rounded,
                                      color: Colors.red,
                                    ),
                            ),
                            title: Text(
                              'Expired',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            subtitle: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: model.expiredItems.length == 0
                                  ? Text('You have no expired items! 👍 !!')
                                  : Text(model.expiredTitleMessage),
                            ),
                            children: [
                              for (Product p in model.expiredItems)
                                ListTile(
                                  leading: Image.network(
                                    p.imageURL,
                                    height: 50,
                                    width: 50,
                                    errorBuilder: (BuildContext context,
                                        Object exception,
                                        StackTrace stackTrace) {
                                      return SizedBox(
                                        height: 50,
                                        width: 50,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                    },
                                  ),
                                  title: Text(p.productName),
                                  subtitle: Text(model.expiredDetail(p)),
                                ),
                              if (model.expiredExcess)
                                IconButton(
                                  icon: Icon(
                                    Icons.more_horiz_outlined,
                                  ),
                                  onPressed: () {
                                    model.viewItems();
                                  },
                                )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          color: Colors.white,
                          child: ExpansionTile(
                            leading: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: model.expiringItems.length == 0
                                  ? Icon(
                                      Icons.check_circle_rounded,
                                      color: Colors.green,
                                    )
                                  : Icon(
                                      Icons.cancel_rounded,
                                      color: Colors.red,
                                    ),
                            ),
                            title: Text(
                              'Expiring Soon',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            subtitle: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: model.expiringItems.length == 0
                                  ? Text(
                                      "You don't have any items expiring soon! 🎉!")
                                  : Text(model.expiringTitleMessage),
                            ),
                            children: [
                              for (UserItem p in model.expiringItems)
                                ListTile(
                                  leading: Image.network(
                                    p.imageURL,
                                    height: 50,
                                    width: 50,
                                    errorBuilder: (BuildContext context,
                                        Object exception,
                                        StackTrace stackTrace) {
                                      return SizedBox(
                                        height: 50,
                                        width: 50,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                    },
                                  ),
                                  title: Text(p.productName),
                                  subtitle: Text(model.expiringDetail(p)),
                                ),
                              if (model.expiringExcess)
                                IconButton(
                                  icon: Icon(
                                    Icons.more_horiz_outlined,
                                  ),
                                  onPressed: () {
                                    model.viewItems();
                                  },
                                )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/summary_background.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            if (model.expiredDb != null)
              Card(
                child: SfCartesianChart(
                  title: ChartTitle(
                    text: 'Food Wastage',
                  ),
                  tooltipBehavior: TooltipBehavior(
                    enable: true,
                  ),
                  legend: Legend(
                    isVisible: true,
                    overflowMode: LegendItemOverflowMode.wrap,
                    position: LegendPosition.bottom,
                  ),
                  series: <ChartSeries>[
                    //LineSeries<ExpiredItemData, DateTime>(
                    SplineAreaSeries<ExpiredItemData, DateTime>(
                        dataSource: model.expiredData,
                        xValueMapper: (ExpiredItemData data, _) => data.time,
                        yValueMapper: (ExpiredItemData data, _) => data.amount,
                        isVisibleInLegend: false,
                        name: 'Food Waste',
                        color: Colors.amber[700])
                  ],
                  primaryXAxis: DateTimeAxis(
                    majorGridLines: MajorGridLines(width: 0),
                    axisLine: AxisLine(width: 0),
                  ),
                  primaryYAxis: NumericAxis(
                    majorGridLines: MajorGridLines(width: 0),
                    axisLine: AxisLine(width: 0),
                  ),
                ),
              ),
            if (model.expiredDb != null)
              Card(
                child: SfCircularChart(
                  title: ChartTitle(
                    text: 'Food Wastage by Category',
                  ),
                  legend: Legend(
                    isVisible: true,
                    overflowMode: LegendItemOverflowMode.wrap,
                    position: LegendPosition.bottom,
                  ),
                  series: <CircularSeries>[
                    DoughnutSeries<DoughnutData, String>(
                      dataSource: model.categoryWaste,
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
          ],
        ),
        bottomNavigationBar: BottomNavigation(currentIndex: 0),
      ),
      viewModelBuilder: () => UserHomeViewModel(),
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
