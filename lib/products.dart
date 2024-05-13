import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import 'backend/server.dart';
import 'types.dart';
import 'widgets.dart';

manageCategory(BuildContext context, {String? categoryName}) {
  TextEditingController name = TextEditingController();
  if (categoryName != null) {
    name.text = categoryName;
  }

  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            backgroundColor: Pallet.background,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Manage Category",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 10),
                Text("Category Name"),
                SizedBox(height: 10),
                TextBox(
                  controller: name,
                  type: "string",
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SmallButton(
                      label: "Cancel",
                      onPress: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    SizedBox(width: 10),
                    SmallButton(
                      label: "Done",
                      onPress: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ));
}

manageProduct(context,
    {String? productName,
    double? originalPrice,
    double? sellingPrice,
    int? discountPercentage,
    String? priceDescription,
    String? ingredients,
    String? netContent,
    String? manufacturer,
    DateTime? expiryDate,
    String? fssai,
    String? eanCode,
    String? about,
    int? stockQuantity,
    String? imageId,
    String? categoryId}) {
  int page = 0;
  TextEditingController _productName = TextEditingController();
  TextEditingController _originalPrice = TextEditingController();
  TextEditingController _sellingPrice = TextEditingController();
  TextEditingController _discountPercentage = TextEditingController();
  // double _originalPrice = 0;
  // double _sellingPrice = 0;
  // int _discountPercentage = 0;
  TextEditingController _priceDescription = TextEditingController();
  TextEditingController _ingredients = TextEditingController();
  TextEditingController _netContent = TextEditingController();
  TextEditingController _manufacturer = TextEditingController();
  TextEditingController _fassai = TextEditingController();
  TextEditingController _eanCode = TextEditingController();
  TextEditingController _about = TextEditingController();
  TextEditingController _stockQuantity = TextEditingController();

  String _imageId = "";
  // String _categoryId = TextEditingController();

  if (productName != null) {
    _productName.text = productName;
  }

  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            backgroundColor: Pallet.background,
            content: StreamBuilder<Object>(
                stream: refreshStream,
                builder: (context, snapshot) {
                  return SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Manage Product",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                        SizedBox(height: 5),
                        if (page == 0) ...[
                          Text("Product Name"),
                          SizedBox(height: 5),
                          TextBox(
                            controller: _productName,
                            type: "string",
                          ),
                          SizedBox(height: 5),
                          Row(children: [
                            Expanded(
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text("Orginal Price"),
                                SizedBox(height: 5),
                                TextBox(
                                  controller: _originalPrice,
                                  type: "double",
                                ),
                              ]),
                            ),
                            SizedBox(width: 5),
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Selling Price"),
                                SizedBox(height: 5),
                                TextBox(
                                  controller: _sellingPrice,
                                  type: "double",
                                ),
                              ],
                            ))
                          ]),
                          Row(
                            children: [
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Stock Quantity"),
                                  SizedBox(height: 5),
                                  TextBox(
                                    controller: _discountPercentage,
                                    type: "int",
                                  ),
                                ],
                              )),
                              SizedBox(width: 5),
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Discount"),
                                  SizedBox(height: 5),
                                  TextBox(
                                    controller: _discountPercentage,
                                    type: "int",
                                  ),
                                ],
                              )),
                            ],
                          ),
                          SizedBox(height: 5),
                          Text("Price Description"),
                          SizedBox(height: 5),
                          TextBox(
                            controller: _discountPercentage,
                            maxLines: 3,
                            type: "string",
                          ),
                        ] else if (page == 1) ...[
                          Text("Product description"),
                          SizedBox(height: 5),
                          TextBox(
                            controller: _about,
                            maxLines: 5,
                            type: "string",
                          ),
                          SizedBox(height: 5),
                          Text("Epiry Date"),
                          SizedBox(height: 5),
                          TextBox(
                            controller: _discountPercentage,
                            type: "string",
                          ),
                          SizedBox(height: 5),
                          Text("Ingredients"),
                          SizedBox(height: 5),
                          TextBox(
                            controller: _ingredients,
                            maxLines: 3,
                            type: "string",
                          ),
                          SizedBox(height: 5),
                          Text("Net Content"),
                          SizedBox(height: 5),
                          TextBox(
                            controller: _netContent,
                            type: "string",
                          ),
                          SizedBox(height: 5),
                          Text("Manufacturer"),
                          SizedBox(height: 5),
                          TextBox(
                            controller: _manufacturer,
                            type: "string",
                          ),
                          SizedBox(height: 5),
                        ] else if (page == 2) ...[
                          Text("Image"),
                          SizedBox(height: 5),
                          InkWell(
                            onTap: () async {
                              FilePickerResult? result = await FilePicker.platform.pickFiles();

                              if (result != null) {
                                File file = File(result.files.single.path!);
                              } else {
                                // User canceled the picker
                              }
                            },
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                  color: Pallet.inner1,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Pallet.primary)),
                              child: Center(
                                child: Text(
                                  "Add Image",
                                  style: TextStyle(color: Pallet.primary),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Text("Fassai"),
                          SizedBox(height: 5),
                          TextBox(
                            controller: _manufacturer,
                            type: "string",
                          ),
                          SizedBox(height: 5),
                          Text("eanCode"),
                          SizedBox(height: 5),
                          TextBox(
                            controller: _manufacturer,
                            type: "string",
                          ),
                        ],
                        SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SmallButton(
                              label: (page == 0) ? "Cancel" : "Back",
                              onPress: () {
                                if (page == 0) {
                                  Navigator.of(context).pop();
                                } else {
                                  page--;
                                  refreshSink.add("");
                                }
                              },
                            ),
                            SizedBox(width: 10),
                            SmallButton(
                              label: (page >= 2) ? "Done" : "Next",
                              onPress: () {
                                if (page >= 2) {
                                  Navigator.of(context).pop();
                                } else {
                                  page++;
                                  refreshSink.add("");
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
          ));
}

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text("Categories", style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700, color: Pallet.primary)),
              SizedBox(width: 10),
              SmallButton(
                label: "add",
                onPress: () {
                  manageCategory(context);
                },
              ),
            ],
          ),
          SizedBox(height: 10),
          Expanded(
            child: GridView.count(
                primary: false,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 6,
                childAspectRatio: 1,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      routerSink.add("products");
                    },
                    child: Container(
                      width: 100,
                      height: 100,
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(color: Pallet.shadow, offset: const Offset(1, 1), blurRadius: 5, spreadRadius: 2),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                            InkWell(
                                onTap: () {
                                  manageCategory(context, categoryName: "fruits");
                                },
                                child: Icon(Icons.edit)),
                            Icon(Icons.delete),
                          ]),
                          Expanded(
                              child: Center(
                                  child: Text(
                            "Fruits",
                            style: TextStyle(fontSize: 16),
                          ))),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10), color: Pallet.primary.withOpacity(0.8)),
                                  child: Text(
                                    "2 products",
                                    style: TextStyle(fontSize: 12, color: Colors.white),
                                  ))
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ]),
          ),
        ],
      ),
    );
  }
}

class Products extends StatefulWidget {
  const Products({super.key, required this.categoryId});
  final int categoryId;
  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  List<Map> products = [];
  @override
  void initState() {
    getData();
    // TODO: implement initState
    super.initState();
  }

  getData() async {
    products = await getProducts(1);
    print(products);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text("Products", style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700, color: Pallet.primary)),
              SizedBox(width: 10),
              SmallButton(
                label: "add",
                onPress: () {
                  manageProduct(context);
                },
              ),
            ],
          ),
          SizedBox(height: 10),
          Expanded(
            child: GridView.count(
                primary: false,
                // padding: const EdgeInsets.all(20),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 6,
                childAspectRatio: 0.8,
                children: <Widget>[
                  for (var product in products)
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(color: Pallet.shadow, offset: const Offset(1, 1), blurRadius: 5, spreadRadius: 2),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image.network(getUrl(product["imageId"])),
                                Text(product["name"]),
                                Text(
                                  "${product["sellingPrice"]} Rs",
                                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                ]),
          ),
        ],
      ),
    );
  }
}
