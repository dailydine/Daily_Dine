import 'package:flutter/material.dart';
import 'package:frontend/widgets/categoryRow.dart';
import 'package:frontend/widgets/custom_header.dart';
import 'restaurant_list_screen.dart'; // Import the next screen

class HomePage extends StatelessWidget {


  final List<String> todaysOffers = [
    'assets/images/today_offer.jpg',
    'assets/images/today_offer.jpg',
    'assets/images/today_offer.jpg',
  ];

  final List<Map<String, String>> nearbyStores = [
    {'name': 'Dominos', 'image': 'assets/images/dominos.jpg'},
    {'name': 'Mummys', 'image': 'assets/images/mummys.jpg'},
    {'name': 'Spicy Curry', 'image': 'assets/images/spicy.jpg'},
    {'name': '7th Heaven', 'image': 'assets/images/7thheaven.png'},
    {'name': 'Pizza Hut', 'image': 'assets/images/pizzahut.jpg'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomHeader(),
              Categoryrow(),
              _buildHotDealsBanner(),
              _buildSectionTitle('Today\'s offers'),
              _buildOffersList(),
              _buildSectionTitle('Stores near you'),
              _buildNearbyStores(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopHeader() {
    return Container(
      color: Color(0xFFCE8D3E),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Icon(Icons.location_on, color: Colors.black),
          Text(
            'DAILY DINE',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              letterSpacing: 1.2,
            ),
          ),
          Icon(Icons.person, color: Colors.black),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      color: Color(0xFFCE8D3E),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Restaurant name or a dish',
            filled: true,
            fillColor: Color(0xFFF3D3A3),
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildHotDealsBanner() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset('assets/images/hot_deals_banner.jpg'),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildOffersList() {
    return Container(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: todaysOffers.length,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Image.asset(todaysOffers[index]),
          );
        },
      ),
    );
  }

  Widget _buildNearbyStores() {
    return Container(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: nearbyStores.length,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemBuilder: (context, index) {
          final store = nearbyStores[index];
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    store['image']!,
                    height: 70,
                    width: 70,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  store['name']!,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
