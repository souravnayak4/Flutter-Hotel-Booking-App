import 'package:flutter/material.dart';
import 'package:hotelbooking/app/core/widgets/widget_support.dart';

class DiscoverSection extends StatelessWidget {
  const DiscoverSection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> discoverPlaces = [
      {'image': 'images/mumbai.jpg', 'name': 'Mumbai', 'hotels': 10},
      {'image': 'images/newyork.jpg', 'name': 'NewYork', 'hotels': 8},
      {'image': 'images/bali.jpg', 'name': 'Bali', 'hotels': 10},
    ];

    return SizedBox(
      height: 300,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: discoverPlaces.length,
        separatorBuilder: (_, __) => const SizedBox(width: 15),
        itemBuilder: (context, index) {
          final place = discoverPlaces[index];
          return Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(30),
            color: Colors.white,
            child: InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: () {},
              child: Container(
                width: 180,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      child: Image.asset(
                        place['image'],
                        height: 200,
                        width: 180,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        place['name'],
                        style: AppWidget.headelinetextstyle(20),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.home_work,
                            size: 20,
                            color: Colors.blue,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '${place['hotels']} Hotels',
                            style: AppWidget.normaltextstyle(16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
