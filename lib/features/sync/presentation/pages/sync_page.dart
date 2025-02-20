import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/error_codes.dart';
import '../bloc/sync_bloc.dart';
import '../bloc/sync_event.dart';
import '../bloc/sync_state.dart';

class SyncPage extends StatelessWidget {
  const SyncPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sync')),
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
                      const Text(
                        'Sync Status',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildApiLogSection('Customers', state.customersState),
                      if (state.salesRepState.isLoading ||
                          state.salesRepState.isSuccess ||
                          state.salesRepState.errorCode != null) ...[
                        const Divider(height: 24, thickness: 1),
                        _buildApiLogSection('Sales Rep', state.salesRepState),
                      ],
                      if (state.pricesState.isLoading ||
                          state.pricesState.isSuccess ||
                          state.pricesState.errorCode != null) ...[
                        const Divider(height: 24, thickness: 1),
                        _buildApiLogSection('Prices', state.pricesState),
                      ],
                      if (state.inventoryItemsState.isLoading ||
                          state.inventoryItemsState.isSuccess ||
                          state.inventoryItemsState.errorCode != null) ...[
                        const Divider(height: 24, thickness: 1),
                        _buildApiLogSection(
                          'Inventory Items',
                          state.inventoryItemsState,
                        ),
                      ],
                      if (state.inventoryUnitsState.isLoading ||
                          state.inventoryUnitsState.isSuccess ||
                          state.inventoryUnitsState.errorCode != null) ...[
                        const Divider(height: 24, thickness: 1),
                        _buildApiLogSection(
                          'Inventory Units',
                          state.inventoryUnitsState,
                        ),
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
    final bool isLoading =
        state.customersState.isLoading ||
        state.salesRepState.isLoading ||
        state.inventoryUnitsState.isLoading;
    final bool hasError =
        state.customersState.errorCode != null ||
        state.salesRepState.errorCode != null ||
        state.inventoryUnitsState.errorCode != null;
    final bool isSuccess =
        state.customersState.isSuccess &&
        state.salesRepState.isSuccess &&
        state.inventoryUnitsState.isSuccess;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed:
            isLoading
                ? null
                : () {
                  context.read<SyncBloc>().add(const SyncEvent.syncCustomers());
                  context.read<SyncBloc>().add(
                    const SyncEvent.syncSalesRepCustomers(),
                  );
                  context.read<SyncBloc>().add(const SyncEvent.syncPrices());
                  context.read<SyncBloc>().add(const SyncEvent.syncInventoryItems());
                  context.read<SyncBloc>().add(const SyncEvent.syncInventoryUnits());
                },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child:
            isLoading
                ? const SizedBox(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Sync All Data',
                      style: TextStyle(
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
            '${state.data!.length} records synced',
            style: const TextStyle(color: Colors.green, fontSize: 12),
          ),
        ],
      ],
    );
  }
}
