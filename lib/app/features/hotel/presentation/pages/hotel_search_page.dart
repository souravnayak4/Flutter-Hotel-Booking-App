import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hotelbooking/app/features/hotel/presentation/pages/details_page.dart';

class HotelSearchPage extends StatefulWidget {
  const HotelSearchPage({super.key});

  @override
  State<HotelSearchPage> createState() => _HotelSearchPageState();
}

class _HotelSearchPageState extends State<HotelSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<DocumentSnapshot> _searchResults = [];
  bool _isLoading = false;
  String _query = '';

  void _performSearch(String query) async {
    setState(() {
      _isLoading = true;
      _query = query.toLowerCase();
    });

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('hotels')
          .get();

      final results = snapshot.docs.where((doc) {
        final hotelName = doc['hotelName'].toString().toLowerCase();
        final city = doc['city'].toString().toLowerCase();
        return hotelName.contains(_query) || city.contains(_query);
      }).toList();

      setState(() {
        _searchResults = results;
      });
    } catch (e) {
      print("Search error: $e");
      setState(() => _searchResults = []);
    }

    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildHotelCard(DocumentSnapshot doc) {
    final hotelData = doc.data() as Map<String, dynamic>;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            hotelData['hotelImage'] ?? '',
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported),
          ),
        ),
        title: Text(
          hotelData['hotelName'] ?? '',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(hotelData['city'] ?? ''),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => DetailPage(hotel: hotelData)),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFF0766B3),
        title: const Text("Search Hotels"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: _performSearch,
              decoration: InputDecoration(
                hintText: "Search by hotel or city name",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _query.isEmpty
                ? const Center(child: Text("Search hotels by name or city"))
                : _searchResults.isEmpty
                ? const Center(child: Text("No hotels found"))
                : ListView.builder(
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) =>
                        _buildHotelCard(_searchResults[index]),
                  ),
          ),
        ],
      ),
    );
  }
}
