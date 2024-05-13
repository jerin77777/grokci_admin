import 'package:flutter/material.dart';

import 'backend/server.dart';
import 'types.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  List orders = [];
  @override
  void initState() {
    getData();
    // TODO: implement initState
    super.initState();
  }

  getData() async {
    orders = await getOrders();

    print(orders);
    setState(() {});
  }

  getColor(status) {
    if (status == "pending") {
      return Colors.red;
    } else if (status == "picking") {
      return Colors.amber;
    } else if (status == "delivering") {
      return Colors.amber;
    } else {
      return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Orders", style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700, color: Pallet.primary)),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Expanded(child: Text("Order Id")),
                SizedBox(width: 10),
                Expanded(child: Text("User")),
                SizedBox(width: 10),
                Expanded(child: Text("Location")),
                SizedBox(width: 10),
                Expanded(child: Text("Status")),
                SizedBox(width: 10),
                Expanded(child: Text("Amount")),
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
                for (var order in orders)
                  Row(
                    children: [
                      Expanded(child: Text(order["id"])),
                      SizedBox(width: 10),
                      Expanded(child: Text(order["username"])),
                      SizedBox(width: 10),
                      Expanded(child: Text(order["deliveryAddress"])),
                      SizedBox(width: 10),
                      Expanded(
                          child: Row(
                        children: [
                          Container(
                              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(color: getColor(order["orderStatus"]), borderRadius: BorderRadius.circular(5)),
                              child: Text(
                                order["orderStatus"],
                                style: TextStyle(color: Colors.white, fontSize: 12),
                              )),
                        ],
                      )),
                      SizedBox(width: 10),
                      Expanded(child: Text(order["amount"].toString())),
                    ],
                  ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
