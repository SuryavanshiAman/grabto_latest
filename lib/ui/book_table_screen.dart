import 'package:grabto/main.dart';
import 'package:grabto/model/book_table_model.dart';
import 'package:grabto/model/pre_book_table_model.dart';
import 'package:grabto/model/user_model.dart';
import 'package:grabto/services/api_services.dart';
import 'package:grabto/theme/theme.dart';
import 'package:grabto/ui/confirm_booking_screen.dart';
import 'package:grabto/utils/snackbar_helper.dart';
import 'package:grabto/utils/time_slot.dart';
import 'package:grabto/widget/offer_term_condtion.dart';
import 'package:grabto/model/terms_condition_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookTableScreen extends StatefulWidget {
  String startTime;
  String storeName;
  String store_id;
  String category_name;

  BookTableScreen(this.startTime, this.storeName, this.store_id,
      this.category_name);

  @override
  _BookTableScreenState createState() => _BookTableScreenState();
}

class _BookTableScreenState extends State<BookTableScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    timeSlot(widget.store_id, DateFormat('dd-MM-yyyy').format(now), DateFormat('EEEE').format(now),);
    prebookoffer(widget.store_id,"","");
    print("😋😋😋😋${widget.store_id}");
    fetchStoresTermCondition();
    checkTimeSlotsVisibility(_selectedDate);
  }


  ScrollController _scrollController = ScrollController();
  int _selectedGuestNumber = 1;
  DateTime _selectedDate = DateTime.now();
  bool dataSelected = false;
  bool isDinnerTimeSlotsVisible = false,
      isLunchTimeSlotsVisible = false; // Track visibility of time slots

  int intervalInMinutes = 30;
  String startLunch = "";
  int availableSeat = 0;
  String endLunch = "06:00 PM";
  late List<String> timeSlotsLunch = [];
  String startDinner = "06:00 PM";
  String endDinner = "";
  late List<String> timeSlotsDinner = [];
  String? selectedTimeSlot, timetype; // Track the single selected time slot
  List<PreBookTable> prebookofferlist = [];
  List<bookTableModel> bookModel = [];
  bool isLoading = true;
  PreBookTable? selectedPreBookOffer;
  List<TermConditionModel> termConditionList = [];

  void _updateSelectedDate(DateTime date) {
    print(":AMan:$date");
    availableSeates(widget.store_id, date);
    setState(() {
      _selectedDate = date;
      // Format the date to "yyyy-MM-dd" format
    });
    timeSlotsLunch = generateTimeSlots(
        startLunch, endLunch, intervalInMinutes, _selectedDate);
    timeSlotsDinner = generateTimeSlots(
        startDinner, endDinner, intervalInMinutes, _selectedDate);
    checkTimeSlotsVisibility(_selectedDate);
  }

  Future<void> availableSeates(String storeId, dynamic date) async {
    try {
      final body = {
        "store_id": storeId,
        "booking_date": DateFormat('yyyy-MM-dd').format(date).toString()
      };
      final response = await ApiServices.availableSeats(context, body);
      print("😓😓😓${response!['data']}");
      if (response['error'] == false) {
        final data = response['data'];
        setState(() {
          // availableSeat = response['data'];
        });
      } else {
        String msg = response['message'];

        // Handle unsuccessful response or missing 'res' field
        showErrorMessage(context, message: msg);
      }
    } catch (e) {
      //print('verify_otp error: $e');
      // Handle error
      showErrorMessage(context, message: 'An error occurred: $e');
    } finally {}
  }

  void _updateSelectedNumber(int number) {
    setState(() {
      _selectedGuestNumber = number;
    });
  }

  void toggleTimeSlotsVisibility() {
    setState(() {
      isDinnerTimeSlotsVisible = !isDinnerTimeSlotsVisible; // Toggle visibility
    });
  }

  void toggleLunchTimeSlotsVisibility() {
    setState(() {
      isLunchTimeSlotsVisible = !isLunchTimeSlotsVisible;
    });
    print(isLunchTimeSlotsVisible);
    print(selectedIndex);
  }
int selectedIndex=0;
int isLunchTimeSlotsVisibleIndex=-1;
  void checkTimeSlotsVisibility(DateTime selectedDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(Duration(days: 1));

    print(
        'checkTimeSlotsVisibility Current Time: ${DateFormat.jm().format(now)}');

    // Format the current time for comparison
    String timeToCheck = DateFormat.jm().format(now);
    print('checkTimeSlotsVisibility Time to Check: $timeToCheck');

    bool isTimeInRange(String time, String start, String end) {
      // Handle cases where the end time is on the next day
      if (end.compareTo(start) < 0) {
        // When the end time is less than the start time, it indicates it goes past midnight
        print(
            'checkTimeSlotsVisibility End time goes past midnight. Checking: $time against start: $start and end: $end');
        return (time.compareTo(start) >= 0 || time.compareTo(end) < 0);
      } else {
        // Normal case, both times are on the same day
        print(
            'checkTimeSlotsVisibility Normal case. Checking: $time against start: $start and end: $end');
        return (time.compareTo(start) >= 0 && time.compareTo(end) < 0);
      }
    }

    // Check if selectedDate is today or tomorrow
    if (selectedDate.isAtSameMomentAs(today)) {
      // For today, check time range
      isLunchTimeSlotsVisible =
          !isTimeInRange(timeToCheck, startLunch, endLunch);
      isDinnerTimeSlotsVisible =
          !isTimeInRange(timeToCheck, startDinner, endDinner);
    } else {
      // Default case for other dates (if any)
      isLunchTimeSlotsVisible = true;
      isDinnerTimeSlotsVisible = false;
    }

    // Log the results of the visibility checks
    print(
        'checkTimeSlotsVisibility Lunch Time Slots Visible: $isLunchTimeSlotsVisible');
    print(
        'checkTimeSlotsVisibility Dinner Time Slots Visible: $isDinnerTimeSlotsVisible');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }
  DateTime now = DateTime.now();


  void selectTimeSlot(String timeSlot, String type) {
    setState(() {
      selectedTimeSlot = timeSlot; // Update the selected time slot
      timetype = type; // Update the selected time slot
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    setState(() {
      dataSelected = true;
    });
    // Check if the controller has clients (is attached to the scrollable view)
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent, // Scroll to the bottom
        duration: Duration(milliseconds: 300), // Animation duration
        curve: Curves.easeInOut, // Optional easing curve
      );
    }
  }
  int? expandedIndex;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundBg,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            SizedBox(width: 0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.category_name == "Salon"
                      ? "Book Appointment"
                      : 'Book Table',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${widget.storeName}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: MyColors.textColor,
                  ),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: MyColors.backgroundBg,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                color: MyColors.whiteBG,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                        child: Text(
                          "Number of Guests",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(30, (index) {
                            int guestNumber = index + 1;
                            double leftMargin = index == 0 ? 16 : 4;
                            double rightMargin = index == 29 ? 16 : 4;
                            return GestureDetector(
                              onTap: () => _updateSelectedNumber(guestNumber),
                              child: Container(
                                width: 40,
                                height: 40,
                                margin: EdgeInsets.fromLTRB(
                                    leftMargin, 0, rightMargin, 0),
                                decoration: BoxDecoration(
                                  color: _selectedGuestNumber == guestNumber
                                      ? MyColors.primaryColor2
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: _selectedGuestNumber == guestNumber
                                        ? MyColors.primary
                                        : Colors.grey,
                                    width: 0.8,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  guestNumber.toString(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: _selectedGuestNumber == guestNumber
                                        ? MyColors.primary
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Card(
                color: MyColors.whiteBG,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                          child: Text(
                            'Select date?',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        bookModel.isNotEmpty&&bookModel.toString()!=""? SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(bookModel[0].days?.length??0, (index) {
                              final data= bookModel[0].days?[index];
                              // String endTime = "11:19 PM";
                              // DateTime now = DateTime.now();
                              // DateTime todayEndTime =
                              //     DateFormat("hh:mm a").parse(endTime);
                              // todayEndTime = DateTime(
                              //   now.year,
                              //   now.month,
                              //   now.day,
                              //   todayEndTime.hour,
                              //   todayEndTime.minute,
                              // );
                              DateTime date =
                                  DateTime.now().add(Duration(days: index));
                              // if (index == 0 &&
                              //     DateTime.now().isAfter(todayEndTime)) {
                              //   return SizedBox(
                              //     width: 10,
                              //   ); // Return an empty widget instead of null
                              // }
                              // String dateString =
                              //     DateFormat('d MMM').format(date);
                              // String dayString = DateFormat('EEE').format(date);
                              //
                              double leftMargin = index == 0 ? 16 : 4;
                              double rightMargin = index == 29 ? 16 : 4;
                              String dateString = data?.date.toString()??"2025-01-25"; // Given date format

                              // Parse the date
                              DateTime parsedDate = DateFormat("dd-MM-yyyy").parse(dateString);

                              // Format the date to "19-March"
                              String formattedDate = DateFormat("dd-MMM").format(parsedDate);

                              return GestureDetector(
                                onTap: (){
                                timeSlot(widget.store_id,data?.date,data?.day);
                                  data?.status!="Non-Active"? _updateSelectedDate(parsedDate):
                                    showErrorMessage(context, message: "Booking is close on $formattedDate");

                                },
                                child: Container(
                                  width: 65,
                                  height: 75,
                                  margin: EdgeInsets.fromLTRB(
                                      leftMargin, 0, rightMargin, 0),
                                  decoration: BoxDecoration(
                                    color: _selectedDate.year == date.year &&
                                            _selectedDate.month == date.month &&
                                            _selectedDate.day == date.day
                                        ? MyColors.primaryColor2
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: _selectedDate.year == date.year &&
                                              _selectedDate.month ==
                                                  date.month &&
                                              _selectedDate.day == date.day
                                          ? MyColors.primary
                                          : Colors.grey,
                                      width: 0.6,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                  // formattedDate,
                                        data?.status!="Non-Active"?DateFormat('EEE').format(DateTime.parse(parsedDate.toString())):"Booking Off",
                                        // data?.day.toString()??"",
                                        // dayString,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(

                                          fontSize: 15,
                                          color: _selectedDate.year ==
                                                      date.year &&
                                                  _selectedDate.month ==
                                                      date.month &&
                                                  _selectedDate.day == date.day
                                              ? MyColors.primary
                                              : Colors.black,
                                        ),
                                      ),
                                      data?.status!="Non-Active"? Text(
                                        formattedDate,
                                        // "",
                                        //   data?.date.toString()!=null? DateFormat('dd MMM').format(DateTime.parse("${data?.date.toString()??"2025-01-25"}00:00:00")):"",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: _selectedDate.year ==
                                                      date.year &&
                                                  _selectedDate.month ==
                                                      date.month &&
                                                  _selectedDate.day == date.day
                                              ? MyColors.primary
                                              : Colors.black,
                                        ),
                                      ):Container(),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ),
                        ):Center(child: Text("No Data")),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16, right: 16, top: 16, bottom: 16),
                          child: Text(
                            'Select the time of day to see the offers',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ),

                        bookModel.isNotEmpty&&bookModel.toString()!=""?  ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                            // itemCount: bookModel[0].weekday![0].meals?.length??0,
                            itemCount: bookModel[0].weekday?[0].meals?.length??0,
                            itemBuilder: (ctx,int mealIndex){
                            final mealData =  bookModel[0].weekday![0].meals![mealIndex];
                            bool isExpanded = expandedIndex == mealIndex;
                            print("SSSSSS:${bookModel[0].weekday?[0].meals?.length??0}");
                          return Container(
                            margin: EdgeInsets.only(
                                left: 16, right: 16, top: 0, bottom: 16),
                            decoration: BoxDecoration(
                              border:
                              Border.all(color: Colors.grey, width: 1.0),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.only(
                                left: 16, right: 16, top: 10, bottom: 26),
                            child: Column(
                              children: [
                                Center(
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: [
                                          // mealData.t03FoodType=="Breakfast"||mealData.t03FoodType=="Lunch"
                                          mealData.t03FoodType=="Breakfast"
                                              ? Image.asset(
                                            'assets/images/lunch.png',
                                            width: 40,
                                            height: 40,
                                          ):mealData.t03FoodType=="Lunch"?Image.asset(
                                            'assets/images/breakfast.png',
                                            width: 30,
                                            height: 30,
                                          ):Image.asset(
                                          'assets/images/dinner.png',
                                          width: 40,
                                          height: 40,
                                        ),
                                          SizedBox(width: 10),
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                mealData.t03FoodType??"", // Title
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                  "${ DateFormat('hh:mm a').format(DateTime.parse(mealData.time?.first.t01Time.toString()??"") )
                                                  } to ${DateFormat('hh:mm a').format(DateTime.parse(mealData.time?.last.t01Time.toString()??"") )} ",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      GestureDetector(
                                        onTap: (){
                                          setState(() {
                                            expandedIndex = isExpanded ? null : mealIndex;
                                            // selectedIndex=mealIndex;
                                            // isLunchTimeSlotsVisibleIndex=mealIndex;
                                            // selectedIndex==mealIndex ?
                                            // toggleLunchTimeSlotsVisibility()
                                            //     :null;
                                          });


                                          },
                                        // Toggle lunch time slots on click
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                            border:
                                            Border.all(color: Colors.grey),
                                          ),
                                          child: Icon(
                                            // isLunchTimeSlotsVisible
                                            // selectedIndex==mealIndex && isLunchTimeSlotsVisible|| isLunchTimeSlotsVisibleIndex==mealIndex
                                            isExpanded   ? Icons
                                                .keyboard_arrow_up_outlined
                                                : Icons
                                                .keyboard_arrow_down_outlined,
                                            size: 20,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // if (selectedIndex==mealIndex || isLunchTimeSlotsVisible&& isLunchTimeSlotsVisibleIndex==mealIndex)
                                if (isExpanded )
                                  Padding(
                                    padding: const EdgeInsets.only(top:18.0),
                                    child: SizedBox(
                                      // height: heights*0.3,
                                      child: GridView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: mealData.time?.length??0,
                                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          crossAxisSpacing: 10,
                                          mainAxisSpacing: 10,
                                          childAspectRatio: 8/4,
                                        ),
                                        itemBuilder: (BuildContext context, int timeIndex) {
                                          final data =mealData.time![timeIndex];
                                          return
                                            TimeSlotCard(
                                            timeSlot: data.t01Time.toString()??"",
                                            isSelected:
                                            selectedTimeSlot ==  data.t01Time,
                                            onTap: (){
                                              setState(() {
                                                availableSeat=data.t02Noofseats??0;
                                                prebookoffer(widget.store_id.toString(),data.to2Id.toString(),DateFormat('yyyy-MM-dd').format(_selectedDate));

                                              });
                                              print("WWW");
                                              selectTimeSlot(data.t01Time.toString()??"", widget.category_name == "Salon" ? 'Day' : mealData.t03FoodType.toString()??"");}
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                // Align(
                                //   alignment: Alignment.topLeft,
                                //   child: Wrap(
                                //     spacing: 10.0,
                                //     runSpacing: 10.0,
                                //     children: timeSlotsLunch
                                //         .map((slot) => TimeSlotCard(
                                //       timeSlot: slot,
                                //       isSelected:
                                //       selectedTimeSlot == slot,
                                //       onTap: () => selectTimeSlot(
                                //           slot,
                                //           widget.category_name ==
                                //               "Salon"
                                //               ? 'Day'
                                //               : "Lunch"),
                                //     ))
                                //         .toList(),
                                //   ),
                                // ),
                                //   SizedBox(height: 20),
                                // if (isLunchTimeSlotsVisible)
                                //   Container(
                                //     height: heights*0.3,
                                //     child: GridView.builder(
                                //       shrinkWrap: true,
                                //       itemCount: bookModel[0].weekday?[0].meals![0].time!.length,
                                //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                //         crossAxisCount: 3,
                                //         crossAxisSpacing: 0,
                                //         mainAxisSpacing: 0,
                                //         childAspectRatio: 8.5/4,
                                //       ),
                                //       itemBuilder: (BuildContext context, int index) {
                                //         print(bookModel[0].weekday?[0].meals?[index].time?.length);
                                //         final data =bookModel[0].weekday?[0].meals![0].time![index];
                                //         return TimeSlotCard(
                                //           timeSlot: data!.t01Time.toString()??"",
                                //           isSelected:
                                //           selectedTimeSlot ==  data.t01Time,
                                //           onTap: () => selectTimeSlot(
                                //               data.t01Time.toString()??"",
                                //               widget.category_name ==
                                //                   "Salon"
                                //                   ? 'Day'
                                //                   : "Lunch"),
                                //         );
                                //       },
                                //     ),
                                //   ),
                                // Align(
                                //   alignment: Alignment.topLeft,
                                //   child: Wrap(
                                //     spacing: 10.0,
                                //     runSpacing: 10.0,
                                //     children: timeSlotsLunch
                                //         .map((slot) => TimeSlotCard(
                                //               timeSlot: slot,
                                //               isSelected:
                                //                   selectedTimeSlot == slot,
                                //               onTap: () => selectTimeSlot(
                                //                   slot,
                                //                   widget.category_name ==
                                //                           "Salon"
                                //                       ? 'Day'
                                //                       : "Lunch"),
                                //             ))
                                //         .toList(),
                                //   ),
                                // ),
                              ],
                            ),
                          );
                        }):Center(child: Text("No Data")),
                      ]),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              if (dataSelected)
                Card(
                  color: MyColors.whiteBG,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                            child: Row(
                              children: [
                                ClipRect(
                                  child: SizedBox(
                                    height: 40,
                                    width: 40,
                                    child: Image.asset(
                                      'assets/images/exclusive_img.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Select offer to proceed?',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16),
                          PrebookOfferListWidget(
                            storeId: widget.store_id,
                            prebookofferlist: prebookofferlist,
                            onSelectedItemChanged: (selectedItem) {
                              setState(() {
                                selectedPreBookOffer = selectedItem;
                              });
                              print(
                                  "Selected Item: ${selectedPreBookOffer?.title}");
                            },
                            availableSeat: availableSeat,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 0, 10),
                            child: Text(
                              'Coupon & additional offers available during bill payment',
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: MyColors.txtDescColor2),
                            ),
                          ),
                        ]),
                  ),
                ),
              if (dataSelected)
                SizedBox(
                  height: 10,
                ),
              if (dataSelected) OfferTermsWidget(termConditionList),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
        decoration: BoxDecoration(
          color: Colors.white, // Background color of the Container
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
          child: ElevatedButton(
            onPressed:
                (selectedTimeSlot != null && selectedPreBookOffer != null)
                    ? () {
                        String guest = "$_selectedGuestNumber";
                        String visitingdate =
                            DateFormat('yyyy-MM-dd').format(_selectedDate);
                        String visitingtime = selectedTimeSlot ?? '';
                        String timetype2 = timetype ?? '';

                        print(
                          "Proceed clicked - timetype: $timetype2,  Guest: $guest, Date: $visitingdate, Time: $visitingtime, Offer ID: ${selectedPreBookOffer!.id}",
                        );
                        if (_selectedGuestNumber > availableSeat) {
                          showErrorMessage(context,
                              message: 'There is not a sufficient seats');
                        } else {

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ConfirmBookingScreen(
                                    guest,
                                    visitingdate,
                                    visitingtime,
                                    timetype!,
                                    selectedPreBookOffer!)),
                          );
                        }
                      }
                    : null, // Disable button if either is null
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  (selectedTimeSlot != null && selectedPreBookOffer != null)
                      ? MyColors.primary // Enabled color
                      : Colors.grey, // Disabled color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              "Proceed",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> fetchStoresTermCondition() async {
    try {
      final response = await ApiServices.api_store_termconditions();
      if (response != null) {
        setState(() {
          termConditionList = response;
        });
      }
    } catch (e) {
      print('fetchStores: $e');
    }
  }

  Future<void> prebookoffer(String store_id,dynamic time_id,dynamic bookingDate) async {
    print('prebookoffer: store_id $store_id');
    print('prebookoffer: store_id $time_id');
    print('prebookoffer: store_id $bookingDate');
    print('😊😊😊');
    try {
      final body = {"store_id": store_id,"time_id":time_id,"booking_date":bookingDate};
      final response = await ApiServices.PreBookOffer(body);
      print('prebookoffer: response $response');
      if (response != null) {
        setState(() {
          prebookofferlist = response;
          isLoading = false; // Set isLoading to false when fetching ends
        });
      } else {
        setState(() {
          isLoading = false; // Set isLoading to false when fetching ends
        });
      }
    } catch (e) {
      print('preboofer: $e');
      setState(() {
        isLoading = false; // Set isLoading to false in case of error
      });
    }
  }
  Future<void> timeSlot(String store_id,dynamic date,dynamic day) async {
    print(date);
    print(day);
    print("MMMMM");
    print("MMM3333333MM");
    setState(() {
      isLoading=true;
    });
    try {
      final body = {
        "store_id": "$store_id",
        "date": "$date",
        "day": "$day",
      };
      final response = await ApiServices.timeSlot(body);
      print('👍: response $response');
      if (response != null) {
        setState(() {
          bookModel = response;
          isLoading = false;
          print('😶‍🌫️: response ${bookModel[0].weekday?[0].t04Weekday}');
          // Set isLoading to false when fetching ends
        });
      } else {
        setState(() {
          isLoading = false; // Set isLoading to false when fetching ends
        });
      }
    } catch (e) {
      print('Slot: $e');
      setState(() {
        isLoading = false; // Set isLoading to false in case of error
      });
    }
  }
}

// class TimeSlotCard extends StatelessWidget {
//   final String timeSlot;
//   final bool isSelected;
//   final VoidCallback onTap;
//
//   TimeSlotCard({
//     required this.timeSlot,
//     required this.isSelected,
//     required this.onTap,
//   });
//   DateTime date =
//   DateTime.now();
//   @override
//   Widget build(BuildContext context) {
//     print(date);
//     // print("😊😊${(DateFormat("HH:mm").parse(date.toString()))}");
//     print("😊😊${timeSlot}");
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         alignment: Alignment.center,
//         padding: EdgeInsets.all(10.0),
//         decoration: BoxDecoration(
//           color: isSelected
//               ? MyColors.primaryColor.withOpacity(0.2)
//               : Colors.white,
//           border: Border.all(
//               color: isSelected ? MyColors.primaryColor : Colors.grey),
//           borderRadius: BorderRadius.circular(10.0),
//         ),
//         child: Text(
//
//           // "😊😊${(DateFormat("HH:mm").parse(date.toString()))}",
//           timeSlot,
//           style: TextStyle(
//             fontSize: 12.0,
//             fontWeight: FontWeight.bold,
//             color: isSelected ? MyColors.primaryColor : Colors.black,
//           ),
//         ),
//       ),
//     );
//   }
// }




// class TimeSlotCard extends StatelessWidget {
//   final String timeSlot;
//   final bool isSelected;
//   final VoidCallback onTap;
//
//   TimeSlotCard({
//     required this.timeSlot,
//     required this.isSelected,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     DateTime now = DateTime.now();
//
//     // Convert `timeSlot` (String) to `DateTime` with today's date
//     DateTime formattedSlotTime;
//     try {
//       formattedSlotTime = DateFormat("h:mm a").parse(timeSlot); // Handles "1:30 PM" format
//       formattedSlotTime = DateTime(now.year, now.month, now.day, formattedSlotTime.hour, formattedSlotTime.minute);
//     } catch (e) {
//       print("Error parsing timeSlot: $timeSlot - $e");
//       return Container(); // Avoid crash by returning an empty widget
//     }
//
//     // Get the current time
//     DateTime currentTime = DateTime(now.year, now.month, now.day, now.hour, now.minute);
//
//     bool isPast = formattedSlotTime.isBefore(currentTime);
//
//     return GestureDetector(
//       onTap: isPast ? null : onTap, // Disable tap if past time
//       child: Opacity(
//         opacity: isPast ? 0.5 : 1.0, // Fade past time slots
//         child: Container(
//           alignment: Alignment.center,
//           padding: EdgeInsets.all(10.0),
//           decoration: BoxDecoration(
//             color: isSelected
//                 ? MyColors.primaryColor.withOpacity(0.2)
//                 : Colors.white,
//             border: Border.all(
//                 color: isSelected ? MyColors.primaryColor : Colors.grey),
//             borderRadius: BorderRadius.circular(10.0),
//           ),
//           child: Text(
//             timeSlot,
//             style: TextStyle(
//               fontSize: 12.0,
//               fontWeight: FontWeight.bold,
//               color: isPast ? Colors.grey : (isSelected ? MyColors.primaryColor : Colors.black),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

class TimeSlotCard extends StatelessWidget {
  final String timeSlot;
  final bool isSelected;
  final VoidCallback onTap;

  TimeSlotCard({
    required this.timeSlot,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();

    // Convert `timeSlot` (String) to `DateTime`
    DateTime formattedSlotTime;
    try {
      formattedSlotTime = DateTime.parse(timeSlot); // Fix: Directly parse DateTime
    } catch (e) {
      print("Error parsing timeSlot: $timeSlot - $e");
      return Container(); // Avoid crash
    }

    // Get the current time
    DateTime currentTime = DateTime(now.year, now.month, now.day, now.hour, now.minute);

    bool isPast = formattedSlotTime.isBefore(currentTime);

    return GestureDetector(
      onTap: isPast ? null : onTap, // Disable tap if past time
      child: Opacity(
        opacity: isPast ? 0.5 : 1.0, // Fade past time slots
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: isSelected
                ? MyColors.primaryColor.withOpacity(0.2)
                : Colors.white,
            border: Border.all(
                color: isSelected ? MyColors.primaryColor : Colors.grey),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Text(
            DateFormat('hh:mm a').format(DateTime.parse(timeSlot))
            , // Keep original format
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
              color: isPast ? Colors.grey : (isSelected ? MyColors.primaryColor : Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}

class BookingInfoCard extends StatelessWidget {
  final String title;
  final String bookingFee;
  final int availableSeat;

  const BookingInfoCard({
    Key? key,
    required this.title,
    required this.bookingFee,
    required this.availableSeat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title with text wrapping
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: widths*0.53,
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 5), // Spacing between title and booking fee
        // Booking fee with text wrapping
        Text(
          'Booking Fee: ₹$bookingFee per Guest',
          style: TextStyle(
            fontSize: 12,
          ),
        ),
        SizedBox(height: 5),
        Text(
          (int.tryParse(availableSeat.toString()) ?? 0) <= 0
              ? "Sold Out"
              : '${int.tryParse(availableSeat.toString())} seat${(int.tryParse(availableSeat.toString()) ?? 0) != 1 ? 's' : ''} left',
          style: TextStyle(
            fontSize: 14,
            color: (int.tryParse(availableSeat.toString()) ?? 0) <= 0
                ? MyColors.redBG
                : Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
        (int.tryParse(availableSeat.toString()) ?? 0) <= 0
            ? Text(
                'Try Another day ',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: MyColors.redBG),
              )
            : Container(),
      ],
    );
  }
}

class PrebookOfferListWidget extends StatefulWidget {
  final String storeId;
  final List<PreBookTable> prebookofferlist;
  final ValueChanged<PreBookTable?> onSelectedItemChanged;
  final int availableSeat; // Callback function

  PrebookOfferListWidget({
    required this.storeId,
    required this.prebookofferlist,
    required this.onSelectedItemChanged,
    required this.availableSeat,
  });

  @override
  _PrebookOfferListWidgetState createState() => _PrebookOfferListWidgetState();
}

class _PrebookOfferListWidgetState extends State<PrebookOfferListWidget> {
  int? selectedItemId;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: List.generate(
          widget.prebookofferlist.length,
          (index) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  int id = widget.prebookofferlist[index].id;
                  if (selectedItemId == id) {
                    selectedItemId = null;
                    widget.onSelectedItemChanged(null); // Notify deselection
                  } else {
                    selectedItemId = id;
                    widget.onSelectedItemChanged(
                        widget.prebookofferlist[index]); // Notify selection
                  }
                });
              },
              child: _buildPrebookOfferWidget(
                context,
                widget.prebookofferlist[index],
                selectedItemId == widget.prebookofferlist[index].id,
                widget.prebookofferlist[index].available_seat

              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPrebookOfferWidget(
      BuildContext context, PreBookTable prebooktable, bool isSelected,dynamic available) {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 16),
      decoration: BoxDecoration(
        color:
            isSelected ? MyColors.primaryColor.withOpacity(0.2) : Colors.white,
        border: Border.all(
          color: isSelected ? MyColors.primaryColor : Colors.grey,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Radio<int>(
            value: prebooktable.id,
            groupValue: selectedItemId,
            onChanged: (int? value) {
              setState(() {
                selectedItemId = value;
                widget.onSelectedItemChanged(widget.prebookofferlist
                    .firstWhere((item) => item.id == value));
              });
            },
            activeColor: MyColors.primary,
          ),
          SizedBox(width: 10),
          BookingInfoCard(
            title: prebooktable.title,
            bookingFee: prebooktable.booking_fee,
            availableSeat: int.parse(available),
          ),
        ],
      ),
    );
  }
}
