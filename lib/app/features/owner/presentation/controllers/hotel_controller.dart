import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hotelbooking/app/core/services/cloudinary_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HotelController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// Upload image to Cloudinary
  Future<String?> uploadImage(File imageFile) async {
    try {
      final url = Uri.parse(
        "https://api.cloudinary.com/v1_1/${CloudinaryConfig.cloudName}/image/upload",
      );

      final request = http.MultipartRequest("POST", url)
        ..fields['upload_preset'] = CloudinaryConfig.uploadPreset
        ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

      final response = await request.send();
      final resBody = await response.stream.bytesToString();
      final jsonRes = json.decode(resBody);

      if (response.statusCode == 200 && jsonRes['secure_url'] != null) {
        return jsonRes['secure_url'];
      } else {
        print("Cloudinary upload failed: $jsonRes");
        return null;
      }
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

  /// Get all hotels by current logged-in owner
  Future<List<Map<String, dynamic>>> getHotelsByOwner() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return [];

      final snapshot = await firestore
          .collection('hotels')
          .where('hotelownerId', isEqualTo: user.uid)
          .get();

      return snapshot.docs
          .map((doc) => {"id": doc.id, ...doc.data() as Map<String, dynamic>})
          .toList();
    } catch (e) {
      print("Error fetching hotels: $e");
      return [];
    }
  }

  /// Get single hotel by ID (optional helper)
  Future<Map<String, dynamic>?> getHotelById(String hotelId) async {
    try {
      final doc = await firestore.collection('hotels').doc(hotelId).get();
      if (!doc.exists) return null;
      return {"id": doc.id, ...doc.data()!};
    } catch (e) {
      print("Error fetching hotel by ID: $e");
      return null;
    }
  }

  /// Save (Create) new hotel
  Future<String?> saveHotel({
    required String hotelName,
    required String hotelAddress,
    required String aboutPlace,
    required String city,
    required String checkIn,
    required String checkOut,
    required File hotelImage,
    required List<Map<String, dynamic>> roomCategories,
  }) async {
    try {
      final User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return "User not logged in";

      final ownerId = currentUser.uid;
      final hotelId = "${ownerId}_${DateTime.now().millisecondsSinceEpoch}";

      final imageUrl = await uploadImage(hotelImage);
      if (imageUrl == null) return "Failed to upload hotel image";

      List<Map<String, dynamic>> processedCategories = [];

      for (var room in roomCategories) {
        dynamic roomImageInput = room['image'];
        String? roomImageUrl;

        if (roomImageInput is File) {
          roomImageUrl = await uploadImage(roomImageInput);
          if (roomImageUrl == null) return "Failed to upload room image";
        } else if (roomImageInput is String) {
          roomImageUrl = roomImageInput;
        } else {
          return "Room image missing";
        }

        processedCategories.add({
          "categoryName": room["categoryName"],
          "price": room["price"],
          "description": room["description"],
          "features": room["selectedFeatures"],
          "image": roomImageUrl,
        });
      }

      Map<String, dynamic> hotelData = {
        "hotelName": hotelName,
        "hotelAddress": hotelAddress,
        "aboutPlace": aboutPlace,
        "city": city,
        "checkIn": checkIn,
        "checkOut": checkOut,
        "hotelownerId": ownerId,
        "hotelImage": imageUrl,
        "roomCategories": processedCategories,
        "createdAt": FieldValue.serverTimestamp(),
      };

      await firestore.collection("hotels").doc(hotelId).set(hotelData);
      return null;
    } catch (e) {
      return "Save error: $e";
    }
  }

  /// Update hotel details
  Future<String?> updateHotelDetails({
    required String hotelId,
    required String hotelAddress,
    required String aboutPlace,
    required String city,
    required String checkIn,
    required String checkOut,
    File? newHotelImage,
    List<Map<String, dynamic>>? updatedRoomCategories,
  }) async {
    try {
      Map<String, dynamic> updateData = {
        "hotelAddress": hotelAddress,
        "aboutPlace": aboutPlace,
        "city": city,
        "checkIn": checkIn,
        "checkOut": checkOut,
      };

      if (newHotelImage != null) {
        String? imageUrl = await uploadImage(newHotelImage);
        if (imageUrl != null) {
          updateData['hotelImage'] = imageUrl;
        }
      }

      if (updatedRoomCategories != null) {
        List<Map<String, dynamic>> updatedRooms = [];

        for (var room in updatedRoomCategories) {
          String? imageUrl;

          if (room['image'] is File) {
            imageUrl = await uploadImage(room['image']);
            if (imageUrl == null) return "Failed to upload room image";
          } else if (room['image'] is String) {
            imageUrl = room['image'];
          }

          updatedRooms.add({
            "categoryName": room['categoryName'],
            "price": room['price'],
            "description": room['description'],
            "features": room['selectedFeatures'],
            "image": imageUrl,
          });
        }

        updateData['roomCategories'] = updatedRooms;
      }

      await firestore.collection('hotels').doc(hotelId).update(updateData);
      return null;
    } catch (e) {
      return "Update error: $e";
    }
  }
}
