import 'package:flutter/material.dart';

class ExpenseCard extends StatelessWidget {
  final String title;
  final String category;
  final String amount;
  final String icon;
  final Color color;
  final String? dateLabel;

  const ExpenseCard({
    super.key,
    required this.title,
    required this.category,
    required this.amount,
    required this.icon,
    required this.color,
    this.dateLabel,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: Container(
      margin: const EdgeInsets.symmetric(
        vertical: 6,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Text(
            icon,
            style: const TextStyle(fontSize: 28),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Text(
                  dateLabel != null ? '$category · $dateLabel' : category,
                  style: TextStyle(
                    color: Colors.black.withValues(alpha: 0.6),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          Text(
            amount,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
        ),
    );
  }
}