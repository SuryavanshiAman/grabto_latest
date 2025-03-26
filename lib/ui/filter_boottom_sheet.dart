import 'package:flutter/material.dart';
import 'package:grabto/theme/theme.dart';

import '../helper/shared_pref.dart';
import '../main.dart';
import '../model/features_model.dart';
import '../model/filtered_data_model.dart';
import '../model/sub_categories_model.dart';
import '../model/user_model.dart';
import '../services/api_services.dart';
import '../utils/snackbar_helper.dart';
import 'home_screen.dart';

// void showFilterBottomSheet(BuildContext context) {
//   List<String> categories = [
//     "Sort",
//     "GIRF",
//     "Distance",
//     "Ratings",
//     "Restaurant Category",
//     "Dietary Preferences",
//     "Discount",
//     "Amenities",
//     "Cost for two",
//     "More filters",
//     "Cuisines"
//   ];
//
//   Map<String, List<String>> subCategories = {
//     "Sort": [
//       "Relevance",
//       "Distance: Nearby to Far",
//       "Popularity: High to Low",
//       "Cost for two: Low to High",
//       "Cost for two: High to Low"
//     ],
//     "GIRF": ["GIRF"],
//     "Distance": [
//       "Within 5km",
//       "All",
//       "Within 2km",
//       "Within 10km",
//       "Within 15km"
//     ],
//     "Ratings": ["Rating 4.5+", "Rating 4+", "Rating 3.5"],
//     "Restaurant Category": [
//       "5 star",
//       "Bakery",
//       "Bar",
//       "Bistro",
//       "Cafe",
//       "Dessert Parlour",
//       "Fine Dining",
//       "Food Court",
//       "Lounge",
//       "Microbrewery",
//       "Nightlife",
//       "Restobar"
//     ],
//     "Dietary Preference": [
//       "Jain Food",
//       "Serves Halal",
//       "Vegan Friendly",
//       "Pure Veg",
//       "Non Vegetarian"
//     ],
//     "Discount": ["Up to 10% off"],
//     "Amenities":["4/5 Star","Air Conditioned","All Day Breakfast","Available For Functions","Breakfast","Brunch","Budget Friendly","Buffet","Celebrity Frequented","DJ"],
//     "Cost for two":["Less than ₹1000","₹1000-₹2000","₹2000-₹3000","₹3000-₹4000"]
//   };
//
//   ValueNotifier<String?> selectedCategory = ValueNotifier(categories[0]);
//   ValueNotifier<String?> selectedSubCategory = ValueNotifier("Relevance");
//   Set<String> selectedRestaurantCategories = {}; // Store multiple selections
//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     backgroundColor:MyColors.whiteBG,
//     shape: RoundedRectangleBorder(
//
//       borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//     ),
//     builder: (context) {
//       return StatefulBuilder(
//           builder: (context, setModalState) {
//           return Container(
//             height: MediaQuery.of(context).size.height * 0.75,
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Title & Close Button
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text(
//                       "Filter",
//                       style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                     ),
//                     InkWell(
//                       onTap: () {
//                         Navigator.pop(context);
//                       },
//                       child: CircleAvatar(
//                         radius: 12,
//                         backgroundColor: Colors.grey,
//                         child: const Icon(
//                           Icons.close,
//                           size: 15,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const Divider(),
//                 Expanded(
//                   child: Row(
//                     children: [
//                       // Left Category List
//                       SizedBox(
//                         width: 120,
//                         child: ValueListenableBuilder(
//                           valueListenable: selectedCategory,
//                           builder: (context, value, _) {
//                             return ListView.builder(
//                               itemCount: categories.length,
//                               itemBuilder: (context, index) {
//                                 bool isSelected = categories[index] == value;
//                                 return GestureDetector(
//                                   onTap: () {
//                                     selectedCategory.value = categories[index];
//                                   },
//                                   child: Container(
//                                     width: 10,
//                                     padding: const EdgeInsets.symmetric(
//                                         vertical: 15, horizontal: 13),
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.only(
//                                           topRight: Radius.circular(10),
//                                           bottomRight: Radius.circular(10)),
//                                       // color: isSelected ? Colors.orange.shade100 : Colors.transparent,
//                                       border: Border(
//                                         left: BorderSide(
//                                           color: isSelected
//                                               ? MyColors.orange
//                                               : Colors.transparent,
//                                           width: 3,
//                                         ),
//                                       ),
//                                     ),
//                                     child: Text(
//                                       categories[index],
//                                       style: TextStyle(
//                                         fontSize: 13,
//                                         fontWeight: isSelected
//                                             ? FontWeight.bold
//                                             : FontWeight.w500,
//                                         color: isSelected
//                                             ? MyColors.orange
//                                             : Colors.black,
//                                       ),
//                                     ),
//                                   ),
//                                 );
//                               },
//                             );
//                           },
//                         ),
//                       ),
//                       Container(
//                         width: 1,
//                         height: heights,
//                         color: Colors.grey.withOpacity(0.3),
//                       ),
//                       // Right Sub-options
//                       // Expanded(
//                       //   child: Padding(
//                       //     padding: const EdgeInsets.only(left: 10),
//                       //     child: ValueListenableBuilder(
//                       //       valueListenable: selectedCategory,
//                       //       builder: (context, value, _) {
//                       //         List<String> subList = subCategories[value] ?? [];
//                       //
//                       //         return Column(
//                       //           crossAxisAlignment: CrossAxisAlignment.start,
//                       //           children: [
//                       //              Text(
//                       //                "Short by",
//                       //               style: TextStyle(
//                       //                   fontSize: 14, fontWeight: FontWeight.w500),
//                       //             ),
//                       //             const SizedBox(height: 10),
//                       //             Expanded(
//                       //               child: ListView.builder(
//                       //                 itemCount: subList.length,
//                       //                 itemBuilder: (context, index) {
//                       //                   bool isSelected = subList[index] == selectedSubCategory.value;
//                       //                   return GestureDetector(
//                       //                     onTap: () {
//                       //                       setModalState((){
//                       //                         print("aman");
//                       //                         selectedSubCategory.value = subList[index];
//                       //                       });
//                       //
//                       //                     },
//                       //                     child: Container(
//                       //                       padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
//                       //                       decoration: BoxDecoration(
//                       //                         // color: Colors.red,
//                       //                         borderRadius: BorderRadius.circular(8),
//                       //                       ),
//                       //                       child: Row(
//                       //                         children: [
//                       //                           Radio<String>(
//                       //                             value: subList[index],
//                       //                             groupValue: selectedSubCategory.value,
//                       //                             activeColor: MyColors.orange,
//                       //                             onChanged: (String? value) {
//                       //                               setModalState((){
//                       //                                 print("aman");
//                       //                                 selectedSubCategory.value = value!;
//                       //                               });
//                       //
//                       //                             },
//                       //                           ),
//                       //                           Text(
//                       //                             subList[index],
//                       //                             style: TextStyle(
//                       //                               fontSize: 12,
//                       //                               fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
//                       //                               color: isSelected ? MyColors.blackBG : MyColors.blackBG.withOpacity(0.5),
//                       //                             ),
//                       //                           ),
//                       //
//                       //                         ],
//                       //                       ),
//                       //                     ),
//                       //                   );
//                       //                 },
//                       //               )
//                       //
//                       //               // ListView.builder(
//                       //               //   itemCount: subList.length,
//                       //               //   itemBuilder: (context, index) {
//                       //               //     bool isSelected = subList[index] ==
//                       //               //         selectedSubCategory.value;
//                       //               //     return GestureDetector(
//                       //               //       onTap: () {
//                       //               //         selectedSubCategory.value =
//                       //               //             subList[index];
//                       //               //       },
//                       //               //       child: Container(
//                       //               //         padding: const EdgeInsets.symmetric(
//                       //               //             vertical: 12, horizontal: 5),
//                       //               //         decoration: BoxDecoration(
//                       //               //           borderRadius:
//                       //               //               BorderRadius.circular(8),
//                       //               //         ),
//                       //               //         child: Row(
//                       //               //           children: [
//                       //               //             Icon(
//                       //               //               isSelected
//                       //               //                   ? Icons.radio_button_checked
//                       //               //                   : Icons
//                       //               //                       .radio_button_unchecked,
//                       //               //               color: isSelected
//                       //               //                   ? MyColors.orange
//                       //               //                   : Colors.grey,
//                       //               //               size: 16,
//                       //               //             ),
//                       //               //             const SizedBox(width: 10),
//                       //               //             Text(
//                       //               //               subList[index],
//                       //               //               style: TextStyle(
//                       //               //                 fontSize: 12,
//                       //               //                 fontWeight: isSelected
//                       //               //                     ? FontWeight.bold
//                       //               //                     : FontWeight.normal,
//                       //               //                 color: isSelected
//                       //               //                     ? MyColors.orange
//                       //               //                     : Colors.black,
//                       //               //               ),
//                       //               //             ),
//                       //               //           ],
//                       //               //         ),
//                       //               //       ),
//                       //               //     );
//                       //               //   },
//                       //               // ),
//                       //             ),
//                       //           ],
//                       //         );
//                       //       },
//                       //     ),
//                       //   ),
//                       // ),
//                       Expanded(
//                         child: Padding(
//                           padding: const EdgeInsets.only(left: 10),
//                           child: ValueListenableBuilder(
//                             valueListenable: selectedCategory,
//                             builder: (context, value, _) {
//                               List<String> subList = subCategories[value] ?? [];
//
//                               return Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     selectedCategory.value.toString(),
//                                     style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
//                                   ),
//                                   const SizedBox(height: 10),
//                                   Expanded(
//                                     child: ListView.builder(
//                                       itemCount: subList.length,
//                                       itemBuilder: (context, index) {
//                                         bool isRestaurantCategory = value == "Restaurant Category"||value =="Amenities";
//
//                                         if (isRestaurantCategory) {
//                                           // Use CheckBox for multiple selection
//                                           bool isSelected = selectedRestaurantCategories.contains(subList[index]);
//
//                                           return GestureDetector(
//                                             onTap: () {
//                                               setModalState(() {
//                                                 if (isSelected) {
//                                                   selectedRestaurantCategories.remove(subList[index]);
//                                                 } else {
//                                                   selectedRestaurantCategories.add(subList[index]);
//                                                 }
//                                               });
//                                             },
//                                             child: Row(
//                                               children: [
//                                                 Checkbox(
//                                                   value: isSelected,
//                                                   side: BorderSide(color:Colors.grey),
//                                                   activeColor: MyColors.orange,
//                                                   onChanged: (bool? checked) {
//                                                     setModalState(() {
//                                                       if (checked == true) {
//                                                         selectedRestaurantCategories.add(subList[index]);
//                                                       } else {
//                                                         selectedRestaurantCategories.remove(subList[index]);
//                                                       }
//                                                     });
//                                                   },
//                                                 ),
//                                                 Text(
//                                                   subList[index],
//                                                   style: TextStyle(
//                                                     fontSize: 12,
//                                                     fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
//                                                     color: isSelected ? MyColors.blackBG : MyColors.blackBG.withOpacity(0.5),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           );
//                                         } else {
//                                           // Use Radio for other categories
//                                           bool isSelected = subList[index] == selectedSubCategory.value;
//                                           return GestureDetector(
//                                             onTap: () {
//                                               setModalState(() {
//                                                 selectedSubCategory.value = subList[index];
//                                               });
//                                             },
//                                             child: Row(
//                                               children: [
//                                                 Radio<String>(
//                                                   value: subList[index],
//                                                   groupValue: selectedSubCategory.value,
//                                                   activeColor: MyColors.orange,
//                                                   onChanged: (String? value) {
//                                                     setModalState(() {
//                                                       selectedSubCategory.value = value!;
//                                                     });
//                                                   },
//                                                 ),
//                                                 Text(
//                                                   subList[index],
//                                                   style: TextStyle(
//                                                     fontSize: 12,
//                                                     fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
//                                                     color: isSelected ? MyColors.blackBG : MyColors.blackBG.withOpacity(0.5),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           );
//                                         }
//                                       },
//                                     ),
//                                   ),
//                                 ],
//                               );
//                             },
//                           ),
//                         ),
//                       ),
//
//                     ],
//                   ),
//                 ),
//                 const Divider(),
//                 // Clear & Apply Buttons
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     TextButton(
//                       onPressed: () {
//                         selectedSubCategory.value = null;
//                         Navigator.pop(context);
//                       },
//                       child: const Text(
//                         "Clear Filters",
//                         style: TextStyle(
//                             color: MyColors.orange, fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     ElevatedButton(
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: MyColors.orange,
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8)),
//                       ),
//                       child: const Text("Apply",style: TextStyle(color: MyColors.whiteBG),),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           );
//         }
//       );
//     },
//   );
// }
void showFilterBottomSheet(BuildContext context,dynamic lat,dynamic long, List<FeaturesModel> featureData,List<SubCategoriesModel> subCategoriesData) {
  List<String> categories = [

    "Distance",
    "Ratings",
    "Restaurant Category",
    "Discount",
    "Amenities",
  ];
  String selectedData="";
  String selectedCheckValueData="";
List<FilteredDataModel>data=[];
  Map<String, List<String>> subCategories = {
    // "Sort": [
    //   "Relevance",
    //   "Distance: Nearby to Far",
    //   "Popularity: High to Low",
    //   "Cost for two: Low to High",
    //   "Cost for two: High to Low"
    // ],
    // "GIRF": ["GIRF"],
    "Distance": ["Within 5km", "All", "Within 2km", "Within 10km", "Within 15km"],
    "Ratings": ["Rating 4.5+", "Rating 4+", "Rating 3.5"],
    "Restaurant Category": [
      "5 star", "Bakery", "Bar", "Bistro", "Cafe", "Dessert Parlour",
      "Fine Dining", "Food Court", "Lounge", "Microbrewery", "Nightlife", "Restobar"
    ],
    // "Dietary Preferences": [
    //   "Jain Food", "Serves Halal", "Vegan Friendly", "Pure Veg", "Non Vegetarian"
    // ],
    "Discount": ["Up to 10% off"],
    "Amenities": [
      "4/5 Star", "Air Conditioned", "All Day Breakfast", "Available For Functions",
      "Breakfast", "Brunch", "Budget Friendly", "Buffet", "Celebrity Frequented", "DJ"
    ],
  };
bool isLoading=false;
  ValueNotifier<String?> selectedCategory = ValueNotifier(categories[0]);
  ValueNotifier<String?> selectedSubCategory = ValueNotifier("Relevance");
  Set<String> selectedRestaurantCategories = {};
  Set<String> selectedCategories = {}; // Track categories with selected subcategories
  bool hasSelectedSubcategory=false;
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: MyColors.whiteBG,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {

      return StatefulBuilder(builder: (context, setModalState) {
        Future<void> filterApi(dynamic lat, dynamic long,dynamic rating,dynamic discount,dynamic distance,dynamic categoryId ) async {
          setModalState(() {
            isLoading = true;
          });
          try {
            final body = {
              "latitude": lat,
              "longitude": long,
              "rating": rating,
              "discount": discount,
              "distance": distance,
              "category_id": categoryId
            };
            final response = await ApiServices.filterApi(body);
            if (response != null) {
              print("Amannnn:$response");
              setModalState(() {
                data = response;
              });
            }
          } catch (e) {
            print('fetchSubCategories: $e');
          } finally {
            setModalState(() {
              isLoading = false;
            });
          }
        }
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title & Close Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Filter",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.close, size: 15),
                    ),
                  ),
                ],
              ),
              const Divider(),
              Expanded(
                child: Row(
                  children: [
                    SizedBox(
                      width: 130,
                      child: ValueListenableBuilder(
                        valueListenable: selectedCategory,
                        builder: (context, value, _) {
                          return ListView.builder(
                            itemCount: categories.length,
                            itemBuilder: (context, index) {
                              bool isSelected = categories[index] == value;
                              hasSelectedSubcategory = selectedCategories.contains(categories[index]);
                              return GestureDetector(
                                onTap: () {
                                  selectedCategory.value = categories[index];
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(10),
                                        bottomRight: Radius.circular(10)),
                                    border: Border(
                                      left: BorderSide(
                                        color: isSelected ? MyColors.orange : Colors.transparent,
                                        width: 3,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      if (hasSelectedSubcategory)
                                        const Text("• ", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.red)),
                                      Expanded(
                                        child: Text(
                                          categories[index],
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                            color: isSelected ? MyColors.orange : Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    Container(width: 1, height: MediaQuery.of(context).size.height, color: Colors.grey.withOpacity(0.3)),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: ValueListenableBuilder(
                          valueListenable: selectedCategory,
                          builder: (context, value, _) {
                            List<String> subList = subCategories[value] ?? [];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  selectedCategory.value.toString(),
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(height: 10),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount:value == "Restaurant Category"?subCategoriesData.length:value == "Amenities"? featureData.length:subList.length,
                                    itemBuilder: (context, index) {
                                      bool isMultiSelectCategory = value == "Restaurant Category" || value == "Amenities";
                                      bool isSelected = selectedRestaurantCategories.contains(value == "Restaurant Category"?subCategoriesData[index].subcategory_name:value == "Amenities"? featureData[index].name:subList[index]);
                                      return GestureDetector(
                                        onTap: () {
                                          setModalState(() {
                                            if (isMultiSelectCategory) {
                                              if (isSelected) {
                                                selectedRestaurantCategories.remove(subList[index]);
                                              } else {
                                                selectedRestaurantCategories.add(subList[index]);
                                              }
                                            } else {
                                              selectedSubCategory.value = subList[index];
                                            }

                                            if (selectedRestaurantCategories.isNotEmpty || selectedSubCategory.value != null) {
                                              selectedCategories.add(value!);

                                            } else {
                                              selectedCategories.remove(value!);
                                            }
                                          });
                                        },
                                        child: Row(
                                          children: [
                                            isMultiSelectCategory
                                                ? Checkbox(
                                              value: isSelected,
                                              side: const BorderSide(color: Colors.grey),
                                              activeColor: MyColors.orange,
                                              onChanged: (bool? checked) {
                                                setModalState(() {
                                                  if (checked == true) {
                                                    selectedRestaurantCategories.add(value == "Restaurant Category"?subCategoriesData[index].subcategory_name.toString():value == "Amenities"? featureData[index].name.toString():subList[index]);
                                                  } else {
                                                    selectedRestaurantCategories.remove(value == "Restaurant Category"?subCategoriesData[index].subcategory_name.toString():value == "Amenities"? featureData[index].name.toString():subList[index]);
                                                  }
                                                  if (selectedRestaurantCategories.isNotEmpty) {
                                                    selectedCategories.add(value!);
                                                  } else {
                                                    selectedCategories.remove(value!);
                                                  }
                                                  print("Selected Restaurant Categories: $selectedRestaurantCategories");
                                                  print("Selected Categories: $selectedCategories");
                                                });
                                              },
                                            )
                                                : Radio<String>(
                                              value: subList[index],
                                              groupValue: selectedSubCategory.value,
                                              activeColor: MyColors.orange,
                                              onChanged: (String? newValue) {
                                                setModalState(() {

                                                  selectedSubCategory.value = newValue!;
                                                  selectedCategories.add(value!);
                                                  selectedData=selectedSubCategory.value??"";

                                                });
                                              },
                                            ),
                                            Text(
                                              value == "Restaurant Category"?subCategoriesData[index].subcategory_name:value == "Amenities"? featureData[index].name.toString():subList[index],
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                                                color: isSelected ? MyColors.blackBG : MyColors.blackBG.withOpacity(0.5),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {

                  setModalState((){
                    selectedCategories.clear();
                    hasSelectedSubcategory=false;
                  });
                },
                child: const Text(
                  "Clear Filters",
                  style: TextStyle(
                      color: MyColors.orange, fontWeight: FontWeight.bold),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // filterApi(lat,long);
                  Navigator.pop(context);

                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: MyColors.orange,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text("Apply",style: TextStyle(color: MyColors.whiteBG),))],
              ),
            ],
          ),
        );
      });
    },
  );

}
