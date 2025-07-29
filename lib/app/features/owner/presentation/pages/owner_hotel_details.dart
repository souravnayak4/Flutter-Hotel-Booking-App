import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hotelbooking/app/features/owner/presentation/controllers/hotel_controller.dart';
import 'package:image_picker/image_picker.dart';

class HotelDetailsByOwnerPage extends StatefulWidget {
  const HotelDetailsByOwnerPage({super.key});

  @override
  State<HotelDetailsByOwnerPage> createState() =>
      _HotelDetailsByOwnerPageState();
}

class _HotelDetailsByOwnerPageState extends State<HotelDetailsByOwnerPage> {
  final HotelController _hotelController = HotelController();
  final _formKey = GlobalKey<FormState>();

  String? hotelId;
  String hotelName = "";
  String hotelAddress = "";
  String aboutPlace = "";
  String city = "";
  String checkIn = "";
  String checkOut = "";
  File? newHotelImage;
  String? hotelImageUrl;
  bool hotelExists = false;

  List<Map<String, dynamic>> roomCategories = [];

  @override
  void initState() {
    super.initState();
    loadOwnerHotelDetails();
  }

  Future<void> loadOwnerHotelDetails() async {
    final hotels = await _hotelController.getHotelsByOwner();
    if (hotels.isNotEmpty) {
      final hotel = hotels.first;
      hotelExists = true;
      hotelId = hotel['id'];
      hotelName = hotel['hotelName'] ?? "";
      hotelAddress = hotel['hotelAddress'] ?? "";
      aboutPlace = hotel['aboutPlace'] ?? "";
      city = hotel['city'] ?? "";
      checkIn = hotel['checkIn'] ?? "";
      checkOut = hotel['checkOut'] ?? "";
      hotelImageUrl = hotel['hotelImage'];

      roomCategories = (hotel['roomCategories'] as List).map((room) {
        return {
          "categoryName": room['categoryName'],
          "price": room['price'],
          "description": room['description'],
          "selectedFeatures": List<String>.from(room['features'] ?? []),
          "image": room['image'],
        };
      }).toList();
    } else {
      hotelExists = false;
    }
    setState(() {});
  }

  void addCategory() {
    setState(() {
      roomCategories.add({
        "categoryName": "",
        "price": "",
        "description": "",
        "selectedFeatures": <String>[],
        "image": null,
      });
    });
  }

  Future<void> saveOrUpdateHotel() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    String? response;
    if (hotelExists) {
      response = await _hotelController.updateHotelDetails(
        hotelId: hotelId!,
        hotelAddress: hotelAddress,
        aboutPlace: aboutPlace,
        city: city,
        checkIn: checkIn,
        checkOut: checkOut,
        newHotelImage: newHotelImage,
        updatedRoomCategories: roomCategories,
      );
    } else {
      if (newHotelImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please upload a hotel image")),
        );
        return;
      }
      response = await _hotelController.saveHotel(
        hotelName: hotelName,
        hotelAddress: hotelAddress,
        aboutPlace: aboutPlace,
        city: city,
        checkIn: checkIn,
        checkOut: checkOut,
        hotelImage: newHotelImage!,
        roomCategories: roomCategories,
      );
    }

    if (response == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(hotelExists ? "Hotel updated" : "Hotel created"),
        ),
      );
      await loadOwnerHotelDetails();
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(response)));
    }
  }

  Widget buildRoomCard(int index) {
    final category = roomCategories[index];

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              initialValue: category['categoryName'],
              decoration: const InputDecoration(labelText: 'Category Name'),
              onChanged: (val) => category['categoryName'] = val,
            ),
            TextFormField(
              initialValue: category['price'],
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
              onChanged: (val) => category['price'] = val,
            ),
            TextFormField(
              initialValue: category['description'],
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
              onChanged: (val) => category['description'] = val,
            ),
            Wrap(
              spacing: 10,
              children:
                  [
                    'Free Wi-Fi',
                    'Breakfast Included',
                    'Air Conditioning',
                    'Parking',
                    'Swimming Pool',
                    'TV',
                    '24/7 Room Service',
                    'Mini Bar',
                  ].map((feature) {
                    return FilterChip(
                      label: Text(feature),
                      selected: (category['selectedFeatures'] ?? []).contains(
                        feature,
                      ),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            category['selectedFeatures'].add(feature);
                          } else {
                            category['selectedFeatures'].remove(feature);
                          }
                        });
                      },
                    );
                  }).toList(),
            ),
            TextButton.icon(
              icon: const Icon(Icons.image),
              label: const Text("Upload Room Image"),
              onPressed: () async {
                final image = await ImagePicker().pickImage(
                  source: ImageSource.gallery,
                );
                if (image != null) {
                  setState(() => category['image'] = File(image.path));
                }
              },
            ),
            if (category['image'] != null)
              category['image'] is String
                  ? Image.network(category['image'], height: 100)
                  : Image.file(category['image'], height: 100),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(hotelExists ? hotelName : "Create Hotel"),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            onPressed: saveOrUpdateHotel,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              if (!hotelExists) ...[
                TextFormField(
                  initialValue: hotelName,
                  decoration: const InputDecoration(labelText: 'Hotel Name'),
                  onChanged: (val) => hotelName = val,
                  validator: (val) =>
                      val == null || val.isEmpty ? "Hotel name required" : null,
                ),
              ],
              TextFormField(
                initialValue: hotelAddress,
                decoration: const InputDecoration(labelText: 'Hotel Address'),
                onChanged: (val) => hotelAddress = val,
              ),
              TextFormField(
                initialValue: aboutPlace,
                decoration: const InputDecoration(labelText: 'About Place'),
                maxLines: 3,
                onChanged: (val) => aboutPlace = val,
              ),
              TextFormField(
                initialValue: city,
                decoration: const InputDecoration(labelText: 'City'),
                onChanged: (val) => city = val,
              ),
              GestureDetector(
                onTap: () async {
                  TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (picked != null) {
                    setState(() {
                      checkIn = picked.format(context);
                    });
                  }
                },
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Check-In Time',
                    ),
                    controller: TextEditingController(text: checkIn),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (picked != null) {
                    setState(() {
                      checkOut = picked.format(context);
                    });
                  }
                },
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Check-Out Time',
                    ),
                    controller: TextEditingController(text: checkOut),
                  ),
                ),
              ),

              const SizedBox(height: 12),
              const Text(
                "Hotel Image",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: () async {
                  final image = await ImagePicker().pickImage(
                    source: ImageSource.gallery,
                  );
                  if (image != null) {
                    setState(() => newHotelImage = File(image.path));
                  }
                },
                icon: const Icon(Icons.image),
                label: const Text("Upload Hotel Image"),
              ),
              if (newHotelImage != null)
                Image.file(newHotelImage!, height: 150)
              else if (hotelImageUrl != null)
                Image.network(hotelImageUrl!, height: 150),
              const SizedBox(height: 20),
              const Text(
                "Room Categories",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ...List.generate(roomCategories.length, buildRoomCard),
              TextButton.icon(
                onPressed: addCategory,
                icon: const Icon(Icons.add),
                label: const Text("Add Category"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
