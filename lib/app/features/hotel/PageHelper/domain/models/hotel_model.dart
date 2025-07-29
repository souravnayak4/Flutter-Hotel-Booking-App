import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HotelModel {
  final String hotelName;
  final String hotelImage;
  final String city;
  final double price;

  HotelModel({
    required this.hotelName,
    required this.hotelImage,
    required this.city,
    required this.price,
  });

  factory HotelModel.fromMap(Map<String, dynamic> data) {
    return HotelModel(
      hotelName: data['hotelName'] ?? '',
      hotelImage: data['hotelImage'] ?? '',
      city: data['city'] ?? '',
      price:
          (data["roomCategories"] != null && data["roomCategories"].isNotEmpty)
          ? (data["roomCategories"][0]["price"] as num).toDouble()
          : 0.0,
    );
  }
}

// Detailed Hotel Model
class HotelDetailModel {
  final String hotelName;
  final String hotelImage;
  final String hotelAddress;
  final String city;
  final String description;
  final List<RoomCategory> roomCategories;

  HotelDetailModel({
    required this.hotelName,
    required this.hotelImage,
    required this.hotelAddress,
    required this.city,
    required this.description,
    required this.roomCategories,
  });

  factory HotelDetailModel.fromMap(Map<String, dynamic> data) {
    return HotelDetailModel(
      hotelName: data['hotelName'] ?? '',
      hotelImage: data['hotelImage'] ?? '',
      hotelAddress: data['hotelAddress'] ?? '',
      city: data['city'] ?? '',
      description: data['description'] ?? '',
      roomCategories:
          (data['roomCategories'] as List<dynamic>?)
              ?.map((item) => RoomCategory.fromMap(item))
              .toList() ??
          [],
    );
  }
}

class RoomCategory {
  final String categoryName;
  final String description;
  final List<String> features;
  final double price;

  RoomCategory({
    required this.categoryName,
    required this.description,
    required this.features,
    required this.price,
  });

  factory RoomCategory.fromMap(Map<String, dynamic> data) {
    return RoomCategory(
      categoryName: data['categoryName'] ?? 'Room Category',
      description: data['description'] ?? '',
      features: List<String>.from(data['features'] ?? []),
      price: (data['price'] is num) ? (data['price'] as num).toDouble() : 0.0,
    );
  }
}

class BookingService {
  static Future<void> saveBooking({
    required Map<String, dynamic> bookingData,
    required String transactionId,
    required String name,
    required String email,
    required String phone,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    final docRef = FirebaseFirestore.instance.collection('bookings').doc();
    final bookingId = docRef.id;

    await docRef.set({
      'bookingId': bookingId,
      'transactionId': transactionId,
      'status': 'success',
      'hotelId': bookingData['hotelId'],
      'hotelName': bookingData['hotelName'],
      'hotelownerId': bookingData['hotelownerId'],
      'roomType': bookingData['roomType'],
      'checkIn': bookingData['checkIn'],
      'checkOut': bookingData['checkOut'],
      'rooms': bookingData['rooms'],
      'nights': bookingData['nights'],
      'price': bookingData['price'],
      'image': bookingData['image'],
      'userId': user?.uid,
      'name': name,
      'email': email,
      'phone': phone,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
