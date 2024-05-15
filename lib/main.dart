import 'package:admin_pannel/screens/promotions.dart';

import 'backend/server.dart';
import 'screens/orders.dart';
import 'types.dart';
import 'screens/drivers.dart';
import 'package:appwrite/appwrite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

import 'screens/products.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // sharedPreferences = await SharedPreferences.getInstance();
  // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  Client client = Client();
  account = Account(client);

  db = Databases(client);
  storage = Storage(client);

  client
          .setEndpoint(AppConfig.endpoint) // Your Appwrite Endpoint
          .setProject(AppConfig.project) // Your project ID
          .setSelfSigned() // Use only on dev mode with a self-signed SSL cert
      ;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    Window.width = MediaQuery.of(context).size.width;
    Window.height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Pallet.background,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.white,
            width: 250,
            child: ListView(
              children: [
                SizedBox(height: 20),
                SvgPicture.asset(
                  width: 100,
                  "assets/logo.svg",
                ),
                SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    routerSink.add("dashboard");
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    child: Row(
                      children: [
                        SizedBox(width: 20),
                        Icon(Icons.dashboard_outlined),
                        SizedBox(width: 10),
                        Text("Dashboard")
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    routerSink.add("categories");
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    child: Row(
                      children: [
                        SizedBox(width: 20),
                        Icon(Icons.shopping_bag_outlined),
                        SizedBox(width: 10),
                        Text("Products")
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    routerSink.add("orders");
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    child: Row(
                      children: [SizedBox(width: 20), Icon(Icons.web_rounded), SizedBox(width: 10), Text("Orders")],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    routerSink.add("drivers");
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    child: Row(
                      children: [
                        SizedBox(width: 20),
                        Icon(Icons.delivery_dining_outlined),
                        SizedBox(width: 10),
                        Text("Drivers")
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    routerSink.add("users");
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    child: Row(
                      children: [
                        SizedBox(width: 20),
                        Icon(Icons.person_outline),
                        SizedBox(width: 10),
                        Text("User Managment")
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    routerSink.add("promotions");
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    child: Row(
                      children: [
                        SizedBox(width: 20),
                        Icon(Icons.present_to_all_outlined),
                        SizedBox(width: 10),
                        Text("Promotion Manageent")
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
              child: StreamBuilder<Object>(
                  initialData: "promotions",
                  stream: routerStream,
                  builder: (context, snapshot) {
                    return Navigator(
                      pages: [
                        if (snapshot.data == "orders")
                          MaterialPage(
                            child: Orders(),
                          )
                        else if (snapshot.data == "categories")
                          MaterialPage(
                            child: Categories(),
                          )
                        else if (snapshot.data == "products")
                          MaterialPage(
                            child: Products(
                              categoryId: 1,
                            ),
                          )
                        else if (snapshot.data == "drivers")
                          MaterialPage(
                            child: Drivers(),
                          )
                           else if (snapshot.data == "promotions")
                          MaterialPage(
                            child: Promotions(),
                          )
                        else
                          MaterialPage(
                            child: Container(
                              child: Center(
                                child: Text("comming soon"),
                              ),
                            ),
                          )
                      ],
                      onPopPage: (route, result) {
                        return true;
                      },
                    );
                  }))
        ],
      ),
    );
  }
}


// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key});

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
