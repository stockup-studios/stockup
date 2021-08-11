import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stockup/models/product.dart';
import 'package:stockup/models/product_category.dart';
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
                          // Summary card header
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                'Hi, Username!', // TODO Use string interpolation for actual username
                                style: TextStyle(
                                  fontSize: 24,
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
                              // TODO Use boolean expression from model
                              child: false
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
                              // TODO Use boolean expression from model
                              child: true
                                  ? Text('You have no expired items! 👍 !!')
                                  : Text('You have ??? expired items!'),
                            ),
                            // TODO Use data from model
                            children: [
                              for (Product p in products)
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
                                  subtitle: Text('Expired ??? days ago'),
                                ),
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
                              // TODO Use boolean expression from model
                              child: true
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
                              // TODO Use boolean expression from model
                              child: true
                                  ? Text('You have no expired items! 🎉 !!')
                                  : Text('You have ??? expired items!'),
                            ),
                            // TODO Use data from model
                            children: [
                              for (Product p in products)
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
                                  subtitle: Text('Expired ??? days ago'),
                                ),
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
                  StackedAreaSeries<ExpiredItemData, DateTime>(
                    dataSource: model.expiredData, // source for series 1
                    xValueMapper: (ExpiredItemData data, _) => data.time,
                    yValueMapper: (ExpiredItemData data, _) => data.amount,
                    name: 'Category 1',
                  ),
                  StackedAreaSeries<ExpiredItemData, DateTime>(
                    dataSource: model.expiredData, // source for series 2
                    xValueMapper: (ExpiredItemData data, _) => data.time,
                    yValueMapper: (ExpiredItemData data, _) => data.amount,
                    name: 'Category 2',
                  ),
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

/// sample products for expansion panel. Replace with actual items
List<Product> products = [
  Product(
      productID: 5021536,
      category: ProductCategory.bakery_cereals_spreads,
      productName: "MISSION WHOLEMEAL PITA 5S",
      imageURL:
          'https://coldstorage-s3.dexecure.net/product/5171374_1528886245740.jpg'),
  Product(
      productID: 5023538,
      category: ProductCategory.bakery_cereals_spreads,
      productName: "KELLOGG'S CRUNCHY NUT OAT GRANOLA CHOCOLATE 380G",
      imageURL: 'https://coldstorage-s3.dexecure.net/product/5023538.jpg'),
  Product(
      productID: 5031528,
      category: ProductCategory.bakery_cereals_spreads,
      productName: "QUAKER 3IN1 OAT CEREAL DRINK - BERRY BLAST 15SX28G",
      imageURL: 'https://coldstorage-s3.dexecure.net/product/5031528.jpg'),
];

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
