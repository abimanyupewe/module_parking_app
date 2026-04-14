import 'package:flutter/material.dart';
import './home/summary_section/summary_section.dart';
import './home/area_status_section/area_status_section.dart';
import './home/recent_transactions_section/recent_transactions_section.dart';

/// Owner Home Section - Overview dan Statistik
/// Komposes berbagai section widgets untuk menampilkan dashboard home
class OwnerHomeSection extends StatelessWidget {
  const OwnerHomeSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Today's Summary Cards
          const SummarySection(),
          const SizedBox(height: 24),

          // Area Status
          const AreaStatusSection(),
          const SizedBox(height: 24),

          // Recent Transactions
          const RecentTransactionsSection(),
        ],
      ),
    );
  }
}
