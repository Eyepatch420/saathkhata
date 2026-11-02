import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/router/app_router.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/models/report_models.dart';
import '../../domain/repositories/vendor_repository.dart';

class CollectedTodayScreen extends StatefulWidget {
  const CollectedTodayScreen({super.key});

  @override
  State<CollectedTodayScreen> createState() => _CollectedTodayScreenState();
}

class _CollectedTodayScreenState extends State<CollectedTodayScreen> {
  final _scrollController = ScrollController();
  final _repository = getIt<VendorRepository>();

  final List<CollectedTodayItem> _items = [];
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
      final result = await _repository.getCollectedToday(
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
            Text(l10n.collectedTodayTitle),
            Text(
              _items.isEmpty ? l10n.noPaymentsYetSubtitle : l10n.paymentsCountSubtitle(_items.length),
              style: AppTypography.bodySmall.copyWith(color: AppColors.success),
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
            Icon(Icons.payments_outlined, size: 64, color: AppColors.textHint),
            const SizedBox(height: 16),
            Text(l10n.nothingCollectedToday, style: AppTypography.h3),
            const SizedBox(height: 8),
            Text(l10n.paymentsWillAppearHere, style: AppTypography.bodySmall),
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
          return _CollectedTile(item: _items[index]);
        },
      ),
    );
  }
}

class _CollectedTile extends StatelessWidget {
  final CollectedTodayItem item;
  const _CollectedTile({required this.item});

  String _formatTime(String isoString) {
    try {
      final dt = DateTime.parse(isoString).toLocal();
      final h = dt.hour.toString().padLeft(2, '0');
      final m = dt.minute.toString().padLeft(2, '0');
      return '$h:$m';
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
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
              backgroundColor: AppColors.success.withValues(alpha: 0.12),
              child: Text(
                item.customerName[0].toUpperCase(),
                style: const TextStyle(
                  color: AppColors.success,
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
                  '₹${item.amount.toStringAsFixed(0)}',
                  style: AppTypography.labelLarge.copyWith(color: AppColors.success),
                ),
                Text(
                  _formatTime(item.paidAt),
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
