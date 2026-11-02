part of 'bulk_charge_cubit.dart';

class BulkChargeState extends Equatable {
  final List<ProductTemplate> templates;
  final bool templatesLoading;
  final String? templateError;
  final ProductTemplate? selectedTemplate;
  final Map<String, double> quantities; // linkId -> quantity
  final bool isSubmitting;
  final String? submitError;

  const BulkChargeState({
    this.templates = const [],
    this.templatesLoading = false,
    this.templateError,
    this.selectedTemplate,
    this.quantities = const {},
    this.isSubmitting = false,
    this.submitError,
  });

  BulkChargeState copyWith({
    List<ProductTemplate>? templates,
    bool? templatesLoading,
    String? templateError,
    ProductTemplate? selectedTemplate,
    Map<String, double>? quantities,
    bool? isSubmitting,
    String? submitError,
  }) =>
      BulkChargeState(
        templates: templates ?? this.templates,
        templatesLoading: templatesLoading ?? this.templatesLoading,
        templateError: templateError,
        selectedTemplate: selectedTemplate ?? this.selectedTemplate,
        quantities: quantities ?? this.quantities,
        isSubmitting: isSubmitting ?? this.isSubmitting,
        submitError: submitError,
      );

  double totalAmount(double pricePerUnit) =>
      quantities.values.fold(0.0, (sum, qty) => sum + qty * pricePerUnit);

  int get activeCustomerCount => quantities.values.where((q) => q > 0).length;

  @override
  List<Object?> get props => [
        templates,
        templatesLoading,
        templateError,
        selectedTemplate,
        quantities,
        isSubmitting,
        submitError,
      ];
}
