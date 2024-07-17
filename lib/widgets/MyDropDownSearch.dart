import 'package:comsats_hero/models/subjexts.dart';
import 'package:comsats_hero/models/types.dart';
import 'package:comsats_hero/models/years.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';

class Mydropdownsearch extends StatefulWidget {
  const Mydropdownsearch(
      {super.key,
      required this.setYear,
      required this.setType,
      required this.setSubject});

  final void Function(String?) setYear;
  final void Function(String?) setType;
  final void Function(String?) setSubject;

  @override
  State<Mydropdownsearch> createState() => _MydropdownsearchState();
}

class _MydropdownsearchState extends State<Mydropdownsearch> {
  late Future<List<String>> subjectsFuture;
  late Future<List<String>> yearsFuture;
  late Future<List<String>> typesFuture;

  String? selectedYear;
  String? selectedType;
  String? selectedSubject;

  @override
  void initState() {
    super.initState();
    subjectsFuture = MySubjects.getSubjects();
    yearsFuture = MyYears.getYears();
    typesFuture = MyTypes.getTypes();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        FutureBuilder<List<String>>(
          future: yearsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return const Text('Error loading years');
            } else {
              final years = snapshot.data ?? [];
              return  DropdownSearch<String>(
                popupProps: PopupProps.menu(
                  showSelectedItems: true,
                  showSearchBox: true,
                  searchDelay: Duration(seconds: 0),
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: const Text('you can use the box below to search'),
                  ),
                  fit: FlexFit.loose,
                  constraints: const BoxConstraints(maxHeight: 300),
                ),
                items: years,
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: const InputDecoration(
                    labelText: "Year",
                    border: OutlineInputBorder(),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    widget.setYear(value);
                    selectedYear = value;
                  });
                },
                selectedItem: selectedYear,
              );
            }
          },
        ),
        const SizedBox(height: 20),
        FutureBuilder<List<String>>(future: typesFuture, builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return const Text('Error loading subjects');
          }
          else {
            final types = snapshot.data ?? [];
            return   DropdownSearch<String>(
              popupProps: PopupProps.menu(
                showSelectedItems: true,
                showSearchBox: true,
                title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: const Text('you can use the box below to search'),
                ),
                fit: FlexFit.loose,
                constraints: const BoxConstraints(maxHeight: 300),
              ),
              items: types,
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: const InputDecoration(
                  labelText: "Type",
                  border: OutlineInputBorder(),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  widget.setType(value);
                  selectedType = value;
                });
              },
              selectedItem: selectedType,
            );

        }
        },),
        const SizedBox(height: 20),
        FutureBuilder<List<String>>(
          future: subjectsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return const Text('Error loading subjects');
            } else {
              final subjects = snapshot.data ?? [];
              return DropdownSearch<String>(
                popupProps: PopupProps.menu(
                  showSelectedItems: true,
                  showSearchBox: true,
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: const Text('you can use the box below to search'),
                  ),
                  fit: FlexFit.loose,
                  constraints: const BoxConstraints(maxHeight: 300),
                ),
                items: subjects,
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: const InputDecoration(
                    labelText: "Subject",
                    border: OutlineInputBorder(),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    widget.setSubject(value);
                    selectedSubject = value;
                  });
                },
                selectedItem: selectedSubject,
              );
            }
          },
        ),
      ],
    );
  }
}
