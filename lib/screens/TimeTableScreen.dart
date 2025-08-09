import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comsats_hero/models/Sections.dart';
import 'package:comsats_hero/theme/Colors.dart';
import 'package:comsats_hero/widgets/MySectionDropdown.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TimeTableScreen extends StatefulWidget {
  const TimeTableScreen({super.key});

  @override
  _TimeTableScreenState createState() => _TimeTableScreenState();
}

class _TimeTableScreenState extends State<TimeTableScreen> {
  String? selectedSection; // Variable for selected section
  String loadingMessage = "Select a section and press search.";
  List<Map<String, dynamic>> examTimings = []; // To store exam timings

  @override
  void initState() {
    super.initState();
  }

  void _fetchExamTimings() async {
    final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult.contains(ConnectivityResult.none)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No internet connection. Please check your connection and try again.')),
      );
    } else {
      if (selectedSection != null) {
        Stream<DocumentSnapshot> resultStream = Sections.getExamTimings(selectedSection!);

        resultStream.listen((DocumentSnapshot snapshot) {
          if (snapshot.exists) {
            List<dynamic> examData = snapshot['exam_data'];
            setState(() {
              examTimings = examData.map((item) => item as Map<String, dynamic>).toList();
            });
          } else {
            setState(() {
              loadingMessage = "No exam timings found. Please try another section.";
            });
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a section.')),
        );
      }
    }
  }

  void setSection(String? section) {
    setState(() {
      selectedSection = section;
    });
  }

  Future<void> shareToWhatsapp() async {
    // Removed whatsapp_share functionality
    // (Functionality disabled)
  }


  @override
  Widget build(BuildContext context) {
    final myColors = Provider.of<MyColors>(context);

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(6.0.sp), // Reduced padding for more compact layout
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 8.h),
            const Text(
              'Search Exam Timings',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold), // Smaller font size
            ),
            SizedBox(height: 8.h), // Reduced height
            FutureBuilder(future: Sections.getLastTimeUpdated(), builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("last time this data was updated: ");
    }
    if (snapshot.hasError) {
                return const Text('Error loading sections');
              } else {
                Timestamp lastUpdated = snapshot.data!['lastUpdated'] as Timestamp;
                return  Text("last time this data was updated: " + lastUpdated.toDate().toLocal().toString());
              }
            },),
            SizedBox(height: 8.h),
            SectionDropdown(setSection: setSection), // Dropdown for selecting section
            SizedBox(height: 8.h),
            ElevatedButton(
              onPressed: _fetchExamTimings,
              child: Text('Search', style: TextStyle(color: myColors.textColorLight, fontSize: 12.sp)),
              style: ElevatedButton.styleFrom(
                backgroundColor: myColors.primaryColorLight,
                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w), // Reduced padding inside button
              ),
            ),
            SizedBox(height: 8.h),
            Expanded(
              child: examTimings.isEmpty
                  ? Center(child: Text(loadingMessage, style: TextStyle(fontSize: 12.sp))) // Smaller text for message
                  : Column(
                    children: [
                      SizedBox(width: double.infinity,
                        child: ElevatedButton.icon(icon: Icon(Icons.chat, color: Colors.white,),onPressed: ()async{/* whatsapp_share removed */}, label: Text('Share to whatsapp', style: TextStyle(color: myColors.textColorLight, fontSize: 12.sp)),
                                      style: ElevatedButton.styleFrom(
                                    backgroundColor: myColors.primaryColorLight,
                                      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
                                    ),),
                      ),
                      Expanded(
                        child: ListView.builder(
                                        itemCount: examTimings.length,
                                        itemBuilder: (context, index) {
                        final timing = examTimings[index];
                        return _buildExamTimingCard(timing);
                                        },
                                      ),
                      ),
                    ],
                  ),
            ),
          ],
        ),
      ),
      backgroundColor: myColors.backgroundColor,
    );
  }

  Widget _buildExamTimingCard(Map<String, dynamic> timing) {
    return Card(
      elevation: 1, // Reduced shadow for an even cleaner look
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.r), // Smaller rounded corners
      ),
      margin: EdgeInsets.symmetric(vertical: 4.h), // Less vertical space between cards
      child: Padding(
        padding: EdgeInsets.all(8.sp), // Smaller padding inside cards
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              timing['Faculty Member'] != null && timing['Faculty Member'].toString().length > 3
                  ? timing['Faculty Member'].toString() == "A Pre" ?  "Pre Calculus..." :timing['Faculty Member'].toString().substring(2, timing['Faculty Member'].toString().length - 2) + "..."
                  : "Invalid Faculty Data",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp), // Smaller font size
            ),
            SizedBox(height: 4.h),
            Text(
              'Date: ${timing['Date']}',
              style: TextStyle(fontSize: 10.sp), // Smaller font size
            ),
            SizedBox(height: 2.h),
            Text(
              'Time: ${timing['Time']}',
              style: TextStyle(fontSize: 10.sp), // Smaller font size
            ),
            SizedBox(height: 2.h),

            Text(
              'Room: ${timing['Room #']}',
              style: TextStyle(fontSize: 10.sp), // Smaller font size
            ),
          ],
        ),
      ),
    );
  }
}
