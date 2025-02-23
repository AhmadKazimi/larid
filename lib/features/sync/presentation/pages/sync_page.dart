import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:larid/core/theme/app_theme.dart';
import 'package:larid/core/widgets/gradient_page_layout.dart';
import '../../../../core/error/error_codes.dart';
import '../../../../core/router/route_constants.dart';
import '../../../../core/storage/shared_prefs.dart';
import '../bloc/sync_bloc.dart';
import '../bloc/sync_event.dart';
import '../bloc/sync_state.dart';
import '../../../../core/l10n/app_localizations.dart';

class SyncPage extends StatefulWidget {
  const SyncPage({super.key});

  @override
  State<SyncPage> createState() => _SyncPageState();
}

class _SyncPageState extends State<SyncPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: BlocConsumer<SyncBloc, SyncState>(
        listener: (context, state) {
          final bool isLoading =
              state.customersState.isLoading ||
              state.salesRepState.isLoading ||
              state.pricesState.isLoading ||
              state.inventoryItemsState.isLoading ||
              state.inventoryUnitsState.isLoading ||
              state.salesTaxesState.isLoading;

          final bool hasError =
              state.customersState.errorCode != null ||
              state.salesRepState.errorCode != null ||
              state.pricesState.errorCode != null ||
              state.inventoryItemsState.errorCode != null ||
              state.inventoryUnitsState.errorCode != null ||
              state.salesTaxesState.errorCode != null;

          final bool isSuccess =
              state.customersState.isSuccess &&
              state.salesRepState.isSuccess &&
              state.pricesState.isSuccess &&
              state.inventoryItemsState.isSuccess &&
              state.inventoryUnitsState.isSuccess &&
              state.salesTaxesState.isSuccess;

          if (isLoading) {
            _animationController.repeat();
          } else {
            _animationController.stop();
            if (isSuccess || hasError) {
              _animationController.reset();
            }
          }
        },
        builder: (context, state) {
          final bool hasError =
              state.customersState.errorCode != null ||
              state.salesRepState.errorCode != null ||
              state.pricesState.errorCode != null ||
              state.inventoryItemsState.errorCode != null ||
              state.inventoryUnitsState.errorCode != null ||
              state.salesTaxesState.errorCode != null;

          final bool isSuccess =
              state.customersState.isSuccess &&
              state.salesRepState.isSuccess &&
              state.pricesState.isSuccess &&
              state.inventoryItemsState.isSuccess &&
              state.inventoryUnitsState.isSuccess &&
              state.salesTaxesState.isSuccess;

          final bool isLoading =
              state.customersState.isLoading ||
              state.salesRepState.isLoading ||
              state.pricesState.isLoading ||
              state.inventoryItemsState.isLoading ||
              state.inventoryUnitsState.isLoading ||
              state.salesTaxesState.isLoading;

          // Calculate progress (0.0 to 1.0)
          double progress = 0.0;
          int totalSteps = 6; // Total number of sync operations
          int completedSteps = 0;
          
          if (state.customersState.isSuccess) completedSteps++;
          if (state.salesRepState.isSuccess) completedSteps++;
          if (state.pricesState.isSuccess) completedSteps++;
          if (state.inventoryItemsState.isSuccess) completedSteps++;
          if (state.inventoryUnitsState.isSuccess) completedSteps++;
          if (state.salesTaxesState.isSuccess) completedSteps++;
          
          progress = completedSteps / totalSteps;

          return GradientPageLayout(
            useScroll: false,
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GradientFormCard(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            RotationTransition(
                              turns: _animationController,
                              child: Icon(
                                Icons.sync,
                                size: 32,
                                color: isSuccess
                                    ? Colors.green
                                    : hasError
                                        ? Colors.red
                                        : AppColors.primary,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              l10n.syncAllData,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${(progress * 100).toInt()}%',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.primary,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: GradientFormCard(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.syncStatus,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                            ),
                            const SizedBox(height: 16),
                            _buildApiLogSection(
                              l10n.customers,
                              state.customersState,
                            ),
                            const SizedBox(height: 8),
                            _buildApiLogSection(
                              l10n.salesRepCustomers,
                              state.salesRepState,
                            ),
                            const SizedBox(height: 8),
                            _buildApiLogSection(
                              l10n.prices,
                              state.pricesState,
                            ),
                            const SizedBox(height: 8),
                            _buildApiLogSection(
                              l10n.inventoryItems,
                              state.inventoryItemsState,
                            ),
                            const SizedBox(height: 8),
                            _buildApiLogSection(
                              l10n.inventoryUnits,
                              state.inventoryUnitsState,
                            ),
                            const SizedBox(height: 8),
                            _buildApiLogSection(
                              l10n.salesTaxes,
                              state.salesTaxesState,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: _buildSyncButton(context, state),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSyncButton(BuildContext context, SyncState state) {
    final l10n = AppLocalizations.of(context);
    final bool isLoading =
        state.customersState.isLoading ||
        state.salesRepState.isLoading ||
        state.pricesState.isLoading ||
        state.inventoryItemsState.isLoading ||
        state.inventoryUnitsState.isLoading ||
        state.salesTaxesState.isLoading;

    final bool hasError =
        state.customersState.errorCode != null ||
        state.salesRepState.errorCode != null ||
        state.pricesState.errorCode != null ||
        state.inventoryItemsState.errorCode != null ||
        state.inventoryUnitsState.errorCode != null ||
        state.salesTaxesState.errorCode != null;

    final bool isSuccess =
        state.customersState.isSuccess &&
        state.salesRepState.isSuccess &&
        state.pricesState.isSuccess &&
        state.inventoryItemsState.isSuccess &&
        state.inventoryUnitsState.isSuccess &&
        state.salesTaxesState.isSuccess;

    if (isSuccess && !hasError) {
      SharedPrefs.setSynced(true);
    }

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ElevatedButton(
        onPressed:
          isLoading
              ? null
              : () {
                if (isSuccess && !hasError) {
                  context.go(RouteConstants.map);
                } else {
                  // Start sync process
                  context.read<SyncBloc>().add(const SyncEvent.syncSalesTaxes());
                  context.read<SyncBloc>().add(const SyncEvent.syncCustomers());
                  context.read<SyncBloc>().add(
                    const SyncEvent.syncSalesRepCustomers(),
                  );
                  context.read<SyncBloc>().add(const SyncEvent.syncPrices());
                  context.read<SyncBloc>().add(
                    const SyncEvent.syncInventoryItems(),
                  );
                  context.read<SyncBloc>().add(
                    const SyncEvent.syncInventoryUnits(),
                  );
                }
              },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(16),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child:
          isLoading
              ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
              : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isSuccess && !hasError ? l10n.start : l10n.syncAllData,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (isSuccess || hasError) ...[
                    const SizedBox(width: 8),
                    Icon(
                      isSuccess ? Icons.check_circle : Icons.error,
                      color: Colors.white,
                      size: 20,
                    ),
                  ],
                ],
              ),
    ));
  }

  Widget _buildApiLogSection(String title, ApiCallState state) {
    return Builder(
      builder: (context) {
        final l10n = AppLocalizations.of(context);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 8),
                if (state.isLoading)
                  const SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else if (state.isSuccess)
                  const Icon(Icons.check_circle, color: Colors.green, size: 16)
                else if (state.errorCode != null)
                  const Icon(Icons.error, color: Colors.red, size: 16),
              ],
            ),
            if (state.errorCode != null) ...[
              const SizedBox(height: 4),
              Text(
                ApiErrorCode.getErrorMessage(state.errorCode!),
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ] else if (state.isSuccess && state.data != null) ...[
              const SizedBox(height: 4),
              Text(
                l10n.recordsSynced(state.data!.length),
                style: const TextStyle(color: Colors.green, fontSize: 12),
              ),
            ],
          ],
        );
      },
    );
  }
}
