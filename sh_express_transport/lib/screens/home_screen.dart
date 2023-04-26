import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sh_express_transport/services/firebase_services.dart';

import '../utils/constants.dart';

class HomeScreen extends StatefulWidget {
  final User user;
  const HomeScreen({required this.user, Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseServices firebaseServices = FirebaseServices();

  @override
  void initState() {
    firebaseServices.checkIfUserIsVerified(widget.user.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.all(20),
        child: _verified(context),
      ),
    );
  }

  Column _verified(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(CupertinoIcons.check_mark_circled,
            size: 64, color: Colors.green),
        Constants().sizedBoxMedium,
        Text('You have been verified',
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontWeight: FontWeight.bold)),
        Constants().sizedBox,
        Text('Contact us for further detail',
            style: Theme.of(context).textTheme.titleLarge),
        Constants().sizedBox,
      ],
    );
  }
}
