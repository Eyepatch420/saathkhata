import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/localization/localized_labels.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/services/ledger_attachment_service.dart';
import '../../../../shared/models/order_model.dart';
import '../../../shared_ledger/presentation/screens/shared_ledger_screen/widgets/full_screen_photo_viewer.dart';
import '../bloc/order_bloc.dart';
import '../bloc/order_event.dart';
import '../bloc/order_state.dart';

/// Full order detail, shared by vendor and staff. Vendors can confirm/reject a
/// pending order and deliver a confirmed one; staff can deliver confirmed orders.
/// Customers get a read-only view.
class OrderDetailScreen extends StatelessWidget {
  final Order order;

  /// 'vendor' | 'staff' | 'customer' — controls which actions are shown.
  final String role;

  const OrderDetailScreen({super.key, required this.order, required this.role});

  bool get _canManage => role == 'vendor' || role == 'staff';

  Color _statusColor(OrderStatus s) => switch (s) {
    OrderStatus.pending => AppColors.warning,
    OrderStatus.confirmed => Colors.blue,
    OrderStatus.delivered => AppColors.success,
    OrderStatus.rejected => AppColors.error,
    OrderStatus.cancelled => AppColors.textSecondary,
  };

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderBloc, OrderState>(
      listenWhen: (_, curr) => curr is OrderError || curr is OrderLoaded,
      listener: (context, state) {
        if (state is OrderError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      builder: (context, state) {
        // Use the freshest copy of this order from the bloc if present.
        final current = state is OrderLoaded
            ? state.orders.firstWhere(
                (o) => o.id == order.id,
                orElse: () => order,
              )
            : order;
        final busy = state is OrderActionLoading;

        return Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.orderDetailsTitle),
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _statusHeader(context, current),
              const SizedBox(height: 16),
              if (current.customerName != null) ...[
                _SectionCard(
                  title: AppLocalizations.of(context)!.customer,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: AppColors.primary.withValues(
                          alpha: 0.12,
                        ),
                        child: Text(
                          current.customerName![0].toUpperCase(),
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: Text(current.customerName!)),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ],
              _SectionCard(
                title: AppLocalizations.of(
                  context,
                )!.itemsCount(current.items.length),
                child: Column(
                  children: [
                    ...current.items.map((it) => _ItemRow(item: it)),
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.totalLabel,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '₹${current.total.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (current.note != null && current.note!.isNotEmpty) ...[
                const SizedBox(height: 12),
                _SectionCard(
                  title: AppLocalizations.of(context)!.orderNoteOptional,
                  child: Text(
                    current.note!,
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                ),
              ],
              if (current.status == OrderStatus.delivered) ...[
                const SizedBox(height: 12),
                _deliveryProofCard(context, current),
              ],
              const SizedBox(height: 24),
            ],
          ),
          bottomNavigationBar: _canManage
              ? _actionBar(context, current, busy)
              : null,
        );
      },
    );
  }

  Widget _statusHeader(BuildContext context, Order order) {
    final l10n = AppLocalizations.of(context)!;
    final color = _statusColor(order.status);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.receipt_long_rounded, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.orderStatusName(order.status),
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  l10n.orderPlacedOn(_fmt(order.createdAt)),
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _deliveryProofCard(BuildContext context, Order order) {
    final l10n = AppLocalizations.of(context)!;
    return _SectionCard(
      title: l10n.deliveryLabel,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (order.deliveredByRole != null)
            Text(
              l10n.markedDeliveredBy(order.deliveredByRole!),
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          if (order.deliveredAt != null)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                _fmt(order.deliveredAt!),
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ),
          if (order.deliveryNote != null && order.deliveryNote!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              l10n.noteWithValue(order.deliveryNote!),
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ],
          if (order.proofUrl != null && order.proofUrl!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              l10n.proofPhotoLabel,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 6),
            GestureDetector(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => FullScreenPhotoViewer(
                    imageUrl: order.proofUrl!,
                    heroTag: 'order_proof_${order.id}',
                    isLocked: true,
                  ),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Hero(
                  tag: 'order_proof_${order.id}',
                  child: CachedNetworkImage(
                    imageUrl: order.proofUrl!,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (ctx, url) => Container(
                      height: 180,
                      color: AppColors.textHint.withValues(alpha: 0.1),
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                    errorWidget: (ctx, url, err) => Container(
                      height: 180,
                      color: AppColors.textHint.withValues(alpha: 0.1),
                      child: const Center(
                        child: Icon(
                          Icons.broken_image_outlined,
                          color: AppColors.textHint,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.tapToViewFullScreen,
              style: const TextStyle(color: AppColors.textHint, fontSize: 11),
            ),
          ],
        ],
      ),
    );
  }

  Widget _actionBar(BuildContext context, Order order, bool busy) {
    final bloc = context.read<OrderBloc>();
    final l10n = AppLocalizations.of(context)!;
    Widget body;
    if (order.status == OrderStatus.pending && role == 'vendor') {
      body = Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: busy
                  ? null
                  : () => bloc.add(
                      UpdateOrderStatus(
                        orderId: order.id,
                        status: OrderStatus.rejected,
                      ),
                    ),
              style: OutlinedButton.styleFrom(foregroundColor: AppColors.error),
              child: Text(l10n.rejectButton),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: FilledButton(
              onPressed: busy
                  ? null
                  : () => bloc.add(
                      UpdateOrderStatus(
                        orderId: order.id,
                        status: OrderStatus.confirmed,
                      ),
                    ),
              style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
              child: Text(l10n.confirmButton),
            ),
          ),
        ],
      );
    } else if (order.status == OrderStatus.confirmed) {
      body = FilledButton.icon(
        onPressed: busy ? null : () => _openDeliverySheet(context, bloc, order),
        icon: const Icon(Icons.local_shipping_outlined),
        label: Text(l10n.markAsDeliveredButton),
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          minimumSize: const Size.fromHeight(50),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }

    return SafeArea(
      child: Padding(padding: const EdgeInsets.all(16), child: body),
    );
  }

  void _openDeliverySheet(BuildContext context, OrderBloc bloc, Order order) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => BlocProvider.value(
        value: bloc,
        child: _DeliveryProofSheet(order: order),
      ),
    );
  }

  static String _fmt(DateTime dt) =>
      '${dt.day}/${dt.month}/${dt.year}, ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
}

class _ItemRow extends StatelessWidget {
  final OrderItem item;
  const _ItemRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final qtyUnit = [
      if (item.qty != null) item.qty,
      if (item.unit != null) item.unit,
    ].join(' ');
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                if (qtyUnit.isNotEmpty || item.pricePerUnit != null)
                  Text(
                    [
                      if (qtyUnit.isNotEmpty) qtyUnit,
                      if (item.pricePerUnit != null)
                        '@ ₹${item.pricePerUnit!.toStringAsFixed(0)}',
                    ].join('  '),
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            item.subtotal != null
                ? '₹${item.subtotal!.toStringAsFixed(2)}'
                : '—',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.textHint.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              color: AppColors.textHint,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

/// Bottom sheet: optional note + optional photo before marking delivered.
class _DeliveryProofSheet extends StatefulWidget {
  final Order order;
  const _DeliveryProofSheet({required this.order});

  @override
  State<_DeliveryProofSheet> createState() => _DeliveryProofSheetState();
}

class _DeliveryProofSheetState extends State<_DeliveryProofSheet> {
  final _noteCtrl = TextEditingController();
  File? _photo;
  bool _uploading = false;

  @override
  void dispose() {
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto(ImageSource source) async {
    try {
      final picked = await ImagePicker().pickImage(
        source: source,
        imageQuality: 85,
      );
      if (picked != null && mounted) setState(() => _photo = File(picked.path));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            source == ImageSource.camera
                ? AppLocalizations.of(context)!.couldNotAccessCamera
                : AppLocalizations.of(context)!.couldNotAccessGallery,
          ),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _confirm() async {
    setState(() => _uploading = true);
    String? proofUrl;
    try {
      if (_photo != null) {
        proofUrl = await getIt<LedgerAttachmentService>().uploadAttachment(
          imageFile: _photo!,
          linkId: widget.order.linkId,
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _uploading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.photoUploadFailed(e.toString()),
          ),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (!mounted) return;
    context.read<OrderBloc>().add(
      UpdateOrderStatus(
        orderId: widget.order.id,
        status: OrderStatus.delivered,
        deliveryNote: _noteCtrl.text.trim(),
        proofUrl: proofUrl,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        // viewInsets clears the keyboard; viewPadding clears the gesture bar
        // / 3-button nav when the keyboard is closed.
        bottom:
            MediaQuery.of(context).viewInsets.bottom +
            MediaQuery.of(context).viewPadding.bottom +
            24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.confirmDeliveryTitle,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.amountAddedToCustomerDue(
              widget.order.total.toStringAsFixed(2),
            ),
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _noteCtrl,
            decoration: InputDecoration(
              labelText: l10n.deliveryNoteOptional,
              border: const OutlineInputBorder(),
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 12),
          if (_photo != null) ...[
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    _photo!,
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 6,
                  right: 6,
                  child: GestureDetector(
                    onTap: _uploading
                        ? null
                        : () => setState(() => _photo = null),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _uploading
                      ? null
                      : () => _pickPhoto(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt_outlined, size: 18),
                  label: Text(_photo == null ? l10n.camera : l10n.retakeLabel),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _uploading
                      ? null
                      : () => _pickPhoto(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library_outlined, size: 18),
                  label: Text(l10n.gallery),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _uploading ? null : _confirm,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              minimumSize: const Size.fromHeight(50),
            ),
            child: _uploading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(l10n.markAsDeliveredButton),
          ),
        ],
      ),
    );
  }
}
