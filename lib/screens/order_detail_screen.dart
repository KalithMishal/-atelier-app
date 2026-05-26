import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'product_reviews_screen.dart';
import 'return_select_screen.dart';
import 'track_order_screen.dart';
import '../config/firebase_backend.dart';
import '../state/providers.dart';

class OrderDetailScreen extends ConsumerWidget {
  const OrderDetailScreen({super.key, this.orderId});

  final String? orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final id = orderId;

    return Scaffold(
      backgroundColor: const Color(0xFF131313),
      appBar: AppBar(
        backgroundColor: const Color(0xFF131313),
        foregroundColor: const Color(0xFFE5E2E1),
        title: Text('Order Detail', style: GoogleFonts.notoSerif()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: id == null
            ? Text('No order selected.', style: GoogleFonts.manrope(color: const Color(0xFFD1C5B4)))
            : !useFirestoreBackend
                ? Text(
                    'Order details are unavailable on Windows desktop. Use Android or Chrome to view Firestore orders.',
                    style: GoogleFonts.manrope(color: const Color(0xFFD1C5B4), height: 1.5),
                  )
                : StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance.collection('orders').doc(id).snapshots(),
                builder: (context, orderSnap) {
                  final orderData = orderSnap.data?.data();
                  final status = (orderData?['status'] ?? 'placed').toString();
                  final belongsToUser = user == null ? false : (orderData?['userId'] == user.uid);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order #$id',
                        style: GoogleFonts.notoSerif(fontSize: 22, color: const Color(0xFFE5E2E1)),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Status: ${status.toUpperCase()}',
                        style: GoogleFonts.manrope(fontSize: 14, color: const Color(0xFF9A8F80)),
                      ),
                      const SizedBox(height: 16),
                      if (orderSnap.connectionState == ConnectionState.waiting)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(child: CircularProgressIndicator()),
                        )
                      else if (orderData == null)
                        Text('Order not found.', style: GoogleFonts.manrope(color: const Color(0xFFD1C5B4)))
                      else if (!belongsToUser)
                        Text('This order is not available for the current user.', style: GoogleFonts.manrope(color: const Color(0xFFD1C5B4)))
                      else ...[
                        _action(
                          label: 'TRACK MY PACKAGE →',
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => TrackOrderScreen(orderId: id)),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        _action(
                          label: 'REQUEST RETURN →',
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ReturnSelectScreen()));
                          },
                        ),
                        const SizedBox(height: 12),
                        _action(
                          label: 'WRITE A REVIEW ✦',
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ProductReviewsScreen()));
                          },
                        ),
                        const SizedBox(height: 24),
                        Text('Tracking timeline', style: GoogleFonts.notoSerif(fontSize: 18, color: const Color(0xFFE9C349))),
                        const SizedBox(height: 12),
                        Expanded(
                          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                            stream: FirebaseFirestore.instance
                                .collection('orders')
                                .doc(id)
                                .collection('statusEvents')
                                .orderBy('timestamp', descending: false)
                                .snapshots(),
                            builder: (context, eventsSnap) {
                              if (eventsSnap.connectionState == ConnectionState.waiting) {
                                return const Center(child: CircularProgressIndicator());
                              }
                              final docs = eventsSnap.data?.docs ?? const [];
                              if (docs.isEmpty) {
                                return Text('No tracking updates yet.', style: GoogleFonts.manrope(color: const Color(0xFFD1C5B4)));
                              }
                              return ListView.separated(
                                itemCount: docs.length,
                                separatorBuilder: (context, index) => const SizedBox(height: 12),
                                itemBuilder: (context, index) {
                                  final d = docs[index].data();
                                  final label = (d['label'] ?? d['status'] ?? '').toString();
                                  final note = (d['note'] ?? '').toString();
                                  final ts = d['timestamp'];
                                  final timeText = ts is Timestamp ? ts.toDate().toLocal().toString() : '';
                                  return _TimelineTile(label: label, note: note, timeText: timeText, active: index == docs.length - 1);
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ],
                  );
                },
              ),
      ),
    );
  }

  Widget _action({required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1C1B1B),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color.fromRGBO(78, 70, 57, 0.2)),
        ),
        child: Text(
          label,
          style: GoogleFonts.manrope(fontSize: 12, letterSpacing: 1.2, color: const Color(0xFFE9C349)),
        ),
      ),
    );
  }
}

class _TimelineTile extends StatelessWidget {
  const _TimelineTile({
    required this.label,
    required this.note,
    required this.timeText,
    required this.active,
  });

  final String label;
  final String note;
  final String timeText;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final dotColor = active ? const Color(0xFFE9C349) : const Color(0xFF4E4639);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1B1B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color.fromRGBO(78, 70, 57, 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 10,
            height: 10,
            margin: const EdgeInsets.only(top: 6),
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: GoogleFonts.manrope(fontSize: 14, color: const Color(0xFFE5E2E1), fontWeight: FontWeight.w600)),
                if (note.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(note, style: GoogleFonts.manrope(fontSize: 12, color: const Color(0xFF9A8F80))),
                ],
                if (timeText.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(timeText, style: GoogleFonts.manrope(fontSize: 10, color: const Color.fromRGBO(229, 226, 225, 0.6))),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

