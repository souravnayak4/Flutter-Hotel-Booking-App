import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hotelbooking/app/features/auth/presentation/controllers/logoutHelper_controller.dart';

import 'package:hotelbooking/app/features/owner/presentation/pages/owner_hotel_details.dart';

class OwnerAdminPage extends StatefulWidget {
  const OwnerAdminPage({super.key});

  @override
  State<OwnerAdminPage> createState() => _OwnerAdminPageState();
}

class _OwnerAdminPageState extends State<OwnerAdminPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? currentOwnerId;
  String? ownerName;
  String? ownerEmail;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    currentOwnerId = FirebaseAuth.instance.currentUser?.uid;

    if (currentOwnerId != null) {
      FirebaseFirestore.instance
          .collection('user')
          .doc(currentOwnerId)
          .get()
          .then((doc) {
            if (doc.exists) {
              setState(() {
                ownerName = doc.data()?['Name'];
                ownerEmail = doc.data()?['Email'];
              });
            }
          });
    }
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              logoutUser(context);
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _editHotelDetails() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HotelDetailsByOwnerPage()),
    );
  }

  DateTime parseDate(String dateStr) {
    try {
      final parts = dateStr.split(' ');
      final day = int.parse(parts[0]);
      final month = _monthToNum(parts[1]);
      final year = int.parse(parts[2]);
      return DateTime(year, month, day);
    } catch (_) {
      return DateTime.now();
    }
  }

  int _monthToNum(String month) {
    const monthMap = {
      'Jan': 1,
      'Feb': 2,
      'Mar': 3,
      'Apr': 4,
      'May': 5,
      'Jun': 6,
      'Jul': 7,
      'Aug': 8,
      'Sep': 9,
      'Oct': 10,
      'Nov': 11,
      'Dec': 12,
    };
    return monthMap[month] ?? 1;
  }

  Widget _buildBookingTab(String type) {
    if (currentOwnerId == null) {
      return const Center(child: Text("User not logged in"));
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('bookings')
          .where('hotelownerId', isEqualTo: currentOwnerId)
          .where('status', isEqualTo: 'success')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No bookings found."));
        }

        final now = DateTime.now();
        final filteredDocs = snapshot.data!.docs.where((doc) {
          final checkIn = parseDate(doc['checkIn']);
          final checkOut = parseDate(doc['checkOut']);

          if (type == 'Active') {
            return checkIn.isBefore(now) && checkOut.isAfter(now);
          } else if (type == 'Upcoming') {
            return checkIn.isAfter(now);
          } else {
            return checkOut.isBefore(now);
          }
        }).toList();

        if (filteredDocs.isEmpty) {
          return const Center(child: Text("No matching bookings."));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: filteredDocs.length,
          itemBuilder: (context, index) {
            final data = filteredDocs[index];

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                title: Text("Hotel: ${data['hotelName']}"),
                subtitle: Text(
                  "Guest: ${data['name']}\n"
                  "Check-in: ${data['checkIn']} | Check-out: ${data['checkOut']}\n"
                  "Room Type: ${data['roomType']}\n"
                  "Rooms: ${data['rooms']} | Transaction: ${data['transactionId']}",
                ),
                trailing: SizedBox(
                  height: 80,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        type,
                        style: const TextStyle(
                          color: Colors.teal,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Owner Dashboard"),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit Hotel Details',
            onPressed: _editHotelDetails,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _logout,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: "Active"),
            Tab(text: "Upcoming"),
            Tab(text: "Past"),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.teal.shade100,
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (ownerName != null)
                  Text(
                    "Name: $ownerName",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                if (ownerEmail != null)
                  Text(
                    "Email: $ownerEmail",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildBookingTab("Active"),
                _buildBookingTab("Upcoming"),
                _buildBookingTab("Past"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
