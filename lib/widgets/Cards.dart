import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comsats_hero/screens/PDFviewer.dart';
import 'package:comsats_hero/theme/Colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../models/users.dart';
import '../screens/verifiedPapers.dart';

class MyCards {

  static Widget cardForPapers(
      String subject, String? year, String? type, String filePath, BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = screenWidth < 360 ? 10.sp : 12.sp;
    double iconSize = screenWidth < 360 ? 20.sp : 30.sp;
    double buttonWidth = screenWidth < 360 ? 60.w : 80.w;

    final myColors = Provider.of<MyColors>(context);

    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(8.0.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Thumbnail or Icon
            Container(
              width: 50.w,
              height: 50.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0.r),
                color: myColors.primaryColorLight,
              ),
              child: Icon(
                Icons.picture_as_pdf,
                size: iconSize,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 16.w),
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subject,
                    style: TextStyle(
                      fontSize: subject.length < 20 ? 15.sp : 12.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  if (year != null && type != null)
                    Padding(
                      padding: EdgeInsets.only(top: 8.0.h),
                      child: Text(
                        'Year: $year\nType: $type',
                        style: TextStyle(
                          fontSize: fontSize * 0.8,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PDFviewer(downloadablePath: filePath),
                  ),
                );
              },
              child: Text(
                "Check the Doc",
                style: TextStyle(color: Colors.white, fontSize: fontSize * 0.8),
              ),
              style: ButtonStyle(
                alignment: Alignment.centerLeft,
                backgroundColor: MaterialStateProperty.all(myColors.primaryColorLight),
                minimumSize: MaterialStateProperty.all(Size(buttonWidth, 50.h)),
                shape: MaterialStateProperty.all(
                  ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget cardForAdminVerification(BuildContext context, DocumentSnapshot paper) {
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = screenWidth < 360 ? 12.sp : 14.sp;
    double iconSize = screenWidth < 360 ? 20.sp : 24.sp;

    final myColors = Provider.of<MyColors>(context);

    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
        leading: CircleAvatar(
          backgroundColor: myColors.primaryColorLight,
          child: Icon(Icons.article, color: Colors.white, size: iconSize),
        ),
        title: Text(
          paper['subject'],
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5.h),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('User ID: ${paper['userId']}', softWrap: true, overflow: TextOverflow.fade, style: TextStyle(fontSize: fontSize * 0.8)),
                  FutureBuilder(
                    future: UserService.getUser(paper['userId']),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text("Error", style: TextStyle(fontSize: fontSize * 0.8));
                      } else if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator(strokeWidth: 1, value: 1);
                      } else {
                        try {
                          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
                          return Text("  user Ranking: ${data["rank"].toString()}", style: TextStyle(fontSize: fontSize * 0.8));
                        } catch (e) {
                          return Text("there was some kind of error", style: TextStyle(fontSize: fontSize * 0.8));
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
            Text('Year: ${paper['year']}', style: TextStyle(fontSize: fontSize * 0.8)),
            Text('Type: ${paper['type']}', style: TextStyle(fontSize: fontSize * 0.8)),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.visibility, color: myColors.primaryColorLight, size: iconSize),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PaperDetailScreen(paper: paper),
              ),
            );
          },
        ),
      ),
    );
  }

  static Widget cardForChampionUser({
    required String displayName,
    required int rank,
    required String rollNumber,
    required String email,
    required int index,
    required BuildContext context,
    required bool isCurrentUser,
  }) {
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = screenWidth < 360 ? 14 : 17;

    final myColors = Provider.of<MyColors>(context);

    Color cardColor = isCurrentUser ? Colors.blue[100]! : Colors.white;
    Color? iconColor = isCurrentUser ? Colors.blue : null;

    if (!isCurrentUser) {
      if (index == 0) {
        cardColor = Colors.amber[100]!;
        iconColor = Colors.amber;
      } else if (index == 1) {
        cardColor = Colors.grey[300]!;
        iconColor = Colors.grey;
      } else if (index == 2) {
        cardColor = Colors.orange[200]!;
        iconColor = Colors.orange;
      }
    }

    return Card(
      color: cardColor,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: ListTile(
        title: Text(
          displayName,
          style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contributions: $rank',
              style: TextStyle(fontSize: fontSize * 0.8, color: iconColor),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text('Email: $email', style: TextStyle(fontSize: fontSize * 0.8)),
            ),
            Text('Roll Number: $rollNumber', style: TextStyle(fontSize: fontSize * 0.8)),
          ],
        ),
        trailing: Icon(Icons.star, color: iconColor, size: fontSize),
        onTap: () {},
      ),
    );
  }
}
