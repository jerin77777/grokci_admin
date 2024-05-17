import 'dart:io' as io;

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';

import '../backend/server.dart';
import '../types.dart';
import '../widgets.dart';

Future<void> manageCategory(BuildContext context, {String? categoryId, String? categoryName}) async {
  TextEditingController _categoryName = TextEditingController();
  if (categoryName != null) {
    _categoryName.text = categoryName;
  }

  await showDialog(
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
                  controller: _categoryName,
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
                      onPress: () async {
                        Map data = {"categoryName": _categoryName.text};
                        if (categoryId == null) {
                          await db.createDocument(
                              databaseId: AppConfig.database,
                              collectionId: AppConfig.categories,
                              documentId: Uuid().v4(),
                              data: data);
                        } else {
                          await db.updateDocument(
                              databaseId: AppConfig.database,
                              collectionId: AppConfig.categories,
                              documentId: categoryId,
                              data: data);
                        }

                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ));
}

Future<void> manageProduct(context, {Map? product}) async {
  int page = 0;
  String expiry = "";
  TextEditingController _productName = TextEditingController(text: product?["name"]);
  TextEditingController _originalPrice = TextEditingController(text: product?["originalPrice"].toString());
  TextEditingController _sellingPrice = TextEditingController(text: product?["sellingPrice"].toString());
  TextEditingController _discountPercentage = TextEditingController(text: product?["discountPercentage"].toString());
  // double _originalPrice = 0;
  // double _sellingPrice = 0;
  // int _discountPercentage = 0;
  TextEditingController _priceDescription = TextEditingController(text: product?["priceDescription"]);
  TextEditingController _ingredients = TextEditingController(text: product?["ingredients"]);
  TextEditingController _netContent = TextEditingController(text: product?["netContent"]);
  TextEditingController _manufacturer = TextEditingController(text: product?["manufacturer"]);
  TextEditingController _fassai = TextEditingController(text: product?["fassai"]);
  TextEditingController _eanCode = TextEditingController(text: product?["eanCode"]);
  TextEditingController _about = TextEditingController(text: product?["about"]);
  TextEditingController _stockQuantity = TextEditingController(text: product?["stockQuantity"].toString());
  PlatformFile? image;
  List changes = [];
  String error = "";

  String _imageId = "";
  // String _categoryId = TextEditingController();

  await showDialog(
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
                            onType: (value) {
                              changes = safeAdd("name", value, "string", changes);
                              error = "";
                              refreshSink.add("");
                            },
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
                                  onType: (value) {
                                    changes = safeAdd("originalPrice", value, "double", changes);
                                    error = "";
                                    refreshSink.add("");
                                  },
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
                                  onType: (value) {
                                    changes = safeAdd("sellingPrice", value, "double", changes);
                                    error = "";
                                    refreshSink.add("");
                                  },
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
                                    controller: _stockQuantity,
                                    type: "int",
                                    onType: (value) {
                                      changes = safeAdd("stockQuantity", value, "int", changes);
                                      error = "";
                                      refreshSink.add("");
                                    },
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
                                    onType: (value) {
                                      changes = safeAdd("discountPercentage", value, "int", changes);
                                      error = "";
                                      refreshSink.add("");
                                    },
                                  ),
                                ],
                              )),
                            ],
                          ),
                          SizedBox(height: 5),
                          Text("Price Description"),
                          SizedBox(height: 5),
                          TextBox(
                            controller: _priceDescription,
                            maxLines: 3,
                            type: "string",
                            onType: (value) {
                              changes = safeAdd("priceDescription", value, "string", changes);
                              error = "";
                              refreshSink.add("");
                            },
                          ),
                        ] else if (page == 1) ...[
                          Text("Product description"),
                          SizedBox(height: 5),
                          TextBox(
                            controller: _about,
                            maxLines: 5,
                            type: "string",
                            onType: (value) {
                              changes = safeAdd("about", value, "string", changes);
                              error = "";
                              refreshSink.add("");
                            },
                          ),
                          SizedBox(height: 5),
                          Text("Expiry Date"),
                          SizedBox(height: 5),
                          InkWell(
                            onTap: () {
                              showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(DateTime.now().year),
                                lastDate: DateTime(2025),
                              ).then((value) {
                                print(value);
                                expiry = value.toString().split(" ")[0];
                                error = "";
                                refreshSink.add("");
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                              decoration: BoxDecoration(color: Pallet.inner1, borderRadius: BorderRadius.circular(10)),
                              child: Text(expiry.isEmpty ? "pick" : expiry),
                            ),
                          ),
                          SizedBox(height: 5),
                          Text("Ingredients"),
                          SizedBox(height: 5),
                          TextBox(
                            controller: _ingredients,
                            // onType: (value) {},
                            maxLines: 3,
                            type: "string",
                            onType: (value) {
                              changes = safeAdd("ingredients", value, "string", changes);
                              error = "";
                              refreshSink.add("");
                            },
                          ),
                          SizedBox(height: 5),
                          Text("Net Content"),
                          SizedBox(height: 5),
                          TextBox(
                            controller: _netContent,
                            type: "string",
                            onType: (value) {
                              changes = safeAdd("netContent", value, "string", changes);
                              error = "";
                              refreshSink.add("");
                            },
                          ),
                          SizedBox(height: 5),
                          Text("Manufacturer"),
                          SizedBox(height: 5),
                          TextBox(
                            controller: _manufacturer,
                            type: "string",
                            onType: (value) {
                              changes = safeAdd("manufacturer", value, "string", changes);
                              error = "";
                              refreshSink.add("");
                            },
                          ),
                          SizedBox(height: 5),
                        ] else if (page == 2) ...[
                          Text("Image"),
                          SizedBox(height: 5),
                          if (image == null)
                            InkWell(
                              onTap: () async {
                                FilePickerResult? result = await FilePicker.platform.pickFiles();

                                if (result != null) {
                                  image = result.files.first;
                                } else {
                                  // User canceled the picker
                                }
                                error = "";
                                refreshSink.add("");
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
                            )
                          else
                            ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.memory(image!.bytes!, height: 200, width: 200, fit: BoxFit.cover)),
                          SizedBox(height: 5),
                          Text("Fassai"),
                          SizedBox(height: 5),
                          TextBox(
                            controller: _fassai,
                            type: "string",
                            onType: (value) {
                              safeAdd("fassai", value, "string", changes);
                              error = "";
                              refreshSink.add("");
                            },
                          ),
                          SizedBox(height: 5),
                          Text("eanCode"),
                          SizedBox(height: 5),
                          TextBox(
                            controller: _eanCode,
                            type: "string",
                            onType: (value) {
                              safeAdd("eanCode", value, "string", changes);
                              error = "";
                              refreshSink.add("");
                            },
                          ),
                        ],
                        if (error.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: SizedBox(
                              width: 250,
                              child: Text(
                                error,
                                style: TextStyle(color: Colors.red, fontSize: 12),
                              ),
                            ),
                          ),
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
                              onPress: () async {
                                if (page >= 2) {
                                  Map data = {};
                                  for (var change in changes) {
                                    if (change["type"] == "double") {
                                      // print(value);
                                      data[change["key"]] = double.parse(change["value"].toString());
                                      // print("${key} ${value}");
                                    } else if (change["type"] == "int") {
                                      data[change["key"]] = int.parse(change["value"].toString());
                                    } else {
                                      data[change["key"]] = change["value"];
                                    }
                                  }
                                  data["categoryId"] = selectedCategory["id"];
                                  print(data);
                                  if (image != null) {
                                    // var _bytes = await image!.readAsBytes();
                                    File _image = await storage.createFile(
                                        bucketId: "65cdfdc7bba4531e45ad",
                                        fileId: ID.unique(),
                                        file: InputFile.fromBytes(
                                            bytes: List<int>.from(image!.bytes!), filename: Uuid().v4()));
                                    data["imageId"] = _image.$id;
                                  }

                                  if (product == null) {
                                    try {
                                      await db.createDocument(
                                          databaseId: AppConfig.database,
                                          collectionId: AppConfig.products,
                                          documentId: Uuid().v4(),
                                          data: data);
                                    } catch (e) {
                                      error = e.toString();
                                      refreshSink.add("");
                                    }
                                  } else {
                                    try {
                                      await db.updateDocument(
                                          databaseId: AppConfig.database,
                                          collectionId: AppConfig.products,
                                          documentId: product["id"],
                                          data: data);
                                    } catch (e) {
                                      error = e.toString();
                                      refreshSink.add("");
                                    }
                                  }
                                  if (error.isEmpty) {
                                    Navigator.pop(context);
                                  }
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

safeAdd(String key, String value, String type, List changes) {
  bool exists = false;
  for (var i = 0; i < changes.length; i++) {
    if (changes[i]["key"] == key) {
      exists = true;
      if (value.trim().isEmpty) {
        changes.removeAt(i);
      } else {
        changes[i]["value"] = value;
      }
    }
  }

  if (!exists) {
    changes.add({"key": key, "value": value, "type": type});
  }
  return changes;
}

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  List categories = [];
  @override
  void initState() {
    getData();

    // TODO: implement initState
    super.initState();
  }

  getData() async {
    categories = await getCategories();
    print(categories);
    setState(() {});
  }

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
                  manageCategory(context).then((value) {
                    getData();
                  });
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
                  for (var category in categories)
                    InkWell(
                      onTap: () {
                        selectedCategory = category;
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
                                    manageCategory(context,
                                            categoryId: category["id"], categoryName: category["categoryName"])
                                        .then((value) {
                                      getData();
                                    });
                                    ;
                                  },
                                  child: Icon(Icons.edit, color: Pallet.font2)),
                              Icon(Icons.delete, color: Pallet.font2),
                            ]),
                            Expanded(
                                child: Center(
                                    child: Text(
                              category["categoryName"],
                              style: TextStyle(fontSize: 20, color: Pallet.font3),
                            ))),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Pallet.primary.withOpacity(0.8)),
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
  const Products({super.key, required this.category});
  final Map category;
  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  List<Map> backup = [];
  List<Map> products = [];
  @override
  void initState() {
    getData();
    // TODO: implement initState
    super.initState();
  }

  getData() async {
    products = await getProducts(1);
    backup = products;
    print(backup);
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
              Text(selectedCategory["categoryName"],
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700, color: Pallet.primary)),
              SizedBox(width: 10),
              SmallButton(
                label: "add",
                onPress: () {
                  manageProduct(context).then((_) {
                    getData();
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 10),
          Container(
            width: 300,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              children: [
                Icon(Icons.search, size: 18),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                      onChanged: (value) {
                        products = [];
                        print(backup);
                        if (value.trim().isEmpty) {
                          products = backup;
                        } else {
                          for (var product in backup) {
                            if (product["name"].toString().toLowerCase().contains(value.toLowerCase())) {
                              products.add(product);
                            }
                          }
                        }

                        setState(() {});
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        hintText: "search",
                        hintStyle: TextStyle(fontSize: 14, color: Pallet.font3),
                        isDense: true,
                        border: InputBorder.none,
                      )),
                ),
              ],
            ),
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
                              children: [
                                Expanded(child: Image.network(getUrl(product["imageId"]))),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product["name"],
                                            style: TextStyle(color: Pallet.font2),
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            "${product["sellingPrice"]} Rs",
                                            style: TextStyle(
                                                color: Pallet.font2, fontWeight: FontWeight.w800, fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    ),
                                    InkWell(
                                        onTap: () {
                                          manageProduct(context, product: product).then((_) {
                                            getData();
                                          });
                                        },
                                        child: Icon(Icons.edit, color: Pallet.font2)),
                                    Icon(Icons.delete, color: Pallet.font2)
                                  ],
                                ),
                                SizedBox(height: 5),
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
