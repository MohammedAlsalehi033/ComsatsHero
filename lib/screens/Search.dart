import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comsats_hero/models/papers.dart';
import 'package:comsats_hero/models/subjexts.dart';
import 'package:comsats_hero/theme/Colors.dart';
import 'package:comsats_hero/widgets/Cards.dart';
import 'package:comsats_hero/widgets/MyDropDownSearch.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with SingleTickerProviderStateMixin {
  final List<String> years = ['2022', '2021', '2020', '2019', '2018'];
  final List<String> types = ['Mid', 'Final'];
  late Future<List<String>> subjectsFuture;

  String? selectedYear;
  String? selectedType;
  String? selectedSubject;
  String loading = "Select the proper choices from above, and press on search";

  List<Map<String, dynamic>> searchResults = [];

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    subjectsFuture = MySubjects.getSubjects();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _searchPapers() async {
    final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult.contains(ConnectivityResult.none)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No internet connection. Please check your connection and try again.')),
      );
    } else {
      if (selectedSubject != null) {
        Stream<QuerySnapshot> results = PaperService.searchPapers(
          subject: selectedSubject!,
          year: selectedYear,
          type: selectedType,
        );

        results.listen((QuerySnapshot snapshot) {
          setState(() {
            searchResults = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
            _controller.forward(from: 0.0); // Trigger the animation on new search results
          });
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a subject')),
        );
      }
    }

    setState(() {
      loading = "No paper was found, maybe you can help by uploading some papers";
    });
  }

  void setSubject(String? subject) {
    setState(() {
      selectedSubject = subject;
    });
  }

  void setYear(String? year) {
    setState(() {
      selectedYear = year;
    });
  }

  void setType(String? type) {
    setState(() {
      selectedType = type;
    });
  }

  @override
  Widget build(BuildContext context) {
    final myColors = Provider.of<MyColors>(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Search for Papers',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            AnimatedOpacity(
              opacity: 1.0,
              duration: const Duration(milliseconds: 500),
              child: Mydropdownsearch(setSubject: setSubject, setType: setType, setYear: setYear),
            ),
            const SizedBox(height: 20),
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              child: ElevatedButton(
                onPressed: _searchPapers,
                child: Text(
                  'Search',
                  style: TextStyle(color: myColors.textColorLight),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: myColors.primaryColorLight,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: searchResults.isEmpty
                  ? Center(
                child: FadeTransition(
                  opacity: _animation,
                  child: Text(loading),
                ),
              )
                  : ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  final paper = searchResults[index];
                  return ScaleTransition(
                    scale: _animation,
                    child: MyCards.cardForPapers(
                      paper['subject'],
                      paper['year'].toString(),
                      paper['type'],
                      paper['downloadURL'],
                      context,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      backgroundColor: myColors.backgroundColor,
    );
  }
}
