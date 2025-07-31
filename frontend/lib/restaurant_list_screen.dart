import 'package:flutter/material.dart';
import 'package:frontend/widgets/categoryRow.dart';
import '../widgets/custom_header.dart'; // adjust the path based on your folder structure

class RestaurantListScreen extends StatelessWidget {
  final String category;

  const RestaurantListScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> restaurants = List.generate(10, (index) {
      return {
        'name': 'The Grand Kitchen',
        'image': 'assets/images/hotel.jpg',
        'time': '40-45 mins',
        'distance': '3.4 km',
        'rating': '4.5',
      };
    });

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF), // pinkish background
      body: SafeArea(
        child: Column(
          children: [
            const CustomHeader(),
            SizedBox(height: 10,),// 👈 your reusable header
            Categoryrow(),
            const SizedBox(height: 10),
            const Text(textAlign: TextAlign.left,
              "160 Results for Indian",
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: restaurants.length,
                itemBuilder: (context, index) {
                  final r = restaurants[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            border: Border.all( // ✅ Add this
                              color: Colors.black, // or any color you prefer
                              width: 1,          // thickness of the border
                            ),
                          ),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                                child: Image.asset(
                                  r['image'],
                                  height: 160,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${r['time']}  ${r['distance']}",
                                        style: TextStyle(color: Colors.grey[600])),
                                    const SizedBox(height: 4),
                                    Text(
                                      r['name'],
                                      style: const TextStyle(
                                          fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 4)
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Positioned(
                          right: 8,
                          top: 8,
                          child: Icon(Icons.favorite_border, color: Colors.black),
                        ),
                        Positioned(
                          right: 8,
                          bottom: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              children: [
                                Text(r['rating'],
                                    style: const TextStyle(color: Colors.white)),
                                const Icon(Icons.star, size: 14, color: Colors.white),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),SizedBox(height: 5,)
          ],
        ),
      ),
    );
  }
}