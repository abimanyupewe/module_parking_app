import 'package:flutter/material.dart';
import '../../../../../config/colors.dart';
import '../../../../../models/area_parkir_model.dart';
import 'area_status_item.dart';

/// Area Parking Status List - Menampilkan daftar semua area parkir dengan infinite scroll
class AreaParkingStatusList extends StatefulWidget {
  final List<AreaParkirModel> areas;
  final VoidCallback onLoadMore;
  final bool isLoading;
  final bool hasMore;

  const AreaParkingStatusList({
    Key? key,
    required this.areas,
    required this.onLoadMore,
    this.isLoading = false,
    this.hasMore = true,
  }) : super(key: key);

  @override
  State<AreaParkingStatusList> createState() => _AreaParkingStatusListState();
}

class _AreaParkingStatusListState extends State<AreaParkingStatusList> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (widget.hasMore && !widget.isLoading) {
        widget.onLoadMore();
      }
    }
  }

  Color _getColorByCapacity(AreaParkirModel area) {
    double percentage = area.percentageUsed;
    if (percentage >= 80) {
      return AppColors.danger;
    } else if (percentage >= 60) {
      return AppColors.warning;
    } else {
      return AppColors.success;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: widget.areas.length + (widget.hasMore ? 1 : 0),
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        // Loading indicator di akhir list
        if (index == widget.areas.length) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: widget.isLoading
                  ? const CircularProgressIndicator()
                  : TextButton(
                      onPressed: () {
                        if (!widget.isLoading && widget.hasMore) {
                          widget.onLoadMore();
                        }
                      },
                      child: const Text('Muat Lebih Banyak'),
                    ),
            ),
          );
        }

        final area = widget.areas[index];
        final color = _getColorByCapacity(area);

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: AreaStatusItem(
            name: area.namaArea,
            occupied: area.terisi,
            total: area.kapasitas,
            color: color,
          ),
        );
      },
    );
  }
}
