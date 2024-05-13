import 'package:admin_pannel/backend/server.dart';
import 'package:flutter/material.dart';

import 'types.dart';

class Drivers extends StatefulWidget {
  const Drivers({super.key});

  @override
  State<Drivers> createState() => _DriversState();
}

class _DriversState extends State<Drivers> {
  List drivers = [];
  @override
  void initState() {
     getData() ;
    // TODO: implement initState
    super.initState();
  }

  getData() async {
    drivers = await getDrivers();
    print(drivers);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Drivers", style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700, color: Pallet.primary)),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Expanded(child: Text("User Name")),
                SizedBox(width: 10),
                Expanded(child: Text("Status")),
                SizedBox(width: 10),
                Expanded(child: Text("Age")),
                SizedBox(width: 10),
                Expanded(child: Text("Docs")),
                SizedBox(width: 10),
                Expanded(child: Text("Phone")),
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
                for (var driver in drivers)
                  Row(
                    children: [
                      Expanded(child: Text(driver["userName"])),
                      SizedBox(width: 10),
                      Expanded(child: Text(driver["adminApproved"].toString())),
                      SizedBox(width: 10),
                      Expanded(child: Text(driver["age"].toString())),
                      SizedBox(width: 10),
                      Expanded(child: Text(driver["userName"].toString())),
                      SizedBox(width: 10),
                      Expanded(child: Text(driver["phoneNumber"].toString())),
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
