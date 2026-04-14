import 'package:flutter/material.dart';
import '../../../../../config/colors.dart';
import 'summary_card.dart';

/// Summary Section Widget - Container untuk summary cards
class SummarySection extends StatelessWidget {
  const SummarySection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ringkasan Hari Ini',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: SummaryCard(
                title: 'Total Transaksi',
                value: '45',
                subtitle: 'Kendaraan parkir',
                icon: Icons.directions_car,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SummaryCard(
                title: 'Total Pendapatan',
                value: 'Rp 215.000',
                subtitle: 'Dari biaya parkir',
                icon: Icons.attach_money,
                bgColor: const Color(0xFFF0F4FF),
                titleColor: AppColors.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
