import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:blackpink/common/stepper_code_helper.dart';

class StepperUsage extends StatefulWidget {
  @override
  _StepperUsageState createState() => _StepperUsageState();
}

class _StepperUsageState extends State<StepperUsage> {
  static var currentActiveState = 0;
  String selectedCategory;
  static String selectedSubCategory;
  String productDescription;
  String productPrice;
  List<Step> reloadSteps;
  List<String> subCategorylist;
  static bool errorFlag = false;
  bool stepPassingFlag = false;
  var categories = StepperCodeHelper.categories;

  var key0 = GlobalKey<FormFieldState>();
  var key1 = GlobalKey<FormFieldState>();

  @override
  void initState() {
    // TODO: implement initState
    subCategorylist = StepperCodeHelper.fillSubCategoryList(selectedCategory);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    reloadSteps = buildStepperSteps();

    return Theme(
        data: ThemeData(
            primaryColor: Colors.teal, accentColor: Colors.teal.shade800),
        child: Scaffold(
          appBar: AppBar(
            title: Text("Stepper Usage Tutorial"),
          ),
          body: SingleChildScrollView(
            child: Stepper(
              steps: reloadSteps,
              currentStep: currentActiveState,
              onStepCancel: () {
                setState(() {
                  if (currentActiveState > 0) {
                    errorFlag = false;
                    currentActiveState--;
                  } else {
                    currentActiveState = 0;
                  }
                });
              },
              onStepContinue: () {
                setState(() {
                  if (currentActiveState == 4) {
                    print("Your product category : $selectedCategory\n"
                        "Subcategory : $selectedSubCategory\n"
                        "Description : $productDescription\n"
                        "Price : $productPrice\n"
                        "SHARED SUCCESSFULLY!!!");
                  }
                  _shouldContinue();
                });
              },
            ),
          ),
        ));
  }

  void _shouldContinue() {
    print(currentActiveState);
    switch (currentActiveState) {
      case 0:
        if (selectedCategory != null) {
          errorFlag = false;
          currentActiveState = 1;
        } else {
          errorFlag = true;
        }
        break;
      case 1:
        if (selectedSubCategory != null) {
          errorFlag = false;
          currentActiveState = 2;
        } else {
          errorFlag = true;
        }
        break;
      case 2:
        if (key0.currentState.validate()) {
          key0.currentState.save();
          errorFlag = false;
          currentActiveState = 3;
        } else {
          errorFlag = true;
        }
        break;
      case 3:
        if (key1.currentState.validate()) {
          key1.currentState.save();
          errorFlag = false;
          currentActiveState = 4;
        } else {
          errorFlag = true;
        }
        break;

      case 4:
        currentActiveState = 4;
        break;
    }
  }

  List<Step> buildStepperSteps() {
    var myStepList = [
      Step(
          title: Text("Please Select Category"),
          content: buildDropDownCategories(),
          isActive: true,
          subtitle: Text("Choice :$selectedCategory"),
          state: _stateUpdate(0)),
      Step(
          title: Text("Please Select Category"),
          content: buildDropDownSubCategories(),
          isActive: true,
          subtitle: Text("Choice :$selectedSubCategory"),
          state: _stateUpdate(1)),
      Step(
          title: Text("Please describe the product you are looking for"),
          content: buildProductDescribe(),
          isActive: true,
          subtitle: Text("Description: $productDescription"),
          state: _stateUpdate(2)),
      Step(
          title: Text("Please enter price range"),
          content: buildProductPrice(),
          isActive: true,
          subtitle: Text("Price: $productPrice"),
          state: _stateUpdate(3)),
      Step(
          title: Text("Sharing"),
          content: Text("Do you want yo share?"),
          isActive: true,
          state: _stateUpdate(4)),
    ];
    return myStepList;
  }

  Widget buildDropDownCategories() {
    return Container(
      child: Row(
        children: <Widget>[
          Icon(StepperCodeHelper.iconBuilderCategory(selectedCategory)),
          SizedBox(
            width: 60,
          ),
          DropdownButton<String>(
            items: categories.map((item) {
              return DropdownMenuItem<String>(
                child: Text(item),
                value: item,
              );
            }).toList(),
            onChanged: (selection) {
              setState(() {
                selectedCategory = selection;
                subCategorylist =
                    StepperCodeHelper.fillSubCategoryList(selectedCategory);
              });
            },
            value: selectedCategory == null ||
                    !categories.contains(selectedCategory)
                ? categories[0]
                : selectedCategory,
          )
        ],
      ),
    );
  }

  StepState _stateUpdate(int stateNumber) {
    if (currentActiveState == stateNumber) {
      if (errorFlag) {
        return StepState.error;
      } else {
        return StepState.editing;
      }
    } else {
      return StepState.complete;
    }
  }

  Widget buildDropDownSubCategories() {
    return Container(
      child: Row(
        children: <Widget>[
          Icon(StepperCodeHelper.iconBuilderSubCategory(selectedSubCategory)),
          SizedBox(
            width: 60,
          ),
          DropdownButton<String>(
            items: subCategorylist.map((item) {
              return DropdownMenuItem<String>(
                child: Text(item),
                value: item,
              );
            }).toList(),
            onChanged: (selection) {
              setState(() {
                selectedSubCategory = selection;
              });
            },
            value: selectedSubCategory == null ||
                    !subCategorylist.contains(selectedSubCategory)
                ? subCategorylist[0]
                : selectedSubCategory,
          )
        ],
      ),
    );
  }

  Widget buildProductDescribe() {
    return TextFormField(
      key: key0,
      decoration: InputDecoration(
        hintText: "For example: Iphone 11 250 Gb",
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15))),
      ),
      // ignore: missing_return
      validator: (value) {
        if (value.length < 6) return "Cannot lower then 6 characters";
      },
      onSaved: (value) {
        productDescription = value;
      },
    );
  }

  Widget buildProductPrice() {
    return TextFormField(
      key: key1,
      decoration: InputDecoration(
        hintText: "100 TL",
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15))),
      ),
      // ignore: missing_return
      validator: (value) {
        if (value.length < 6) {
          return "Cannot lower then 6 characters";
        }
      },
      onSaved: (value) {
        productPrice = value;
      },
    );
  }
}
