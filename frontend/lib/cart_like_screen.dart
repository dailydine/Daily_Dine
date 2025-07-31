import 'package:flutter/material.dart';

class CartLikeScreen extends StatefulWidget {
  const CartLikeScreen({super.key});

  @override
  State<CartLikeScreen> createState() => _CartLikeScreenState();
}

class _CartLikeScreenState extends State<CartLikeScreen> {
  bool isVeg = false;
  bool isNonVeg = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Restaurant banner card
            Container(
              color: Color.fromRGBO(226, 161, 70, 1),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 8.0,
                      right: 8.0,
                      left: 8.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.arrow_back_sharp, size: 36),
                        Icon(Icons.home_outlined, size: 36),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 1, color: Colors.black),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'The Grand Kitchen',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Row(
                                children: [
                                  Text(
                                    '4.5',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  SizedBox(width: 4),
                                  Icon(
                                    Icons.star,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Text('40-45 mins | Hampankatte'),
                        Divider(color: Colors.grey, thickness: 1),
                        const SizedBox(height: 8),
                        const Text('💥 65% off upto ₹250'),
                        const SizedBox(height: 4),
                        const Text('🎫 LIMITED COUPONS | ABOVE ₹250'),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Search bar and filter icons
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.search),
                        SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "Search for dishes",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        Icon(Icons.mic,color: Colors.red,),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      // Veg toggle
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        margin: EdgeInsets.only(right: 8),
                        height: 36,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.circle, color: Colors.green, size: 16),
                            SizedBox(width: 6),
                            Transform.scale(
                              scale: 0.7,
                              child: Switch(
                                value: isVeg,
                                onChanged: (val) {
                                  setState(() {
                                    isVeg = val;
                                  });
                                },
                                activeColor: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Non-Veg toggle
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        margin: EdgeInsets.only(right: 8),
                        height: 36,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.change_history, color: Colors.red, size: 16),
                            SizedBox(width: 6),
                            Transform.scale(
                              scale: 0.7,
                              child: Switch(
                                value: isNonVeg,
                                onChanged: (val) {
                                  setState(() {
                                    isNonVeg = val;
                                  });
                                },
                                activeColor: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Ratings button
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        height: 36,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            'Ratings 4.0+',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    ],
                  ),

                ],
              ),
            ),
            const Divider(thickness: 1),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Oriental Starter (86)',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // List of food items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  _buildFoodCard(
                    image: 'assets/images/soup.jpg',
                    name: 'Chicken Manchow Soup',
                    desc:
                        'A dark brown soup made with a variety of vegetables, scallions, and chicken',
                    price: 252.25,
                    rating: 4.5,
                  ),
                  _buildFoodCard(
                    image: 'assets/images/momos.jpg',
                    name: 'Paneer Momos',
                    desc:
                        'A dark brown soup made with a variety of vegetables, scallions, and chicken',
                    price: 252.25,
                    rating: 4.5,
                  ),
                  _buildFoodCard(
                    image: 'assets/images/chick.jpg',
                    name: 'Chicken Mandi',
                    desc:
                        'A dark brown soup made with a variety of vegetables, scallions, and chicken',
                    price: 252.25,
                    rating: 4.5,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // Cart bar
      bottomNavigationBar: Container(
        height: 55,
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFB97A3B),
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Center(
          child: Icon(Icons.shopping_cart, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildFoodCard({
    required String image,
    required String name,
    required String desc,
    required double price,
    required double rating,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              image,
              height: 90,
              width: 90,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(desc, maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text('Preparation time: 15-20mins'),
                Text('₹$price'),
                Row(
                  children: [
                    Text(
                      '$rating',
                      style: const TextStyle(color: Colors.green),
                    ),
                    const Icon(Icons.star, size: 16, color: Colors.amber),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const CircleAvatar(
            backgroundColor: Colors.red,
            radius: 16,
            child: Icon(Icons.add, color: Colors.white, size: 18),
          ),
        ],
      ),
    );
  }
}
