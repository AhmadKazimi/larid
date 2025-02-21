import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/error/error_codes.dart';
import '../../../../core/router/route_constants.dart';
import '../../../../core/storage/shared_prefs.dart';
import '../bloc/sync_bloc.dart';
import '../bloc/sync_event.dart';
import '../bloc/sync_state.dart';

class SyncPage extends StatelessWidget {
  const SyncPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.sync)),
      body: BlocBuilder<SyncBloc, SyncState>(
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.syncStatus,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildApiLogSection(l10n.customers, state.customersState),
                      if (state.salesRepState.isLoading ||
                          state.salesRepState.isSuccess ||
                          state.salesRepState.errorCode != null) ...[
                        const SizedBox(height: 8),
                        _buildApiLogSection(
                          l10n.salesRepCustomers, state.salesRepState),
                      ],
                      if (state.pricesState.isLoading ||
                          state.pricesState.isSuccess ||
                          state.pricesState.errorCode != null) ...[
                        const SizedBox(height: 8),
                        _buildApiLogSection(l10n.prices, state.pricesState),
                      ],
                      if (state.inventoryItemsState.isLoading ||
                          state.inventoryItemsState.isSuccess ||
                          state.inventoryItemsState.errorCode != null) ...[
                        const SizedBox(height: 8),
                        _buildApiLogSection(
                          l10n.inventoryItems, state.inventoryItemsState),
                      ],
                      if (state.inventoryUnitsState.isLoading ||
                          state.inventoryUnitsState.isSuccess ||
                          state.inventoryUnitsState.errorCode != null) ...[
                        const SizedBox(height: 8),
                        _buildApiLogSection(
                          l10n.inventoryUnits, state.inventoryUnitsState),
                      ],
                      if (state.salesTaxesState.isLoading ||
                          state.salesTaxesState.isSuccess ||
                          state.salesTaxesState.errorCode != null) ...[
                        const SizedBox(height: 8),
                        _buildApiLogSection(
                          l10n.salesTaxes, state.salesTaxesState),
                      ],
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                child: _buildSyncButton(context, state),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSyncButton(BuildContext context, SyncState state) {
    final l10n = AppLocalizations.of(context)!;
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

    // Update sync status when all APIs are synced successfully
    if (isSuccess && !hasError) {
      SharedPrefs.setSynced(true);
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading
            ? null
            : () {
                if (isSuccess && !hasError) {
                  // Navigate to map page
                  context.go(RouteConstants.map);
                } else {
                  // Start sync process
                  context.read<SyncBloc>().add(const SyncEvent.syncCustomers());
                  context.read<SyncBloc>().add(
                        const SyncEvent.syncSalesRepCustomers(),
                      );
                  context.read<SyncBloc>().add(const SyncEvent.syncPrices());
                  context.read<SyncBloc>().add(const SyncEvent.syncInventoryItems());
                  context.read<SyncBloc>().add(const SyncEvent.syncInventoryUnits());
                  context.read<SyncBloc>().add(const SyncEvent.syncSalesTaxes());
                }
              },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isLoading
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
      ),
    );
  }

  Widget _buildApiLogSection(String title, ApiCallState state) {
    return Builder(
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
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
