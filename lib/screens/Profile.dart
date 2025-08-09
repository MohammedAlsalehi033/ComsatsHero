import 'package:comsats_hero/models/users.dart';
import 'package:comsats_hero/screens/MainScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme/Colors.dart';
import 'LoginScreen.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final User? user = FirebaseAuth.instance.currentUser;
  final _formKey = GlobalKey<FormState>();


  String _session = 'SP';
  String _year = '';
  String _major = 'BAF';
  String _regNumber = '';

  final List<String> _sessions = ['SP', 'FA'];
  final List<String> _majors = [
    'BAF', 'BAI', 'BAR', 'BAT', 'BBA', 'BBD', 'BCE', 'BCH', 'BCS', 'BCT',
    'BDE', 'BDS', 'BEC', 'BEE', 'BEL', 'BEN', 'BET', 'BFA', 'BID', 'BIR',
    'BMC', 'BPH', 'BPY', 'BRG', 'BSE', 'BSI', 'BSM', 'BSO', 'ECE', 'EEE',
    'ELC', 'MB4', 'MBA', 'MSR', 'P12', 'PBM', 'PBS', 'PCE', 'PCH', 'PCS',
    'PEC', 'PEE', 'PME', 'PMG', 'PMI', 'PMS', 'PMT', 'PPH', 'PRG', 'R06',
    'RAI', 'RBA', 'RBI', 'RBM', 'RBS', 'RCE', 'RCS', 'REC', 'REE', 'REL',
    'RHI', 'RIR', 'RIS', 'RME', 'RMG', 'RMI', 'RMS', 'RMT', 'RMV', 'RPH',
    'RPM', 'RRG', 'RSE'
  ];

  void _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => SignningWidget()),(route) =>false ,
    );
  }

  @override
  Widget build(BuildContext context) {
    final myColors = Provider.of<MyColors>(context);


    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: myColors.primaryColorLight,

      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (user?.photoURL != null)
                ClipOval(

                  child: Image.network(
                    user!.photoURL!,
                    fit: BoxFit.scaleDown,
                    width: 100,
                    height: 100,
                  ),
                )
              else
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey,
                  child: const Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
              const SizedBox(height: 20),
              Text(
                user?.displayName ?? 'No display name',
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 10),
              Text(
                user?.email ?? 'No email',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      value: _session,
                      decoration: const InputDecoration(
                        labelText: 'Session',
                      ),
                      items: _sessions.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _session = newValue!;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Year',
                      ),
                      keyboardType: TextInputType.number,
                      maxLength: 2,
                      validator: (value) {
                        if (value == null || value.isEmpty || value.length != 2) {
                          return 'Please enter a valid year (e.g., 22)';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _year = value!;
                      },
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: _major,
                      decoration: const InputDecoration(
                        labelText: 'Major',
                      ),
                      items: _majors.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _major = newValue!;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Registration Number',
                      ),
                      keyboardType: TextInputType.number,
                      maxLength: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty || value.length != 3) {
                          return 'Please enter a valid registration number (e.g., 053)';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _regNumber = value!;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          final registrationNumber = '$_session$_year-$_major-$_regNumber';
                          if (registrationNumber.length == 12) {
                            print('Registration Number: $registrationNumber');
                            UserService.addRollNumber(user!.email!, registrationNumber);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => MainScreen()),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Registration number must be 12 characters long')),
                            );
                          }
                        }
                      },
                      child: const Text('Save Registration Number'),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _signOut,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, // Background color
                      ),
                      child: const Text('Sign Out'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
