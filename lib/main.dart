import 'package:flutter/material.dart';
import 'package:postman_app/screens/get_books.dart';


void main() {
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
      home:  const GetBooks(),
    ),
  );
}
