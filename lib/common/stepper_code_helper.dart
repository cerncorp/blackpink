import 'package:flutter/material.dart';
// import 'package:blackpink/pages/stepper_usage.dart';

class StepperCodeHelper {
  static var categories = [
    "Electronic",
    "Furniture",
    "Vehicle",
    "Clothing",
    "Other",
  ];

  static List<String> fillSubCategoryList(String category) {
    switch (category) {
      case "Electronic":
        return ["TV", "Phone", "Computer", "Kitchen Tools", "Others"];
        break;
      case "Furniture":
        return ["Table", "Sofa", "Couch", "Chair", "Others"];
        break;
      case "Vehicle":
        return ["Car", "Motorcycle", "Truck", "Bike", "Others"];
        break;
      case "Clothing":
        return ["T-shirt", "shirt", "Pant", "Dress", "Others"];
        break;
      case "Other":
        return ["Others"];
        break;
      default:
        return ["Null"];
        break;
    }
  }

  static IconData iconBuilderCategory(String selectedCategory) {
    switch (selectedCategory) {
      case "Electronic":
        return Icons.phonelink;
        break;
      case "Furniture":
        return Icons.home;
        break;
      case "Vehicle":
        return Icons.directions_car;
        break;
      case "Clothing":
        return Icons.child_friendly;
        break;
      case "Other":
        return Icons.shopping_cart;
        break;
      case "null":
        return Icons.not_interested;
        break;
      default:
        return Icons.not_interested;
        break;
    }
  }

  static IconData iconBuilderSubCategory(String selectedCategory) {
    switch (selectedCategory) {
      case "TV":
        return Icons.tv;
        break;
      case "Phone":
        return Icons.phone_iphone;
        break;
      case "Computer":
        return Icons.computer;
        break;
      case "Kitchen Tools":
        return Icons.kitchen;
        break;
      case "Table":
        return Icons.table_chart;
        break;
      case "Sofa":
        return Icons.indeterminate_check_box;
        break;
      case "Couch":
        return Icons.event_seat;
        break;
      case "Car":
        return Icons.local_car_wash;
        break;
      case "Motorcycle":
        return Icons.motorcycle;
        break;
      case "Truck":
        return Icons.train;
        break;
      case "Chair":
        return Icons.child_friendly;
        break;
      case "Bike":
        return Icons.directions_bike;
        break;
      case "T-shirt":
        return Icons.shopping_cart;
        break;
      case "shirt":
        return Icons.shopping_cart;
        break;
      case "Pant":
        return Icons.shopping_cart;
        break;
      case "Dress":
        return Icons.shopping_cart;
        break;
      case "Other":
        return Icons.shopping_cart;
        break;
      case "null":
        return Icons.not_interested;
        break;
      default:
        return Icons.not_interested;
        break;
    }
  }
}
