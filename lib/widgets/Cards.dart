
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comsats_hero/screens/PDFviewer.dart';
import 'package:comsats_hero/theme/Colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:comsats_hero/screens/verifiedPapers.dart';

import '../models/users.dart';


class MyCards {



  static Widget cardForPapers(
      String subject, String? year, String? type, String filePath, BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10,0,0,0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Thumbnail or Icon
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: MyColors.primaryColorLight,
              ),
              child: Icon(
                Icons.picture_as_pdf,
                size: 40,
                color: Colors.white,

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
            ElevatedButton(onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PDFviewer(downloadablePath: filePath),
                ),
              );
            }, child: Text("Check the Doc",style:TextStyle(color: Colors.white,) ,)
            ,style: ButtonStyle(alignment: Alignment.centerLeft,backgroundColor: WidgetStateProperty.all(MyColors.primaryColorLight),minimumSize: WidgetStateProperty.all(Size.square(100)),shape: WidgetStateProperty.all(ContinuousRectangleBorder(borderRadius: BorderRadius.circular(20)))),),
            // Download Button

          ],
        ),
      ),
    );
  }

  static Widget cardForAdminVerification (BuildContext context, DocumentSnapshot paper) {

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
            SingleChildScrollView(scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('User ID: ${paper['userId']}',softWrap: true,overflow: TextOverflow.fade,),
                  FutureBuilder(future: UserService.getUser(paper['userId']), builder: (context, snapshot) {

                    if(snapshot.hasError){
                      return Text(" Error");
                    }
                    else if (snapshot.connectionState == ConnectionState.waiting){
                      return CircularProgressIndicator(strokeWidth: 1,value: 1,);
                    }
                    else {
                      try{Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
                      return Text("  user Ranking: ${data["rank"].toString()}");}catch(e){
                        return Text("there was some kind of error");

                      }

                    }
                  },),

                ],
              ),
            ),
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
            SingleChildScrollView(scrollDirection: Axis.horizontal,child: Text('Email: $email')),

            Text('Roll Number: $rollNumber')
          ],
        ),
        trailing: Icon(Icons.star, color: iconColor), // You can customize the icon here
        onTap: (){},
      ),
    );
  }
}
