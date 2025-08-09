import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:comsats_hero/models/Sections.dart';
import 'package:comsats_hero/theme/Colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SectionDropdown extends StatefulWidget {
  const SectionDropdown({super.key, required this.setSection});

  final void Function(String?) setSection;

  @override
  State<SectionDropdown> createState() => _SectionDropdownState();
}

class _SectionDropdownState extends State<SectionDropdown> {
  late Future<List<String>> sectionsFuture;
  String? selectedSection;

  @override
  void initState() {
    super.initState();
    sectionsFuture = Sections.getAllSections();
  }

  @override
  Widget build(BuildContext context) {
    final myColors = Provider.of<MyColors>(context);

    return FutureBuilder<List<String>>(
      future: sectionsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SpinKitCircle(
            color: myColors.primaryColorLight,
            size: 50.0.sp, // Use ScreenUtil for size
          );
        } else if (snapshot.hasError) {
          return const Text('Error loading sections');
        } else {
          final sections = snapshot.data ?? [];
          return DropdownSearch<String>(
            popupProps: PopupProps.menu(
              showSelectedItems: true,
              showSearchBox: true,
              title: Padding(
                padding: EdgeInsets.all(8.0.sp), // Use ScreenUtil for padding
                child: const Text('You can use the box below to search'),
              ),
              fit: FlexFit.loose,
              constraints: BoxConstraints(maxHeight: 300.h), // Use ScreenUtil for height
              menuProps: MenuProps(backgroundColor: myColors.primaryColorDark),
            ),
            items: sections,
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                labelText: "Section",
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: myColors.primaryColorLight),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: myColors.primaryColorLight),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: myColors.primaryColor),
                ),
              ),
            ),
            onChanged: (value) {
              setState(() {
                widget.setSection(value);
                selectedSection = value;
              });
            },
            selectedItem: selectedSection,
          );
        }
      },
    );
  }
}
