import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDAB9B9), // Optional frame color like your screenshot
      body: Column(
        children: [
          Container(
            color: const Color(0xFFE39B44),
            padding: const EdgeInsets.only(top: 40, left: 16, right: 16, bottom: 12),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back, size: 28),
                    ),
                    Row(
                      children: [
                        Image.asset('assets/images/logo.png', height: 40),
                        const SizedBox(width: 6),
                        const Text('DAILY ',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const Text('DINE',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.brown)),
                      ],
                    ),
                    const Icon(Icons.home, size: 28),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7D7AD),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: 'Restaurant name or a dish',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: const Center(
                child: Text('Search Results Appear Here'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
