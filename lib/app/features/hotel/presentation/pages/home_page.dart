import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hotelbooking/app/features/hotel/PageHelper/data/datasources/hotel_remote_datasource.dart';
import 'package:hotelbooking/app/features/hotel/PageHelper/widgets/homePagewidgetsHelpers/discover_section.dart';
import 'package:hotelbooking/app/features/hotel/PageHelper/widgets/homePagewidgetsHelpers/header_section.dart';
import 'package:hotelbooking/app/core/widgets/widget_support.dart';
import 'package:hotelbooking/app/features/hotel/PageHelper/widgets/homePagewidgetsHelpers/hotel_card.dart';
import 'package:hotelbooking/app/features/hotel/presentation/pages/details_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Stream<QuerySnapshot>? hotelStream;

  @override
  void initState() {
    super.initState();
    loadHotels();
  }

  loadHotels() async {
    hotelStream = await HotelRemoteDataSource().getAllHotels();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 244, 241, 241),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HeaderSection(),
            const SizedBox(height: 30),

            /// Title
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                'The Most Relevant',
                style: AppWidget.headelinetextstyle(25.0),
              ),
            ),
            const SizedBox(height: 20),

            /// Hotels List
            SizedBox(
              height: size.height * 0.38, // Card height
              child: hotelStream != null
                  ? StreamBuilder<QuerySnapshot>(
                      stream: hotelStream,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        var hotels = snapshot.data!.docs;

                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: hotels.length,
                          itemBuilder: (context, index) {
                            var hotel =
                                hotels[index].data() as Map<String, dynamic>;

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DetailPage(hotel: hotel),
                                  ),
                                );
                              },
                              child: Container(
                                width: size.width * 0.8,
                                margin: EdgeInsets.only(
                                  left: index == 0 ? 20 : 12,
                                  right: index == hotels.length - 1 ? 20 : 0,
                                ),
                                child: HotelCard(hotelData: hotel),
                              ),
                            );
                          },
                        );
                      },
                    )
                  : const Center(child: CircularProgressIndicator()),
            ),

            const SizedBox(height: 28),

            /// Discover Section
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                'Discover the New Places',
                style: AppWidget.headelinetextstyle(20),
              ),
            ),
            const SizedBox(height: 10),
            const DiscoverSection(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
