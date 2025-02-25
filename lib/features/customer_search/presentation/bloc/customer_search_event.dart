import 'package:flutter/foundation.dart';

@immutable
sealed class CustomerSearchEvent {
  const CustomerSearchEvent();
}

class LoadInitialData extends CustomerSearchEvent {
  const LoadInitialData();
}

class SearchQueryChanged extends CustomerSearchEvent {
  final String query;
  final bool searchInToday;

  const SearchQueryChanged({
    required this.query,
    required this.searchInToday,
  });
}
