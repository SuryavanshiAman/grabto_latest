import 'dart:convert';

import 'package:grabto/main.dart';
import 'package:grabto/model/store_model.dart';
import 'package:grabto/services/api.dart';
import 'package:grabto/theme/theme.dart';
import 'package:grabto/ui/coupon_fullview_screen.dart';
import 'package:flutter/material.dart';
import 'package:grabto/ui/pay_bill_screen.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../model/regular_offer_model.dart';
import '../services/api_services.dart';
import '../view_model/add_post_view_model.dart';

class RestaurantsSearch extends StatefulWidget {
  final String status;

  const RestaurantsSearch({super.key,required this.status});
  @override
  _RestaurantsSearchState createState() => _RestaurantsSearchState();
}

class _RestaurantsSearchState extends State<RestaurantsSearch> {
  TextEditingController _searchController = TextEditingController();
  List<StoreModel> _filteredStores = [];

  @override
  void initState() {
    super.initState();
    _fetchStores('');
  }

  Future<void> _fetchStores(String query) async {
    final body = {"search_name": "$query"};

    String apiUrl = '$BASE_URL/search_store';
    try {
      final response = await http.post(Uri.parse(apiUrl), body: body);
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['res'] == 'success') {
          List<dynamic> data = jsonData['data'];
          setState(() {
            _filteredStores =
                data.map((store) => StoreModel.fromMap(store)).toList();
          });

          print("data: ");
        }
      } else {
        throw Exception(
            'Failed to load stores. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching stores: $e');
      // Handle error here
    }
  }


  @override
  Widget build(BuildContext context) {
    final data = Provider.of<AddPostViewModel>(context);
    return Scaffold(
      backgroundColor: MyColors.backgroundBg,
      appBar: AppBar(
        backgroundColor: MyColors.whiteBG,
        leading: InkWell(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.close)),
        title: Text("Select a restaurant",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600,fontFamily: 'wix',color: MyColors.textColor),),
        actions: [
          IconButton(
            icon: Icon(Icons.location_on_outlined,size: 16,),
            onPressed: () {
              _searchController.clear();
              _fetchStores('');
            },
          ),
        ],
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(height: 40,
              child: TextField(
                controller: _searchController,
                onChanged: (query) => _fetchStores(query),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: MyColors.whiteBG,
                  hintText: 'Search for location',
                  hintStyle: TextStyle(fontSize: 12,fontWeight: FontWeight.w600,fontFamily: 'wix',color: MyColors.textColorTwo),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 7),
                  enabledBorder: OutlineInputBorder(
                    gapPadding: 0,
                    borderSide:
                    BorderSide(color: MyColors.grey.withAlpha(30)),
                    borderRadius:
                    BorderRadius.circular(5.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color:  MyColors.grey.withAlpha(30)),
                    borderRadius:
                    BorderRadius.circular(5.0),
                  ),
                  suffix: Icon(Icons.search,size: 16,color: MyColors.textColorTwo,)
                ),
              ),
            ),
          ),

          Container(
            height: heights,
            child: ListView.builder(
              itemCount: _filteredStores.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    data.setStoreId(_filteredStores[index].subcategoryId);
                    Navigator.pop(context);
                  },
                  child: Column(
                    children: [
                      ListTile(
                        visualDensity: VisualDensity(horizontal: -4,vertical: -4),
                        title: Text(
                          _filteredStores[index].storeName,
                          maxLines: 2, // Set maxLines to 2
                          overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontFamily: 'wix',fontWeight: FontWeight.w600,fontSize: 14)// Handle overflow
                        ),
                        subtitle: Text(
                          _filteredStores[index].address,
                          maxLines: 2, // Set maxLines to 2
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontFamily: 'wix',fontWeight: FontWeight.w600,fontSize: 12,color: MyColors.textColorTwo),// Handle overflow
                        ),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(_filteredStores[index].logo),
                        ),
                      ),
                      Divider(color: MyColors.textColorTwo.withAlpha(30),height: 10,)
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  List<RegularOfferModel> regularofferlist = [];
  Future<void> regularOffer(String store_id,int index) async {
    print('regularOffer: store_id $store_id');
    try {
      final body = {"store_id": "$store_id"};
      final response = await ApiServices.RegularOffer(body);
      print('regularOffer: response $response');
      if (response != null) {
        setState(() {
          regularofferlist = response;
          // isLoading = false; // Set isLoading to false when fetching ends
        });
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  PayBillScreen(
                      regularofferlist[0],
                      _filteredStores[index].storeName,
                      "${_filteredStores[index].address} ${_filteredStores[index].address2} ${_filteredStores[index].country} ${_filteredStores[index].state}, ${_filteredStores[index].postcode}"
                  )),
        );
      } else {
        setState(() {
          // isLoading = false; // Set isLoading to false when fetching ends
        });
      }
    } catch (e) {
      print('regularOffer: $e');
      setState(() {
        // isLoading = false; // Set isLoading to false in case of error
      });
    }
  }
}
