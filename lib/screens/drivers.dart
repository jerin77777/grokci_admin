import 'package:admin_pannel/backend/server.dart';
import 'package:flutter/material.dart';

import '../types.dart';

class Drivers extends StatefulWidget {
  const Drivers({super.key});

  @override
  State<Drivers> createState() => _DriversState();
}

class _DriversState extends State<Drivers> {
  List drivers = [];
  @override
  void initState() {
    getData();
    // TODO: implement initState
    super.initState();
  }

  getData() async {
    drivers = await getDrivers();
    for (var driver in drivers) {
      if (driver["deactivated"] == true) {
        driver["status"] = {"name": "deactivated", "color": Colors.red};
      } else {
        if (driver["adminApproved"] == true) {
          driver["status"] = {"name": "approved", "color": Colors.green};
        } else {
          driver["status"] = {"name": "not approved", "color": Colors.red};
        }
      }
    }

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
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      children: [
                        Expanded(child: Text(driver["userName"])),
                        SizedBox(width: 10),
                        Expanded(
                            child: Row(
                          children: [
                            UpdateStatus(
                              name: driver["status"]["name"],
                              color: driver["status"]["color"],
                              items: [
                                {"name": "deactivate"},
                                {"name": "approve"},
                              ],
                              onTap: (value) async {
                                Map data = {};
                                if (value["name"] == "deactivate") {
                                  data["deactivated"] = true;
                                } else if (value["name"] == "approve") {
                                  data["adminApproved"] = true;
                                }
                                
                                await db.updateDocument(
                                    databaseId: AppConfig.database,
                                    collectionId: AppConfig.drivers,
                                    documentId: driver["id"],
                                    data: data);

                                getData();
                              },
                            )
                            // Container(
                            //     padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                            //     decoration: BoxDecoration(
                            //         color: driver["status"]["color"], borderRadius: BorderRadius.circular(5)),
                            //     child: Text(
                            //       driver["status"]["name"],
                            //       style: TextStyle(color: Colors.white, fontSize: 12),
                            //     )),
                          ],
                        )),
                        SizedBox(width: 10),
                        Expanded(child: Text(driver["age"].toString())),
                        SizedBox(width: 10),
                        Expanded(child: Text(driver["userName"].toString())),
                        SizedBox(width: 10),
                        Expanded(child: Text(driver["phoneNumber"].toString())),
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

class UpdateStatus extends StatefulWidget {
  const UpdateStatus({super.key, required this.name, required this.color, required this.items, required this.onTap});
  final Color color;
  final String name;
  final List items;
  final Function onTap;

  @override
  State<UpdateStatus> createState() => _UpdateStatusState();
}

class _UpdateStatusState extends State<UpdateStatus> {
  bool isOpen = false;
  GlobalKey actionKey = GlobalKey();
  OverlayEntry? dropdown;
  int? hoveredIdx;
  double itemCount = 0;
  double maxItem = 4;
  double height = 0, width = 0, initX = 0, initY = 0;

  OverlayEntry _createDropDown() {
    return OverlayEntry(builder: (context) {
      return GestureDetector(
        onTap: () {
          close();
        },
        child: StreamBuilder<Object>(
            stream: refreshStream,
            builder: (context, snapshot) {
              return Container(
                color: Colors.transparent,
                width: Window.width,
                height: Window.height,
                child: Stack(
                  children: [
                    Positioned(
                      left: initX,
                      width: 100,
                      top: initY,
                      height: 64,
                      child: Material(
                        elevation: 6,
                        color: Colors.transparent,
                        child: Container(
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (var i = 0; i < widget.items.length; i++)
                                MouseRegion(
                                  onHover: (value) {
                                    hoveredIdx = i;
                                    refreshSink.add("");
                                  },
                                  onExit: (value) {
                                    hoveredIdx = null;
                                    refreshSink.add("");
                                  },
                                  child: InkWell(
                                      onTap: () {
                                        widget.onTap(widget.items[i]);
                                        close();
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                        decoration: BoxDecoration(
                                            color: (i == hoveredIdx) ? Pallet.inner1 : Colors.transparent,
                                            border: (widget.items[i]["name"] != widget.items.last["name"])
                                                ? Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.5)))
                                                : null),
                                        child: Row(
                                          children: [
                                            Text(widget.items[i]["name"]),
                                          ],
                                        ),
                                      )),
                                )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
      );
    });
  }

  void getDropDownData() {
    RenderBox renderBox = actionKey.currentContext!.findRenderObject() as RenderBox;
    height = renderBox.size.height;
    width = renderBox.size.width;
    Offset offset = renderBox.localToGlobal(Offset.zero);
    initX = offset.dx - 250;
    initY = offset.dy + height + 10;
  }

  void close() {
    if (isOpen = true) {
      dropdown!.remove();
      isOpen = false;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        getDropDownData();
        dropdown = _createDropDown();
        Overlay.of(context).insert(dropdown!);
        isOpen = true;
      },
      child: Container(
          key: actionKey,
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          decoration: BoxDecoration(color: widget.color, borderRadius: BorderRadius.circular(5)),
          child: Text(
            widget.name,
            style: TextStyle(color: Colors.white, fontSize: 12),
          )),
    );
  }
}
