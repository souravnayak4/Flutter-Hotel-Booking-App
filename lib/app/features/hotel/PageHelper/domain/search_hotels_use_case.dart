import 'package:hotelbooking/app/features/hotel/PageHelper/data/datasources/hotel_remote_datasource.dart';
import 'package:hotelbooking/app/features/hotel/PageHelper/domain/models/hotel_model.dart';

class SearchHotelsUseCase {
  final HotelRepository _repository;

  SearchHotelsUseCase(this._repository);

  Future<List<HotelModel>> execute(String query) {
    return _repository.searchHotels(query);
  }
}
