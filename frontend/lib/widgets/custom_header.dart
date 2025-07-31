import 'package:flutter/material.dart';
import 'search_screen.dart'; // Make sure this import path is correct

class CustomHeader extends StatelessWidget {
  const CustomHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFE39B44), // Orange background
      padding: const EdgeInsets.only(
        top: 10,
        left: 16,
        right: 16,
        bottom: 12,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.location_on, size: 30),
              Row(
                children: [
                  Image.asset('assets/images/logo.png', height: 50), // Your logo
                  const SizedBox(width: 6),
                  const Text('DAILY ',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const Text('DINE',
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold, color: Colors.brown)),
                ],
              ),
              const Icon(Icons.person, size: 30),
            ],
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF7D7AD),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: const [
                  Icon(Icons.search),
                  SizedBox(width: 10),
                  Text(
                    'Restaurant name or a dish',
                    style: TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
