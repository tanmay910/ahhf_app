import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CurrentUser with ChangeNotifier {
  String? _userId;
  String? _userName = 'Anand B';
  // String? _userFirstName;
  // String? _userLastName;
  String? _userEmail = 'anand@gmail.com';
  // Uri? _userImageUrl;
  String? _userImageUrl;
  DateTime? _dateOfBirth;
  String? _bloodGroup;
  String? _address;

  Future<bool> userExists(User? user) async {
    var querySnapshot =
        await FirebaseFirestore.instance.collection('users').get();

    var fetchedUsersData = querySnapshot.docs;

    bool flag = false;
    for (var fetchedUser in fetchedUsersData) {
      print('loop running...');
      if (fetchedUser.id == user!.uid) {
        flag = true;
        print('flag is true now');
        continue;
      }
    }
    print('returning flag');

    return flag;
  }

  Future<void> setInitialUserData(User? user) async {
    print('fetching user data ...');
    if (user!.uid == null) return;
    // if(user.displayName == null) return;

    var querySnapshot =
        await FirebaseFirestore.instance.collection('users').get();

    var fetchedUsersData = querySnapshot.docs;

    var flag = true;
    for (var fetchedUser in fetchedUsersData) {
      print('searching for already existing user ... ');
      if (fetchedUser.id == user.uid) {
        _userId = fetchedUser.id;
        _userName = fetchedUser['name'];
        _userEmail = fetchedUser['email'];
        _userImageUrl = fetchedUser['imageUrl'];
        _bloodGroup = fetchedUser['bloodGroup'];
        _address = fetchedUser['address'];
        flag = false;
        print('found the existing user ... ');
      }
    }
    if (flag) {
      Map<String, dynamic> userData = {
        'name': user.displayName,
        'email': user.email,
        'imageUrl': user.photoURL,
        'bloodGroup': 'O+',
        'address': 'Pune, Maharashtra, India',
      };
      print('sending user data to firebase firestore ... ');
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set(userData);

      _userId = user.uid;
      _userName = user.displayName;
      _userEmail = user.email;
      _userImageUrl = user.photoURL;
      _bloodGroup = 'O+';
      _address = 'Pune, Maharashtra, India';
      print('setted user data, done.');
    }

    // _userId = user.uid;
    // _userName = user.displayName;
    // _userEmail = user.email;
    // _userImageUrl = Uri.parse(user.photoURL as String);
    // _userImageUrl = user.photoURL;

    print(user.uid);
    print(_userEmail);
    print(_userImageUrl);
    print(_bloodGroup);
    print(_address);

    // After this call the firebase using the userId
    // and find if this user's data is in the database
    // if it exists then fetch the other data like address, dob etc.
    // if it doesn't exist then put the data in the database
  }

  Map<String, String?> get getProfileScreenUserData {
    return {
      'name': _userName,
      'email': _userEmail,
      'imageUrl': _userImageUrl,
    };
  }
}
