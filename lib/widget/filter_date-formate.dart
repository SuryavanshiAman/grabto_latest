import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../theme/theme.dart';


class FilterDateFormat extends StatefulWidget {
  const FilterDateFormat({
    Key? key, // Fix super.key
    required void Function(DateTime selectedDate) onDateSelected,
  }) : _onDateSelected = onDateSelected, super(key: key); // Fix super.key

  final void Function(DateTime selectedDate) _onDateSelected;

  @override
  _FilterDateFormatState createState() => _FilterDateFormatState();
}

class _FilterDateFormatState extends State<FilterDateFormat> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    ///sir yaha hai arrow down button
    return IconButton(onPressed: () { _showMonthPicker(context); }, icon: const Icon(Icons.keyboard_arrow_down,color: Colors.white,),);
  }

  Future<void> _showMonthPicker(BuildContext context) async {
    DateTime? selectedDate = await showModalBottomSheet(
      backgroundColor:MyColors.blackBG,
      shape: const RoundedRectangleBorder(
          borderRadius:   BorderRadius.only(
              topRight: Radius.circular(10), topLeft: Radius.circular(10))
      ),
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          decoration: BoxDecoration(
            // color: Colors.blue,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            //mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        // Handle Cancel button tap
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Text(
                      'Select a date',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        // Handle Confirm button tap
                        Navigator.pop(context, _selectedDate);
                      },
                      child: const Text(
                        'Confirm',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                // color: Colors.purple,
                height: 220,
                child: _buildMonthPicker(),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        );
      },
    );

    if (selectedDate != null) {
      setState(() {
        _selectedDate = selectedDate;
      });
      widget._onDateSelected(selectedDate);
    }
  }

  // Widget _buildMonthPicker() {
  //   int daysInMonth = DateTime(_selectedDate.year, _selectedDate.month + 1, 0).day;
  //   return Row(
  //     children: [
  //       Expanded(
  //         child: CupertinoPicker(
  //
  //           selectionOverlay: const CupertinoPickerDefaultSelectionOverlay(
  //             background: CupertinoDynamicColor.withBrightness(
  //               color: Colors.transparent,
  //               darkColor: Colors.transparent,
  //             ),
  //           ),
  //           scrollController: FixedExtentScrollController(
  //             initialItem: _selectedDate.year - 2024,
  //           ),
  //           itemExtent: 40,
  //           onSelectedItemChanged: (yearIndex) {
  //             setState(() {
  //               _selectedDate = DateTime(2024 + yearIndex, _selectedDate.month, _selectedDate.day);
  //             });
  //           },
  //           children: List.generate(2050 - 2024 + 1, (yearIndex) {
  //             final year = 2024 + yearIndex;
  //             return Center(
  //               child: Text(
  //                 year.toString(),
  //                 style: const TextStyle(fontSize: 17,color: Colors.white),
  //               ),
  //             );
  //           }),
  //         ),
  //       ),
  //
  //       Expanded(
  //         child: CupertinoPicker(
  //           scrollController: FixedExtentScrollController(
  //             initialItem: _selectedDate.month - 1,
  //           ),
  //           itemExtent: 40,
  //           onSelectedItemChanged: (monthIndex) {
  //             setState(() {
  //               _selectedDate = DateTime(_selectedDate.year, monthIndex + 1, _selectedDate.day);
  //             });
  //           },
  //           selectionOverlay: const CupertinoPickerDefaultSelectionOverlay(
  //             background: CupertinoDynamicColor.withBrightness(
  //               color: Colors.transparent,
  //               darkColor: Colors.transparent,
  //             ),
  //           ),
  //           children: List.generate(12, (monthIndex) {
  //             return Center(
  //               child: Text(
  //                 DateFormat('MM').format(DateTime(_selectedDate.year, monthIndex + 1)),
  //                 style: const TextStyle(fontSize: 17,color: Colors.white),
  //               ),
  //             );
  //           }),
  //         ),
  //       ),
  //       Expanded(
  //         child: CupertinoPicker(
  //           scrollController: FixedExtentScrollController(
  //             initialItem: _selectedDate.day - 1,
  //           ),
  //           itemExtent: 40,
  //           onSelectedItemChanged: (dayIndex) {
  //             setState(() {
  //               _selectedDate = DateTime(_selectedDate.year, _selectedDate.month, dayIndex + 1);
  //             });
  //           },
  //           selectionOverlay: const CupertinoPickerDefaultSelectionOverlay(
  //             background: CupertinoDynamicColor.withBrightness(
  //               color: Colors.transparent,
  //               darkColor: Colors.transparent,
  //             ),
  //           ),
  //           children: List.generate(daysInMonth, (dayIndex) {
  //             return Center(
  //               child: Text(
  //                 (dayIndex + 1).toString(),
  //                 style: const TextStyle(fontSize: 17,color: Colors.white),
  //               ),
  //             );
  //           }),
  //         ),
  //       ),
  //     ],
  //   );
  // }
  Widget _buildMonthPicker() {
    int daysInMonth = DateTime(_selectedDate.year, _selectedDate.month + 1, 0).day;

    return Row(
      children: [
        Expanded(
          child: CupertinoPicker(
            scrollController: FixedExtentScrollController(
              initialItem: _selectedDate.day - 1, // Set the scroll to the current day
            ),
            itemExtent: 40,
            onSelectedItemChanged: (dayIndex) {
              setState(() {
                _selectedDate = DateTime(_selectedDate.year, _selectedDate.month, dayIndex + 1);
              });
            },
            selectionOverlay: const CupertinoPickerDefaultSelectionOverlay(
              background: CupertinoDynamicColor.withBrightness(
                color: Colors.transparent,
                darkColor: Colors.transparent,
              ),
            ),
            children: List.generate(daysInMonth, (dayIndex) {
              return Center(
                child: Text(
                  (dayIndex + 1).toString(),
                  style: const TextStyle(fontSize: 17, color: Colors.white),
                ),
              );
            }),
          ),
        ),


        Expanded(
          child: CupertinoPicker(
            scrollController: FixedExtentScrollController(
              initialItem: _selectedDate.month - 1, // Set the scroll to the current month
            ),
            itemExtent: 40,
            onSelectedItemChanged: (monthIndex) {
              setState(() {
                _selectedDate = DateTime(_selectedDate.year, monthIndex + 1, _selectedDate.day);
              });
            },
            selectionOverlay: const CupertinoPickerDefaultSelectionOverlay(
              background: CupertinoDynamicColor.withBrightness(
                color: Colors.transparent,
                darkColor: Colors.transparent,
              ),
            ),
            children: List.generate(12, (monthIndex) {
              return Center(
                child: Text(
                  DateFormat('MMM').format(DateTime(_selectedDate.year, monthIndex + 1)),
                  style: const TextStyle(fontSize: 17, color: Colors.white),
                ),
              );
            }),
          ),
        ),

        Expanded(
          child: CupertinoPicker(
            selectionOverlay: const CupertinoPickerDefaultSelectionOverlay(
              background: CupertinoDynamicColor.withBrightness(
                color: Colors.transparent,
                darkColor: Colors.transparent,
              ),
            ),
            scrollController: FixedExtentScrollController(
              initialItem: _selectedDate.year - 1885, // Start from 1885
            ),
            itemExtent: 40,
            onSelectedItemChanged: (yearIndex) {
              setState(() {
                _selectedDate = DateTime(1885 + yearIndex, _selectedDate.month, _selectedDate.day);
              });
            },
            children: List.generate(DateTime.now().year - 1885 + 1, (yearIndex) {
              final year = 1885 + yearIndex;
              return Center(
                child: Text(
                  year.toString(),
                  style: const TextStyle(fontSize: 17, color: Colors.white),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  // Widget _buildMonthPicker() {
  //   int daysInMonth = DateTime(_selectedDate.year, _selectedDate.month + 1, 0).day;
  //
  //   return Row(
  //     children: [
  //       Expanded(
  //         child: CupertinoPicker(
  //           selectionOverlay: const CupertinoPickerDefaultSelectionOverlay(
  //             background: CupertinoDynamicColor.withBrightness(
  //               color: Colors.transparent,
  //               darkColor: Colors.transparent,
  //             ),
  //           ),
  //           scrollController: FixedExtentScrollController(
  //             initialItem: _selectedDate.year - 1885, // Set the scroll to the current year
  //           ),
  //           itemExtent: 40,
  //           onSelectedItemChanged: (yearIndex) {
  //             setState(() {
  //               _selectedDate = DateTime(1885 + yearIndex, _selectedDate.month, _selectedDate.day);
  //             });
  //           },
  //           children: List.generate(2050 - 1885 + 1, (yearIndex) {
  //             final year = 1885 + yearIndex;
  //             return Center(
  //               child: Text(
  //                 year.toString(),
  //                 style: const TextStyle(fontSize: 17, color: Colors.white),
  //               ),
  //             );
  //           }),
  //         ),
  //       ),
  //
  //       Expanded(
  //         child: CupertinoPicker(
  //           scrollController: FixedExtentScrollController(
  //             initialItem: _selectedDate.month - 1, // Set the scroll to the current month
  //           ),
  //           itemExtent: 40,
  //           onSelectedItemChanged: (monthIndex) {
  //             setState(() {
  //               _selectedDate = DateTime(_selectedDate.year, monthIndex + 1, _selectedDate.day);
  //             });
  //           },
  //           selectionOverlay: const CupertinoPickerDefaultSelectionOverlay(
  //             background: CupertinoDynamicColor.withBrightness(
  //               color: Colors.transparent,
  //               darkColor: Colors.transparent,
  //             ),
  //           ),
  //           children: List.generate(12, (monthIndex) {
  //             return Center(
  //               child: Text(
  //                 DateFormat('MM').format(DateTime(_selectedDate.year, monthIndex + 1)),
  //                 style: const TextStyle(fontSize: 17, color: Colors.white),
  //               ),
  //             );
  //           }),
  //         ),
  //       ),
  //
  //       Expanded(
  //         child: CupertinoPicker(
  //           scrollController: FixedExtentScrollController(
  //             initialItem: _selectedDate.day - 1, // Set the scroll to the current day
  //           ),
  //           itemExtent: 40,
  //           onSelectedItemChanged: (dayIndex) {
  //             setState(() {
  //               _selectedDate = DateTime(_selectedDate.year, _selectedDate.month, dayIndex + 1);
  //             });
  //           },
  //           selectionOverlay: const CupertinoPickerDefaultSelectionOverlay(
  //             background: CupertinoDynamicColor.withBrightness(
  //               color: Colors.transparent,
  //               darkColor: Colors.transparent,
  //             ),
  //           ),
  //           children: List.generate(daysInMonth, (dayIndex) {
  //             return Center(
  //               child: Text(
  //                 (dayIndex + 1).toString(),
  //                 style: const TextStyle(fontSize: 17, color: Colors.white),
  //               ),
  //             );
  //           }),
  //         ),
  //       ),
  //     ],
  //   );
  // }

}