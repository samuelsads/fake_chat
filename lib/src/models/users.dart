

import 'dart:math';

import 'package:flutter/material.dart';

final bots  = List.generate(1, (index) => User(
  uuid: index.toString(), 
  name: 'Bot ${index + 1}', 
  status: true,
  color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
  email: 'bot${index+1}@bots.com'));

class User{
  User({required this.uuid,required this.name, required this.status, required this.color, required this.email});
  String uuid;
  String name;
  bool status;
  Color color;
  String email;
}

