import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:qp_xt/qp_xt.dart';

class User extends StatelessWidget {
  //...Fields
  final String name;
  final DateTime date;
  final bool verified;
  final int index;

  static final none = User();
  static User current = none;

  User({super.key, this.name = '??'})
      : date = DateTime.now(),
        verified = false,
        index = -1;

  const User._({
    required this.name,
    required this.date,
    required this.verified,
    this.index = -1,
  });

  factory User.fromJson(data, [int? index]) {
    return User._(
      name: data['name'] ?? '??',
      date: DateTime.parse(data['date']),
      verified: data['received'],
      index: index ?? -1,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'date': date.toIso8601String(),
        'received': verified,
      };

  static Future<User> atIndex(int index) async {
    //...
    Hive.initFlutter(); // initialize
    final users = await Hive.openBox('users');
    return User.fromJson(users.getAt(index), index);
  }

  static Future<Iterable<User>> get all async {
    //...
    Hive.initFlutter(); // initialize
    final users = await Hive.openBox('users');
    return users.values.mapIndexed(User.fromJson);
  }

  //...Getters
  bool get isValid {
    final checkName = name != '??' && name.isNotEmpty;
    final verify = verified && name.endsWith('.*QAX');
    return checkName && verify && index >= 0;
  }

  //...Methods
  Future<int> save() async {
    //...
    Hive.initFlutter(); // initialize
    final users = await Hive.openBox('users');
    return await users.add(this);
  }

  Future<int> delete() async {
    //...
    Hive.initFlutter(); // initialize
    final users = await Hive.openBox('users');
    return await users.add(this);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
