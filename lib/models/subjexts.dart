import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MySubjects {
  // Reference to the 'generals/subjects' document
  static final DocumentReference subjectsDoc = FirebaseFirestore.instance.collection('generals').doc('subjects');

  // List of subjects to be uploaded
  static final List<String> subjects = [
    "Discrete Structures",
    "Programming Fundamentals",
    "Data Structures and Algorithms",
    "Object Oriented Programming",
    "Database Systems",
    "Software Engineering Concepts",
    "Principles of Operating Systems",
    "Computer Networks",
    "Information Security",
    "Senior Design Project I",
    "Senior Design Project II",
    "E-Commerce and Digital Marketing",
    "DevOps for Cloud Computing",
    "Software Construction and Development",
    "Software Re-Engineering",
    "Ethics",
    "Introduction to ICT",
    "Professional Practices",
    "English Comprehension and Composition",
    "Report Writing Skills",
    "Communication Skills",
    "Islamic Studies",
    "Pakistan Studies",
    "Calculus and Analytic Geometry",
    "Linear Algebra",
    "Statistics and Probability Theory",
    "Applied Physics for Engineers",
    "Mathematics I",
    "Calculus I",
    "Web Technologies",
    "Human Computer Interaction",
    "Software Quality Engineering",
    "Software Design and Architecture",
    "Software Requirement Engineering",
    "Mobile Application Development",
    "Computer Organization & Assembly Language",
    "Digital Image Processing",
    "Parallel and Distributed Computing",
    "Advanced Web Technologies",
    "Computer Graphics",
    "Machine Learning",
    "Database Systems I",
    "Database Systems II",
    "Visual Programming",
    "Cryptography and Network Security",
    "Data Visualization",
    "Pattern Recognition",
    "Computer Vision",
    "Introduction to Data Science",
    "Artificial Intelligence",
    "Distributed Database Systems",
    "Game Development",
    "Data Warehousing and Data Mining",
    "Software Metrics",
    "Software Engineering Economics",
    "Information System Audit",
    "Software Process Improvement",
    "Reverse Engineering of Source Code",
    "Semantic Web",
    "Topics in Software Engineering I",
    "Design Patterns",
    "Software Safety Critical Systems",
    "Software Fault Tolerance",
    "Automated Software Testing",
    "Topics in Software Engineering II",
    "Introduction to Modeling and Simulation",
    "Stochastic Processes",
    "Formal Methods",
    "Business Process Engineering",
    "Operations Research",
    "Principles of Microeconomics",
    "Engineering Economics",
    "Business Economics",
    "Managerial Economics",
    "Project Planning and Monitoring",
    "Introduction to Psychology",
    "International Relations",
    "Introduction to Sociology",
    "French",
    "German",
    "Arabic",
    "Persian",
    "Chinese",
    "Japanese",
    "Introduction to Business",
    "Introduction to Management",
    "Financial Accounting",
    "Fundamentals of Marketing",
    "Human Resource Management",
    "New Product Development",
  ];

  // Function to upload the subjects list to Firestore
  static Future<void> uploadSubjects() async {
    await subjectsDoc.set({
      'subjects': MySubjects.subjects,
    });
    print('Subjects uploaded successfully.');
  }

  // Function to retrieve the subjects list from Firestore
  static Future<List<String>> getSubjects() async {
    DocumentSnapshot docSnapshot = await subjectsDoc.get();
    if (docSnapshot.exists) {
      List<dynamic> subjectsDynamic = docSnapshot['subjects'];
      return List<String>.from(subjectsDynamic);
    } else {
      return [];
    }
  }
}
