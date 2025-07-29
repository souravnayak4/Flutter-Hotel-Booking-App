import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hotelbooking/app/features/hotel/PageHelper/domain/models/hotel_model.dart';

class HotelRemoteDataSource {
  Future<Stream<QuerySnapshot>> getAllHotels() async {
    return FirebaseFirestore.instance.collection("hotels").snapshots();
  }
}

class HotelRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<HotelModel>> searchHotels(String query) async {
    final snapshot = await _firestore.collection('hotels').get();

    return snapshot.docs
        .map((doc) => HotelModel.fromMap(doc.data()))
        .where(
          (hotel) =>
              hotel.hotelName.toLowerCase().contains(query.toLowerCase()) ||
              hotel.city.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }
}
