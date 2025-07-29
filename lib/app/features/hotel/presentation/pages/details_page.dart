import 'package:flutter/material.dart';
import 'package:hotelbooking/app/features/hotel/PageHelper/widgets/detailPagewidgetsHelpers/room_card.dart';

class DetailPage extends StatelessWidget {
  final Map<String, dynamic> hotel;
  final Color primaryColor;

  const DetailPage({
    super.key,
    required this.hotel,
    this.primaryColor = const Color(0xFF0766B3),
  });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double bannerHeight = screenHeight * 0.35;

    return Scaffold(
      body: Stack(
        children: [
          /// Main Scrollable Content
          SingleChildScrollView(
            child: Column(
              children: [
                /// Banner Image
                SizedBox(
                  height: bannerHeight,
                  width: double.infinity,
                  child: Image.network(
                    hotel['hotelImage'] ??
                        'https://via.placeholder.com/600x400',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.broken_image, size: 50),
                      );
                    },
                  ),
                ),

                /// Details Section
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  transform: Matrix4.translationValues(
                    0,
                    -24,
                    0,
                  ), // overlap effect
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Hotel Name
                      Text(
                        hotel['hotelName'] ?? 'Hotel Name',
                        style: TextStyle(
                          fontSize: screenWidth * 0.06,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),

                      /// Address
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.grey),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              hotel['hotelAddress'] ?? '',
                              style: TextStyle(
                                fontSize: screenWidth * 0.04,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      /// About
                      Text(
                        'About this place',
                        style: TextStyle(
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        hotel['aboutPlace'] ??
                            'Located in ${hotel['city'] ?? 'City'}, this property offers a comfortable stay and great amenities.',
                        style: TextStyle(fontSize: screenWidth * 0.038),
                      ),
                      const SizedBox(height: 20),

                      /// Room Categories
                      if (hotel['roomCategories'] != null &&
                          hotel['roomCategories'].isNotEmpty)
                        Text(
                          'Available Rooms',
                          style: TextStyle(
                            fontSize: screenWidth * 0.05,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      const SizedBox(height: 12),

                      /// Render RoomCard Widgets
                      ...List.generate(hotel['roomCategories']?.length ?? 0, (
                        index,
                      ) {
                        var category = hotel['roomCategories'][index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: RoomCard(
                            hotelName: hotel['hotelName'] ?? 'Unknown Hotel',
                            category: category,
                            primaryColor: primaryColor,
                            hotelownerId: hotel['hotelownerId'] ?? '',
                          ),
                        );
                      }),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ],
            ),
          ),

          /// Back Button
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 16,
            child: CircleAvatar(
              backgroundColor: Colors.black54,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
