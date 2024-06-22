import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comsats_hero/screens/PDFviewer.dart';
import 'package:comsats_hero/theme/Colors.dart';
import 'package:flutter/material.dart';
import 'package:comsats_hero/screens/verifiedPapers.dart';

class MyCards {
  static Widget cardForPapers(
      String subject, String? year, String? type, String filePath, BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Thumbnail or Icon
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.blueAccent.withOpacity(0.2),
              ),
              child: Icon(
                Icons.picture_as_pdf,
                size: 40,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(width: 16.0),
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subject,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  if (year != null && type != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Year: $year\nType: $type',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Download Button
            IconButton(
              icon: Icon(
                Icons.download,
                color: Colors.blueAccent,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PDFviewer(downloadablePath: filePath),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  static Widget cardForAdminVerification(BuildContext context, DocumentSnapshot paper) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        leading: CircleAvatar(
          backgroundColor: MyColors.primaryColorLight,
          child: Icon(Icons.article, color: Colors.white),
        ),
        title: Text(
          paper['subject'],
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5),
            Text('User ID: ${paper['userId']}'),
            Text('Year: ${paper['year']}'),
            Text('Type: ${paper['type']}'),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.visibility, color: MyColors.primaryColorLight),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => (PaperDetailScreen(paper: paper,)),
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
    required int index
  }) {
    Color cardColor = Colors.white; // Default card color
    Color? iconColor; // Color of the icon (for ranking)

    // Determine card color and icon color based on rank
    if (index == 0) {
      cardColor = Colors.amber[100]!; // Gold color for 1st rank
      iconColor = Colors.amber;
    } else if (index == 1) {
      cardColor = Colors.grey[300]!; // Silver color for 2nd rank
      iconColor = Colors.grey;
    } else if (index == 2) {
      cardColor = Colors.orange[200]!; // Bronze color for 3rd rank
      iconColor = Colors.orange;
    }

    return Card(
      color: cardColor,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: ListTile(
        title: Text(
          displayName,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contributions: $rank' ,
              style: TextStyle(fontSize: 16, color: iconColor),
            ),
            Text('Email: $email'),
            rollNumber == null ?
            Text('Roll Number: $rollNumber') : Text("Roll Number not available"),
          ],
        ),
        trailing: Icon(Icons.star, color: iconColor), // You can customize the icon here
        onTap: (){},
      ),
    );
  }
}
