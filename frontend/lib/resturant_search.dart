import 'package:flutter/material.dart';
import 'package:frontend/widgets/custom_header.dart';

class RestaurantSearchScreen extends StatelessWidget {
  final List<Map<String, String>> restaurantList = List.generate(6, (index) {
    return {
      "name": "Hotel Sai Palace",
      "location": "Near City Centre, Mangalore",
      "image": "assets/images/hotel.jpg", // Replace with your asset path
    };
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const CustomHeader(), // Your reusable header
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 16,),
              child: Text(
                "Search results:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: restaurantList.length,
              itemBuilder: (context, index) {
                final restaurant = restaurantList[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 2,
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          restaurant["image"]!,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        restaurant["name"]!,
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(restaurant["location"]!),
                      trailing: Icon(Icons.chevron_right),
                      onTap: () {
                        // Navigate to restaurant details
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
