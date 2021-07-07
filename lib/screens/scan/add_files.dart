import 'package:flutter/material.dart';
import 'package:stockup/models/product.dart';
import 'package:stockup/models/product_catalog/product_catalog.dart';
import 'package:stockup/services/parser/parser.dart';
import 'package:stockup/services/scanner/scanner.dart';
import 'package:stockup/ui/components/bottom_navigation/bottom_navigation.dart';

class AddFilesScreen extends StatefulWidget {
  static const String id = 'add_files_screen';
  static const int index = 2;
  final String title = 'Add Files';

  @override
  _AddFilesScreenState createState() => _AddFilesScreenState();
}

class _AddFilesScreenState extends State<AddFilesScreen> {
  List<Product> productsFound = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Center(
          child: Text(
            widget.title,
          ),
        ),
      ),
      body: Container(
        color: Colors.grey.shade200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                ),
                child: Text('Pick image from storage'),
                onPressed: () async {
                  String imageFile = await Scanner.getImageFilePath();
                  List<String> text =
                      await Scanner.getTextFromImageFile(imageFile);
                  List<String> matches = Parser.getBestMatches(text);
                  List<Product> productMatches = [];
                  for (String match in matches) {
                    print(match);
                    Product p = productCatalog
                        .firstWhere((product) => product.productName == match);
                    productMatches.add(p);
                  }
                  matches.forEach((String productName) {
                    productCatalog.firstWhere(
                        (product) => product.productName == productName);
                  });
                  setState(() {
                    productsFound.addAll(productMatches);
                  });
                },
              ),
              ElevatedButton(
                child: Text('Pick multiple images from storage'),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue.shade700),
                ),
                onPressed: () async {
                  List<Product> productMatches = [];
                  List<String> imageFiles = await Scanner.getImageFilePaths();
                  for (String imageFile in imageFiles) {
                    List<String> text =
                        await Scanner.getTextFromImageFile(imageFile);
                    List<String> matches = Parser.getBestMatches(text);
                    for (String match in matches) {
                      print(match);
                      Product p = productCatalog.firstWhere(
                          (product) => product.productName == match);
                      productMatches.add(p);
                    }
                    matches.forEach((String productName) {
                      productCatalog.firstWhere(
                          (product) => product.productName == productName);
                    });
                  }
                  setState(() {
                    productsFound.addAll(productMatches);
                  });
                },
              ),
              Expanded(
                child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: productsFound.length,
                    itemBuilder: (BuildContext context, int index) {
                      Product product = productsFound[index];
                      return ListTile(
                        leading: Image.network(product.imageURL) ??
                            Container(color: Colors.black),
                        title: Text(product.productName),
                        subtitle: Text(product.category
                            .toString()
                            .split('.')
                            .last
                            .split('_')
                            .join(' ')),
                        trailing: Icon(Icons.edit),
                      );
                      // return Container(
                      //   child: Text('${productsFound[index].productName}'),
                      // );
                    }),
              )
            ],
          ),
        ),
      ),
      // TODO: Use BottomSheet to display search results
      bottomNavigationBar: BottomNavigation(currentIndex: AddFilesScreen.index),
    );
  }
}
