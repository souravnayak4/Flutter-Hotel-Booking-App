import 'package:flutter/material.dart';
import 'package:hotelbooking/app/features/hotel/presentation/pages/booking_summary_page.dart';
import 'package:intl/intl.dart';

class RoomCard extends StatefulWidget {
  final Map<String, dynamic> category;
  final String hotelName;
  final String hotelownerId;
  final Color primaryColor;

  const RoomCard({
    super.key,
    required this.hotelName,
    required this.hotelownerId,

    required this.category,
    required this.primaryColor,
  });

  @override
  State<RoomCard> createState() => _RoomCardState();
}

class _RoomCardState extends State<RoomCard> {
  DateTime? checkInDate;
  DateTime? checkOutDate;
  int rooms = 1;

  int get nights {
    if (checkInDate != null && checkOutDate != null) {
      final diff = checkOutDate!.difference(checkInDate!).inDays;
      return diff > 0 ? diff : 0;
    }
    return 0;
  }

  double get totalPrice {
    double pricePerNight =
        double.tryParse(widget.category['price'].toString()) ?? 0;
    return pricePerNight * nights * rooms;
  }

  Future<void> pickDate(BuildContext context, bool isCheckIn) async {
    final DateTime now = DateTime.now();

    final DateTime initialDate = isCheckIn
        ? (checkInDate ?? now)
        : (checkInDate != null
              ? checkInDate!.add(const Duration(days: 1))
              : now.add(const Duration(days: 1)));

    final DateTime firstDate = isCheckIn
        ? now
        : (checkInDate != null
              ? checkInDate!.add(const Duration(days: 1))
              : now.add(const Duration(days: 1)));

    final DateTime lastDate = now.add(const Duration(days: 365));

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          checkInDate = picked;
          // Reset checkOutDate if it is before new checkInDate
          if (checkOutDate != null && checkOutDate!.isBefore(picked)) {
            checkOutDate = null;
          }
        } else {
          checkOutDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Enable booking only if both dates are selected and nights > 0
    bool canBook = checkInDate != null && checkOutDate != null && nights > 0;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Room Image with Price Tag
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Stack(
              children: [
                Image.network(
                  widget.category['image']?.toString().isNotEmpty == true
                      ? widget.category['image']
                      : 'https://via.placeholder.com/400x200',
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 180,
                      width: double.infinity,
                      color: Colors.grey.shade200,
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'images/hotel2.jpg',
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    );
                  },
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '\$${widget.category['price']}/night',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Details Section
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Room Name
                Text(
                  widget.category['categoryName'] ?? 'Room Category',
                  style: TextStyle(
                    fontSize: screenWidth * 0.045,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.category['description'] ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: screenWidth * 0.038),
                ),
                const SizedBox(height: 10),

                // Features
                if (widget.category['features'] != null)
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: List.generate(
                      widget.category['features'].length,
                      (fIndex) => Chip(
                        label: Text(widget.category['features'][fIndex]),
                        backgroundColor: widget.primaryColor.withOpacity(0.1),
                      ),
                    ),
                  ),
                const SizedBox(height: 14),

                // Date Selection
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => pickDate(context, true),
                        child: Text(
                          checkInDate == null
                              ? 'Check-in'
                              : DateFormat('dd MMM').format(checkInDate!),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: checkInDate == null
                            ? null
                            : () => pickDate(context, false),
                        child: Text(
                          checkOutDate == null
                              ? 'Check-out'
                              : DateFormat('dd MMM').format(checkOutDate!),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Rooms Selector
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Number of Rooms:',
                      style: TextStyle(fontSize: 16),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: rooms > 1
                              ? () => setState(() => rooms--)
                              : null,
                        ),
                        Text(
                          '$rooms',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: rooms < 5
                              ? () => setState(() => rooms++)
                              : null,
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Price Info
                if (nights > 0)
                  Text(
                    'Stay: $nights night(s) | Rooms: $rooms | Total: \$${totalPrice.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 16,
                      color: widget.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                const SizedBox(height: 14),

                // Book Button with Navigation
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor: canBook
                          ? widget.primaryColor
                          : Colors.grey,
                    ),
                    onPressed: canBook
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookingSummaryPage(
                                  bookingData: {
                                    'hotelId': widget.category['id'] ?? '',
                                    'hotelName': widget.hotelName,
                                    'hotelownerId': widget.hotelownerId,
                                    'roomType': widget.category['categoryName'],
                                    'checkIn': DateFormat(
                                      'dd MMM yyyy',
                                    ).format(checkInDate!),
                                    'checkOut': DateFormat(
                                      'dd MMM yyyy',
                                    ).format(checkOutDate!),
                                    'rooms': rooms,
                                    'nights': nights,
                                    'price': totalPrice,
                                    'image': widget.category['image'],
                                  },
                                ),
                              ),
                            );
                          }
                        : () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Please select valid check-in and check-out dates.',
                                ),
                              ),
                            );
                          },
                    child: const Text(
                      'Book Now',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
