// import 'dart:js_interop';

import 'dart:math';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
// import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// import 'package:grokci/globals.dart';
// import 'package:grokci/main.dart';
// import 'package:grokci/screens/login.dart';
// import 'package:twilio_flutter/twilio_flutter.dart';
// import 'package:localstorage/localstorage.dart';
import 'dart:io' as fl;
import 'package:path/path.dart';

late Databases db;
late Account account;
late Storage storage;
late BuildContext mainContext;

// final LocalStorage local = LocalStorage('grokci');

// late TwilioFlutter twilioFlutter;

// delivery states picking, delivering, completed
// order states delivering, delivered, payed
// all database details used from here
class AppConfig {
  static String endpoint = "https://cloud.appwrite.io/v1";
  static String project = "grokci";
  static String database = "6504263e007ff813b432";
  static String orders = "65c9e1dda6e0b52f3463";
  static String products = "650426742ba0530f4ed7";
  static String orderProductMap = "65cf257b2dfaa673e1ad";
  static String drivers = "65ccc7954c7d0de38f77";
  static String categories = "663f1f04001b7ef90642";
  static String warehouses = "65cf4c83826d08f5f8f0";
  static String promotions = "664483050014267591fe";
}

getOrders() async {
  List<Map> result = [];
  DocumentList temp = await db.listDocuments(
    databaseId: AppConfig.database,
    collectionId: AppConfig.orders,
    queries: [Query.limit(50), Query.orderDesc("orderTime")],
  );
  result = getResult(temp.documents);
  return result;
}

getCategories() async {
  List<Map> result = [];
  DocumentList temp = await db.listDocuments(
    databaseId: AppConfig.database,
    collectionId: AppConfig.categories,
    // queries: [],
  );
  result = getResult(temp.documents);
  return result;
}

getPromotions() async {
  List<Map> result = [];
  DocumentList temp = await db.listDocuments(
    databaseId: AppConfig.database,
    collectionId: AppConfig.promotions,
    queries: [Query.orderDesc("createdAt")],
  );
  result = getResult(temp.documents);
  return result;
}

getProducts(orderId) async {
  print(orderId);
  List<Map> products = [];

  DocumentList result =
      await db.listDocuments(databaseId: AppConfig.database, collectionId: AppConfig.products, queries: []
          // queries: [Query.equal("orderId", orderId)]
          );

  products = getResult(result.documents);

  return products;
}

getDrivers() async {
  List<Map> result = [];
  DocumentList temp = await db.listDocuments(
    databaseId: AppConfig.database,
    collectionId: AppConfig.drivers,
    queries: [Query.orderDesc("createdAt")],
  );
  result = getResult(temp.documents);
  return result;
}


List<Map> getResult(List<Document> documents) {
  List<Map> result = [];

  for (var doc in documents) {
    doc.data["id"] = doc.$id;
    result.add(doc.data);
  }
  return result;
}

getUrl(String imageId) {
  print("imaaageeeeee " + imageId);
  return "https://cloud.appwrite.io/v1/storage/buckets/65cdfdc7bba4531e45ad/files/${imageId}/view?project=grokci&mode=admin";
}
