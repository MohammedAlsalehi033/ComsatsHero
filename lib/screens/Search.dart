import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comsats_hero/additionals/lists.dart';
import 'package:comsats_hero/models/papers.dart';
import 'package:comsats_hero/models/subjexts.dart';
import 'package:comsats_hero/theme/Colors.dart';
import 'package:comsats_hero/widgets/Cards.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final List<String> years = ['2022', '2021', '2020', '2019', '2018'];
  final List<String> types = ['Mid', 'Final'];
  late Future<List<String>> subjectsFuture;

  String? selectedYear;
  String? selectedType;
  String? selectedSubject;

  List<Map<String, dynamic>> searchResults = [];

  @override
  void initState() {
    super.initState();
    subjectsFuture = MySubjects.getSubjects();
  }

  void _searchPapers() {
    if (selectedSubject != null) {
      Stream<QuerySnapshot> results = PaperService.searchPapers(
        subject: selectedSubject!,
        year: selectedYear,
        type: selectedType,
      );

      results.listen((QuerySnapshot snapshot) {
        setState(() {
          searchResults = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
        });
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a subject')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Search for Papers',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            DropdownSearch<String>(
              popupProps: PopupProps.menu(
                showSelectedItems: true,
                showSearchBox: true,
                searchDelay: Duration(seconds: 0),
                title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: const Text('Select Year'),
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
                  selectedYear = value;
                });
              },
              selectedItem: selectedYear,
            ),
            const SizedBox(height: 20),
            DropdownSearch<String>(
              popupProps: PopupProps.menu(
                showSelectedItems: true,
                showSearchBox: true,
                title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: const Text('Select Type'),
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
                  selectedType = value;
                });
              },
              selectedItem: selectedType,
            ),
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
                        child: const Text('Select Subject'),
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
                        selectedSubject = value;
                      });
                    },
                    selectedItem: selectedSubject,
                  );
                }
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _searchPapers,
              child: const Text(
                'Search',
                style: TextStyle(color: MyColors.textColorLight),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: MyColors.primaryColorLight,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: searchResults.isEmpty
                  ? const Center(child: Text('No results found'))
                  : ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  final paper = searchResults[index];
                  return MyCards.cardForPapers(
                      paper['subject'], paper['year'], paper['type'], paper['downloadURL'], context);
                },
              ),
            ),
          ],
        ),
      ),
      backgroundColor: MyColors.backgroundColor,
    );
  }
}
