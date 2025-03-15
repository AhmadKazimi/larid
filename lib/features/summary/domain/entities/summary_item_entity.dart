import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'summary_item_entity.freezed.dart';

@freezed
class SummaryItemEntity with _$SummaryItemEntity {
  const factory SummaryItemEntity({
    required String id,
    required String title,
    required String subtitle,
    required DateTime date,
    required double amount,
    required bool isSynced,
    String? details,
  }) = _SummaryItemEntity;
}
