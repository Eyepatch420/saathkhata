import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/router/app_router.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/models/report_models.dart';
import '../../domain/repositories/vendor_repository.dart';

class OutstandingListScreen extends StatefulWidget {
  const OutstandingListScreen({super.key});

  @override
  State<OutstandingListScreen> createState() => _OutstandingListScreenState();
}

class _OutstandingListScreenState extends State<OutstandingListScreen> {
  final _scrollController = ScrollController();
  final _repository = getIt<VendorRepository>();

  final List<CustomerReportItem> _items = [];
  bool _isLoading = false;
  bool _hasMore = true;
  bool _initialLoad = true;
  String? _error;
  int _page = 1;
  static const _limit = 20;

  @override
  void initState() {
    super.initState();
    _fetchPage();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoading &&
        _hasMore) {
      _fetchPage();
    }
  }

  Future<void> _fetchPage() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final result = await _repository.getOutstandingCustomers(
        page: _page,
        limit: _limit,
      );
      setState(() {
        _items.addAll(result.items);
        _hasMore = result.hasMore;
        _page++;
        _initialLoad = false;
      });
    } catch (e) {
      setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _refresh() async {
    setState(() {
      _items.clear();
      _page = 1;
      _hasMore = true;
      _initialLoad = true;
      _error = null;
    });
    await _fetchPage();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.outstandingTitle),
            Text(
              _items.isEmpty ? '' : l10n.customersWithDues(_items.length),
              style: AppTypography.bodySmall.copyWith(color: AppColors.error),
            ),
          ],
        ),
      ),
      body: SafeArea(child: _buildBody()),
    );
  }

  Widget _buildBody() {
    final l10n = AppLocalizations.of(context)!;
    if (_initialLoad && _isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null && _items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_error!, style: AppTypography.bodyMedium.copyWith(color: AppColors.error)),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _refresh, child: Text(l10n.retryButton)),
          ],
        ),
      );
    }

    if (_items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle_outline_rounded, size: 64, color: AppColors.success),
            const SizedBox(height: 16),
            Text(l10n.noOutstandingBalances, style: AppTypography.h3),
            const SizedBox(height: 8),
            Text(l10n.allCustomersSettledUp, style: AppTypography.bodySmall),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView.separated(
        controller: _scrollController,
        padding: const EdgeInsets.all(20),
        itemCount: _items.length + (_hasMore ? 1 : 0),
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          if (index == _items.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          return _OutstandingTile(item: _items[index]);
        },
      ),
    );
  }
}

class _OutstandingTile extends StatelessWidget {
  final CustomerReportItem item;
  const _OutstandingTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final surface = Theme.of(context).colorScheme.surface;
    return InkWell(
      onTap: () => context.push(
        AppRouter.sharedLedger,
        extra: {'linkId': item.linkId, 'name': item.customerName},
      ),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.error.withValues(alpha: 0.12),
              child: Text(
                item.customerName[0].toUpperCase(),
                style: const TextStyle(
                  color: AppColors.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.customerName, style: AppTypography.labelLarge),
                  if (item.customerPhone != null)
                    Text(item.customerPhone!, style: AppTypography.bodySmall),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '₹${item.balance.toStringAsFixed(0)}',
                  style: AppTypography.labelLarge.copyWith(color: AppColors.error),
                ),
                Text(
                  l10n.dueLabel,
                  style: AppTypography.bodySmall.copyWith(color: AppColors.textHint),
                ),
              ],
            ),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textHint, size: 18),
          ],
        ),
      ),
    );
  }
}
