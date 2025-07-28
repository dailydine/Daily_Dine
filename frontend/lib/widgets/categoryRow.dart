import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../restaurant_list_screen.dart';

class Categoryrow extends StatefulWidget {
   Categoryrow({super.key});

  @override
  State<Categoryrow> createState() => _CategoryrowState();
}

class _CategoryrowState extends State<Categoryrow> {
  final List<Map<String, String>> categories = [
    {'label': 'Indian', 'image': 'assets/images/indian.jpg'},
    {'label': 'Desserts', 'image': 'assets/images/desserts.jpg'},
    {'label': 'Veg', 'image': 'assets/images/veg.jpg'},
    {'label': 'Italian', 'image': 'assets/images/italian.jpg'},
    {'label': 'Pizza', 'image': 'assets/images/pizza.jpg'},
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemBuilder: (context, index) {
          final category = categories[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RestaurantListScreen(category: category['label']!),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage(category['image']!),
                    radius: 30,
                  ),
                  SizedBox(height: 6),
                  Text(
                    category['label']!,
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );

  }
}
