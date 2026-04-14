import 'package:flutter/material.dart';
import 'transaction_item.dart';

/// Recent Transactions Section - Displays recent parking transactions
class RecentTransactionsSection extends StatelessWidget {
  const RecentTransactionsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Transaksi Terakhir',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            TextButton(onPressed: () {}, child: const Text('Lihat Semua')),
          ],
        ),
        const SizedBox(height: 12),
        // Sample transaction items
        TransactionItem(
          plate: 'H 1234 ABC',
          type: 'Motor',
          area: 'Lantai 1',
          time: '08:30',
          fee: 'Rp 5.000',
        ),
        const SizedBox(height: 8),
        TransactionItem(
          plate: 'B 5678 CDE',
          type: 'Mobil',
          area: 'Lantai 2',
          time: '09:15',
          fee: 'Rp 12.000',
        ),
        const SizedBox(height: 8),
        TransactionItem(
          plate: 'H 2020 XYZ',
          type: 'Motor',
          area: 'Basement',
          time: '10:00',
          fee: 'Rp 4.000',
        ),
      ],
    );
  }
}
