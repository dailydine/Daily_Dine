import 'package:flutter/material.dart';

class CustomHeader extends StatelessWidget {
  const CustomHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFE39B44), // Orange background
      padding: EdgeInsets.only(
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
              Icon(Icons.location_on, size: 30),
              Center(
                child: Row(
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
              ),
              Icon(Icons.person, size: 30),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF7D7AD),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Icon(Icons.search),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Restaurant name or a dish',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
