import 'package:admin_pannel/backend/server.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../types.dart';
import '../widgets.dart';

Future<void> managePromotion(BuildContext context, {Map? promotion}) async {
  TextEditingController _promoCode = TextEditingController(text: promotion?["promoCode"]);
  String expiry = "";
  TextEditingController _discountPercentage = TextEditingController(text: promotion?["discountPerc"]);

  if (promotion != null) {
    expiry = promotion["expiry"];
  }
  await showDialog(
      context: context,
      builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            backgroundColor: Pallet.background,
            content: StreamBuilder<Object>(
                stream: refreshStream,
                builder: (context, snapshot) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Manage Promo",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(height: 10),
                      Text("Promo Code"),
                      SizedBox(height: 10),
                      TextBox(
                        controller: _promoCode,
                        type: "string",
                      ),
                      SizedBox(height: 10),
                      Text("Discount Percentage"),
                      SizedBox(height: 10),
                      TextBox(
                        controller: _discountPercentage,
                        type: "integer",
                      ),
                      SizedBox(height: 10),
                      Text("Expiry"),
                      SizedBox(height: 10),
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
                            refreshSink.add("");
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                          decoration: BoxDecoration(color: Pallet.inner1, borderRadius: BorderRadius.circular(10)),
                          child: Text(expiry.isEmpty ? "pick" : expiry),
                        ),
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
                              Map data = {
                                "promoCode": _promoCode.text,
                                "discountPerc": int.parse(_discountPercentage.text),
                                "expiry":expiry,
                                "createdAt":DateTime.now().toString().split(" ")[0]
                              };
                              if (promotion == null) {
                                await db.createDocument(
                                    databaseId: AppConfig.database,
                                    collectionId: AppConfig.promotions,
                                    documentId: Uuid().v4(),
                                    data: data);
                              } else {
                                await db.updateDocument(
                                    databaseId: AppConfig.database,
                                    collectionId: AppConfig.promotions,
                                    documentId: promotion["id"],
                                    data: data);
                              }

                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    ],
                  );
                }),
          ));
}

class Promotions extends StatefulWidget {
  const Promotions({super.key});

  @override
  State<Promotions> createState() => _PromotionsState();
}

class _PromotionsState extends State<Promotions> {
  List promotions = [];

  @override
  void initState() {
    getData();
    // TODO: implement initState
    super.initState();
  }

  getData() async {
    promotions = await getPromotions();
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
              Text("Promotions", style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700, color: Pallet.primary)),
              SizedBox(width: 10),
              SmallButton(
                label: "add",
                onPress: () {
                  managePromotion(context).then((value) {
                    getData();
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Expanded(child: Text("Promotion Id")),
                SizedBox(width: 10),
                Expanded(child: Text("Discount")),
                SizedBox(width: 10),
                Expanded(child: Text("Expiry")),
                SizedBox(width: 10),
                Expanded(child: Text("Active")),
              ],
            ),
          ),
          SizedBox(height: 5),
          Expanded(
              child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: ListView(
              children: [
                for (var promotion in promotions)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      children: [
                        Expanded(child: Text(promotion["promoCode"].toString())),
                        SizedBox(width: 10),
                        Expanded(child: Text(promotion["discountPerc"].toString())),
                        SizedBox(width: 10),
                        Expanded(child: Text(promotion["expiry"].toString())),
                        SizedBox(width: 10),
                        Expanded(child: Text(promotion["active"].toString())),
                      ],
                    ),
                  ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
