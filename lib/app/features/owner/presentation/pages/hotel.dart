import 'package:flutter/material.dart';

class HotelDetailsByOwnerPage extends StatefulWidget {
  const HotelDetailsByOwnerPage({super.key});

  @override
  State<HotelDetailsByOwnerPage> createState() =>
      _HotelDetailsByOwnerPageState();
}

class _HotelDetailsByOwnerPageState extends State<HotelDetailsByOwnerPage> {
  final TextEditingController hotelNameController = TextEditingController();
  final TextEditingController hotelAddressController = TextEditingController();
  final TextEditingController checkInController = TextEditingController();
  final TextEditingController checkOutController = TextEditingController();

  // Dropdown for City
  String? selectedCity;
  final List<String> cities = [
    "Delhi",
    "Mumbai",
    "Bengaluru",
    "Hyderabad",
    "Chennai",
    "Kolkata",
    "Pune",
    "Ahmedabad",
    "Jaipur",
    "Lucknow",
    "Chandigarh",
    "Surat",
    "Indore",
    "Bhopal",
    "Nagpur",
    "Goa",
    "Mysuru",
    "Varanasi",
    "Coimbatore",
    "Patna",
  ];

  // Dynamic list for room categories
  List<Map<String, dynamic>> roomCategories = [];

  // Available features
  final List<String> features = [
    "Free Wi-Fi",
    "Breakfast Included",
    "Air Conditioning",
    "Parking",
    "Swimming Pool",
    "TV",
    "Mini Bar",
    "24/7 Room Service",
  ];

  void addCategory() {
    setState(() {
      roomCategories.add({
        "categoryName": "",
        "price": "",
        "description": "",
        "selectedFeatures": <String>{},
      });
    });
  }

  void removeCategory(int index) {
    setState(() {
      roomCategories.removeAt(index);
    });
  }

  void saveHotelDetails() {
    print("Hotel Name: ${hotelNameController.text}");
    print("Hotel Address: ${hotelAddressController.text}");
    print("City: $selectedCity");
    print("Check-in: ${checkInController.text}");
    print("Check-out: ${checkOutController.text}");
    for (var category in roomCategories) {
      print("Category: ${category['categoryName']}");
      print("Price: ${category['price']}");
      print("Description: ${category['description']}");
      print("Features: ${category['selectedFeatures']}");
    }
  }

  Future<void> pickTime(TextEditingController controller) async {
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      controller.text = time.format(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Text(
              "Hotel Details",
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          height: 200,
                          width: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(width: 2.0, color: Colors.black),
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.blue,
                            size: 35,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),

                      /// Hotel Name
                      const Text(
                        "Hotel Name",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 8, bottom: 20),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F6FA),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          controller: hotelNameController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter Hotel Name",
                          ),
                        ),
                      ),

                      /// Hotel Address
                      const Text(
                        "Hotel Address",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 8, bottom: 20),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F6FA),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          controller: hotelAddressController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter Hotel Address",
                          ),
                        ),
                      ),

                      /// City Dropdown
                      const Text(
                        "City",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F6FA),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade400),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: selectedCity,
                            hint: const Text("Select City"),
                            items: cities.map((String city) {
                              return DropdownMenuItem<String>(
                                value: city,
                                child: Text(city),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedCity = value;
                              });
                            },
                          ),
                        ),
                      ),

                      /// Check-in Time
                      const Text(
                        "Check-in Time",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => pickTime(checkInController),
                        child: Container(
                          margin: const EdgeInsets.only(top: 8, bottom: 20),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F6FA),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            checkInController.text.isEmpty
                                ? "Select Check-in Time"
                                : checkInController.text,
                          ),
                        ),
                      ),

                      /// Check-out Time
                      const Text(
                        "Check-out Time",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => pickTime(checkOutController),
                        child: Container(
                          margin: const EdgeInsets.only(top: 8, bottom: 20),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F6FA),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            checkOutController.text.isEmpty
                                ? "Select Check-out Time"
                                : checkOutController.text,
                          ),
                        ),
                      ),

                      /// Room Category Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Room Categories",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: addCategory,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                            ),
                            child: const Text("+ Add Category"),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      /// Dynamic Category Fields
                      Column(
                        children: List.generate(roomCategories.length, (index) {
                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Category ${index + 1}",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed: () => removeCategory(index),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),

                                  /// Category Name
                                  TextField(
                                    decoration: const InputDecoration(
                                      labelText: "Room Category Name",
                                    ),
                                    onChanged: (val) =>
                                        roomCategories[index]['categoryName'] =
                                            val,
                                  ),
                                  const SizedBox(height: 10),

                                  /// Base Price
                                  TextField(
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                          decimal: true,
                                        ),
                                    decoration: const InputDecoration(
                                      labelText: "Base Price",
                                      prefixIcon: Icon(Icons.currency_rupee),
                                    ),
                                    onChanged: (val) =>
                                        roomCategories[index]['price'] = val,
                                  ),

                                  /// Description Box
                                  Container(
                                    margin: const EdgeInsets.only(top: 10),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade50,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    child: TextField(
                                      maxLines: 3,
                                      decoration: const InputDecoration(
                                        hintText: "Enter Description",
                                        border: InputBorder.none,
                                      ),
                                      onChanged: (val) =>
                                          roomCategories[index]['description'] =
                                              val,
                                    ),
                                  ),
                                  const SizedBox(height: 10),

                                  /// Features
                                  const Text(
                                    "Features:",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Wrap(
                                    spacing: 8,
                                    children: features.map((feature) {
                                      bool isSelected =
                                          roomCategories[index]['selectedFeatures']
                                              .contains(feature);
                                      return FilterChip(
                                        label: Text(feature),
                                        selected: isSelected,
                                        onSelected: (selected) {
                                          setState(() {
                                            if (selected) {
                                              roomCategories[index]['selectedFeatures']
                                                  .add(feature);
                                            } else {
                                              roomCategories[index]['selectedFeatures']
                                                  .remove(feature);
                                            }
                                          });
                                        },
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),

                      const SizedBox(height: 20),

                      /// Save Button
                      Center(
                        child: ElevatedButton(
                          onPressed: saveHotelDetails,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 50,
                              vertical: 15,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            "Save Details",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
