import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// Add user info to Firestore
  Future<void> addUserInfo(Map<String, dynamic> userInfoMap, String id) async {
    await firestore.collection("user").doc(id).set(userInfoMap);
  }

  /// Save hotel details to the "hotels" collection
  Future<void> saveHotelDetails(
    String hotelId,
    Map<String, dynamic> data,
  ) async {
    await firestore.collection("hotels").doc(hotelId).set(data);
  }

  /// Fetch user info from Firestore by user ID
  Future<Map<String, dynamic>?> getUserInfo(String uid) async {
    try {
      DocumentSnapshot snapshot = await firestore
          .collection("user")
          .doc(uid)
          .get();
      if (snapshot.exists) {
        return snapshot.data() as Map<String, dynamic>;
      }
    } catch (e) {
      print("Error fetching user info: $e");
    }
    return null;
  }

  /// Get user  from Firestore
  Future<String> getUserType(String uid) async {
    try {
      DocumentSnapshot snapshot = await firestore
          .collection("user")
          .doc(uid)
          .get();
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        return data['userType'] ?? 'guest'; // fallback to guest if missing
      }
    } catch (e) {
      print("Error fetching user type: $e");
    }
    return 'guest'; // fallback if error occurs
  }
}
