// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

enum NewsCategories {
  General(icon: Icons.data_usage),
  Business(icon: Icons.receipt_long),
  Sports(icon: Icons.sports_soccer),
  Entertainment(icon: Icons.movie),
  Health(icon: Icons.monitor_heart),
  Technology(icon: Icons.phone_android),
  World(icon: Icons.public),
  Nation(icon: Icons.flag);

  final IconData icon;
  const NewsCategories({required this.icon});
}
