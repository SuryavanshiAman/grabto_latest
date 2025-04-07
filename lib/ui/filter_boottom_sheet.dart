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

// void showFilterBottomSheet(BuildContext context,dynamic lat,dynamic long, List<FeaturesModel> featureData,List<SubCategoriesModel> subCategoriesData) {
//   List<String> categories = [
//
//     "Distance",
//     "Ratings",
//     "Restaurant Category",
//     "Discount",
//     "Amenities",
//   ];
//   String selectedData="";
//   String selectedCheckValueData="";
// List<FilteredDataModel>data=[];
//   Map<String, List<String>> subCategories = {
//     "Distance": ["Within 5km", "All", "Within 2km", "Within 10km", "Within 15km"],
//     "Ratings": ["Rating 4.5+", "Rating 4+", "Rating 3.5"],
//     "Discount": ["Up to 10% off"],
//   };
// bool isLoading=false;
//   ValueNotifier<String?> selectedCategory = ValueNotifier(categories[0]);
//   ValueNotifier<String?> selectedSubCategory = ValueNotifier("Relevance");
//   Set<String> selectedRestaurantCategories = {};
//   Set<String> selectedRestaurantAmenities = {};
//   Set<String> selectedCategories = {}; // Track categories with selected subcategories
//   bool hasSelectedSubcategory=false;
//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     backgroundColor: MyColors.whiteBG,
//     shape: const RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//     ),
//     builder: (context) {
//
//       return StatefulBuilder(builder: (context, setModalState) {
//         Future<void> filterApi(dynamic lat, dynamic long,dynamic rating,dynamic discount,dynamic distance,dynamic categoryId ) async {
//           setModalState(() {
//             isLoading = true;
//           });
//           try {
//             final body = {
//               "latitude": lat,
//               "longitude": long,
//               "rating": rating.toString(),
//               "discount": discount.toString(),
//               "distance": distance.toString(),
//               "category_id": categoryId.toString()
//             };
//             final response = await ApiServices.filterApi(body);
//             if (response != null) {
//               print("Amannnn:$response");
//               setModalState(() {
//                 data = response;
//               });
//             }
//           } catch (e) {
//             print('fetchSubCategories: $e');
//           } finally {
//             setModalState(() {
//               isLoading = false;
//             });
//           }
//         }
//         return Container(
//           height: MediaQuery.of(context).size.height * 0.75,
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Title & Close Button
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text(
//                     "Filter",
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                   InkWell(
//                     onTap: () {
//                       Navigator.pop(context);
//                     },
//                     child: const CircleAvatar(
//                       radius: 12,
//                       backgroundColor: Colors.grey,
//                       child: Icon(Icons.close, size: 15),
//                     ),
//                   ),
//                 ],
//               ),
//               const Divider(),
//               Expanded(
//                 child: Row(
//                   children: [
//                     SizedBox(
//                       width: 130,
//                       child: ValueListenableBuilder(
//                         valueListenable: selectedCategory,
//                         builder: (context, value, _) {
//                           return ListView.builder(
//                             itemCount: categories.length,
//                             itemBuilder: (context, index) {
//                               bool isSelected = categories[index] == value;
//                               hasSelectedSubcategory = selectedCategories.contains(categories[index]);
//                               return GestureDetector(
//                                 onTap: () {
//                                   selectedCategory.value = categories[index];
//                                 },
//                                 child: Container(
//                                   padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
//                                   decoration: BoxDecoration(
//                                     borderRadius: const BorderRadius.only(
//                                         topRight: Radius.circular(10),
//                                         bottomRight: Radius.circular(10)),
//                                     border: Border(
//                                       left: BorderSide(
//                                         color: isSelected ? MyColors.orange : Colors.transparent,
//                                         width: 3,
//                                       ),
//                                     ),
//                                   ),
//                                   child: Row(
//                                     children: [
//                                       if (hasSelectedSubcategory)
//                                         const Text("• ", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.red)),
//                                       Expanded(
//                                         child: Text(
//                                           categories[index],
//                                           style: TextStyle(
//                                             fontSize: 13,
//                                             fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
//                                             color: isSelected ? MyColors.orange : Colors.black,
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               );
//                             },
//                           );
//                         },
//                       ),
//                     ),
//                     Container(width: 1, height: MediaQuery.of(context).size.height, color: Colors.grey.withOpacity(0.3)),
//                     Expanded(
//                       child: Padding(
//                         padding: const EdgeInsets.only(left: 10),
//                         child: ValueListenableBuilder(
//                           valueListenable: selectedCategory,
//                           builder: (context, value, _) {
//                             List<String> subList = subCategories[value] ?? [];
//                             return Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   selectedCategory.value.toString(),
//                                   style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
//                                 ),
//                                 const SizedBox(height: 10),
//                                 Expanded(
//                                   child: ListView.builder(
//                                     itemCount:value == "Restaurant Category"?subCategoriesData.length:value == "Amenities"? featureData.length:subList.length,
//                                     itemBuilder: (context, index) {
//                                       bool isMultiSelectCategory = value == "Restaurant Category" || value == "Amenities";
//                                       bool isSelected = selectedRestaurantCategories.contains(value == "Restaurant Category"?subCategoriesData[index].subcategory_name:value == "Amenities"? featureData[index].name:subList[index]);
//                                       return GestureDetector(
//                                         onTap: () {
//                                           setModalState(() {
//                                             if (isMultiSelectCategory) {
//                                               if (isSelected) {
//                                                 selectedRestaurantCategories.remove(subList[index]);
//                                               } else {
//                                                 selectedRestaurantCategories.add(subList[index]);
//                                               }
//                                             } else {
//                                               selectedSubCategory.value = subList[index];
//                                             }
//
//                                             if (selectedRestaurantCategories.isNotEmpty || selectedSubCategory.value != null) {
//                                               selectedCategories.add(value!);
//
//                                             } else {
//                                               selectedCategories.remove(value!);
//                                             }
//                                           });
//                                         },
//                                         child: Row(
//                                           children: [
//                                             isMultiSelectCategory
//                                                 ? Checkbox(
//                                               value: isSelected,
//                                               side: const BorderSide(color: Colors.grey),
//                                               activeColor: MyColors.orange,
//                                               onChanged: (bool? checked) {
//                                                 setModalState(() {
//                                                   if (checked == true) {
//                                                     selectedRestaurantCategories.add(value == "Restaurant Category"?subCategoriesData[index].subcategory_name.toString():value == "Amenities"? featureData[index].name.toString():subList[index]);
//                                                   } else {
//                                                     selectedRestaurantCategories.remove(value == "Restaurant Category"?subCategoriesData[index].subcategory_name.toString():value == "Amenities"? featureData[index].name.toString():subList[index]);
//                                                   }
//                                                   if (selectedRestaurantCategories.isNotEmpty) {
//                                                     selectedCategories.add(value!);
//                                                   } else {
//                                                     selectedCategories.remove(value!);
//                                                   }
//                                                   print("Selected Restaurant Categories: $selectedRestaurantCategories");
//                                                   print("Selected Categories: $selectedCategories");
//                                                 });
//                                               },
//                                             )
//                                                 : Radio<String>(
//                                               value: subList[index],
//                                               groupValue: selectedSubCategory.value,
//                                               activeColor: MyColors.orange,
//                                               onChanged: (String? newValue) {
//                                                 setModalState(() {
//
//                                                   selectedSubCategory.value = newValue!;
//                                                   selectedCategories.add(value!);
//                                                   selectedData=selectedSubCategory.value??"";
//
//                                                 });
//                                               },
//                                             ),
//                                             Text(
//                                               value == "Restaurant Category"?subCategoriesData[index].subcategory_name:value == "Amenities"? featureData[index].name.toString():subList[index],
//                                               style: TextStyle(
//                                                 fontSize: 12,
//                                                 fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
//                                                 color: isSelected ? MyColors.blackBG : MyColors.blackBG.withOpacity(0.5),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       );
//                                     },
//                                   ),
//                                 ),
//                               ],
//                             );
//                           },
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//           const Divider(),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               TextButton(
//                 onPressed: () {
//
//                   setModalState((){
//                     selectedCategories.clear();
//                     hasSelectedSubcategory=false;
//                   });
//                 },
//                 child: const Text(
//                   "Clear Filters",
//                   style: TextStyle(
//                       color: MyColors.orange, fontWeight: FontWeight.bold),
//                 ),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   // filterApi(
//                   //   lat,
//                   //   long, // or categories.join(',') depending on API
//                   // );
//                   Navigator.pop(context);
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: MyColors.orange,
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                 ),
//                 child: const Text(
//                   "Apply",
//                   style: TextStyle(color: MyColors.whiteBG),
//                 ),
//               ),
//
//             ],
//               ),
//             ],
//           ),
//         );
//       });
//     },
//   );
//
// }
/// working
void showFilterBottomSheet(
    BuildContext context,
    dynamic lat,
    dynamic long,
    List<FeaturesModel> featureData,
    List<SubCategoriesModel> subCategoriesData,
    ) {
  List<String> categories = [
    "Distance",
    "Ratings",
    "Restaurant Category",
    "Discount",
    "Amenities",
  ];
  String? extractNumericValue(String? input) {
    if (input == null) return null;
    final numericRegex = RegExp(r'\d+(\.\d+)?');
    final match = numericRegex.firstMatch(input);
    return match?.group(0);
  }
  String selectedData = "";
  String selectedCheckValueData = "";
  List<FilteredDataModel> data = [];
  Map<String, List<String>> subCategories = {
    "Distance": ["Within 5km", "All", "Within 2km", "Within 10km", "Within 15km"],
    "Ratings": ["Rating 4.5+", "Rating 4+", "Rating 3.5"],
    "Discount": ["Up to 10% off"],
  };

  bool isLoading = false;
  ValueNotifier<String?> selectedCategory = ValueNotifier(categories[0]);
  ValueNotifier<String?> selectedSubCategory = ValueNotifier("Relevance");
  Set<String> selectedRestaurantCategories = {};
  Set<String> selectedAmenities = {};
  String? selectedRating;
  String? selectedDistance;
  String? selectedDiscount;
  Set<String> selectedCategories = {};
  bool hasSelectedSubcategory = false;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: MyColors.whiteBG,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return StatefulBuilder(builder: (context, setModalState) {
        Future<void> filterApi(
            dynamic lat,
            dynamic long,
            String? rating,
            String? discount,
            String? distance,
            dynamic restaurantCategories,
            dynamic amenities,
            ) async {
          setModalState(() {
            isLoading = true;
          });
          try {
            final body = {
              "latitude": lat,
              "longitude": long,
              "rating": rating,  // Dynamically passed
              "discount": discount,  // Dynamically passed
              "distance": distance,  // Dynamically passed
              "amenities": "",  // Dynamically passed
              "subcategory_id": "",  // Dynamically passed
            };
            print("Amannnn:$body");
            final response = await ApiServices.filterApi(body,context);
            if (response != null) {
              print("Amannnn:$response");
              setModalState(() {
                data = response;
              });
            }else{
              // showErrorMessage(context, message: "message");
            }
          } catch (e) {
            print('fetchSubCategories: $e');
          } finally {
            // setModalState(() {
            //   isLoading = false;
            // });
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
                              print(hasSelectedSubcategory);
                              print(isSelected);
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
                                        color: isSelected ? MyColors.redBG : Colors.transparent,
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
                                    itemCount: value == "Restaurant Category"
                                        ? subCategoriesData.length
                                        : value == "Amenities"
                                        ? featureData.length
                                        : subList.length,
                                    itemBuilder: (context, index) {
                                      bool isMultiSelectCategory = value == "Restaurant Category" || value == "Amenities";
                                      bool isSelected = value == "Restaurant Category"
                                          ? selectedRestaurantCategories.contains(subCategoriesData[index].id.toString())
                                          : value == "Amenities"
                                          ? selectedAmenities.contains(featureData[index].name.toString())
                                          : value == "Ratings"
                                          ? selectedRating == subList[index]
                                          : value == "Distance"
                                          ? selectedDistance == subList[index]
                                          : value == "Discount"
                                          ? selectedDiscount == subList[index]
                                          : false;

                                      return GestureDetector(
                                        onTap: () {
                                          setModalState(() {
                                            if (isMultiSelectCategory) {
                                              if (value == "Restaurant Category") {
                                                if (isSelected) {
                                                  selectedRestaurantCategories.remove(subCategoriesData[index].id.toString());
                                                } else {
                                                  selectedRestaurantCategories.add(subCategoriesData[index].id.toString());
                                                }
                                              } else if (value == "Amenities") {
                                                if (isSelected) {
                                                  selectedAmenities.remove(featureData[index].name.toString());
                                                } else {
                                                  selectedAmenities.add(featureData[index].name.toString());
                                                }
                                              }
                                            } else if (value == "Ratings") {
                                              selectedRating = subList[index];
                                            } else if (value == "Distance") {
                                              selectedDistance = subList[index];
                                            } else if (value == "Discount") {
                                              selectedDiscount = subList[index];
                                            }

                                            // Print the selected values
                                            print("Selected Restaurant Categories: $selectedRestaurantCategories");
                                            print("Selected Amenities: $selectedAmenities");
                                            print("Selected Rating: $selectedRating");
                                            print("Selected Distance: $selectedDistance");
                                            print("Selected Discount: $selectedDiscount");
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
                                                  if (value == "Restaurant Category") {
                                                    if (checked == true) {
                                                      selectedRestaurantCategories.add(subCategoriesData[index].id.toString());
                                                    } else {
                                                      selectedRestaurantCategories.remove(subCategoriesData[index].id.toString());
                                                    }
                                                  } else if (value == "Amenities") {
                                                    if (checked == true) {
                                                      selectedAmenities.add(featureData[index].name.toString());
                                                    } else {
                                                      selectedAmenities.remove(featureData[index].name.toString());
                                                    }
                                                  }

                                                  // Print the selected values
                                                  print("Selected Restaurant Categories: $selectedRestaurantCategories");
                                                  print("Selected Amenities: $selectedAmenities");
                                                });
                                              },
                                            )
                                                : Radio<String>(
                                              value: subList[index],
                                              groupValue: value == "Ratings"
                                                  ? selectedRating
                                                  : value == "Distance"
                                                  ? selectedDistance
                                                  : value == "Discount"
                                                  ? selectedDiscount
                                                  : null,
                                              activeColor: MyColors.orange,
                                              onChanged: (String? newValue) {
                                                setModalState(() {
                                                  if (value == "Ratings") {
                                                    selectedRating = newValue;
                                                  } else if (value == "Distance") {
                                                    selectedDistance = newValue;
                                                  } else if (value == "Discount") {
                                                    selectedDiscount = newValue;
                                                  }

                                                  // Print the selected values
                                                  print("Selected Rating: $selectedRating");
                                                  print("Selected Rating (Numeric): ${extractNumericValue(selectedRating)}");
                                                  print("Selected Distance: $selectedDistance");
                                                  print("Selected Discount: $selectedDiscount");
                                                });
                                              },
                                            ),
                                            Text(
                                              value == "Restaurant Category"
                                                  ? subCategoriesData[index].subcategory_name
                                                  : value == "Amenities"
                                                  ? featureData[index].name.toString()
                                                  : subList[index],
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
                      setModalState(() {
                        selectedCategories.clear();
                        selectedRestaurantCategories.clear();
                        selectedAmenities.clear();
                        // selectedRatings.clear();
                        // selectedDistances.clear();
                        // selectedDiscounts.clear();
                        selectedSubCategory.value = "Relevance";
                      });
                    },
                    child: const Text(
                      "Clear Filters",
                      style: TextStyle(color: MyColors.orange, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {

                      Future.delayed(Duration(seconds: 1),(){
                        Navigator.pop(context);
                      });

                      filterApi(
                        lat,
                        long,
                        extractNumericValue(selectedRating),
                        extractNumericValue(selectedDiscount),
                        extractNumericValue(selectedDistance),
                        selectedRestaurantCategories.toList(),
                        selectedAmenities.toList(),
                      );
                      //
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyColors.orange,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text(
                      "Apply",
                      style: TextStyle(color: MyColors.whiteBG),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      });
    },
  );
}




