import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comsats_hero/additionals/lists.dart';
import 'package:comsats_hero/models/papers.dart';
import 'package:comsats_hero/models/subjexts.dart';
import 'package:comsats_hero/theme/Colors.dart';
import 'package:comsats_hero/widgets/Cards.dart';
import 'package:comsats_hero/widgets/MyDropDownSearch.dart';
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


  void setSubject(String? subject){
    selectedSubject = subject;
  }
  void setYear(String? year){
    selectedYear = year;
  }
  void setType(String? type){
    selectedType = type;
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
              'Search for Papers',textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Mydropdownsearch(setSubject: setSubject, setType: setType,setYear: setYear,),
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
                      paper['subject'], paper['year'].toString() ?? paper['year'] , paper['type'], paper['downloadURL'], context);
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
