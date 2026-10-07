import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client_provider.dart';
import '../data/quote_repository.dart';
import '../models/quote_model.dart';

final quoteRepositoryProvider = Provider<QuoteRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return QuoteRepository(apiClient);
});

final myQuotesProvider = FutureProvider<List<QuoteModel>>((ref) async {
  final repo = ref.watch(quoteRepositoryProvider);
  return await repo.getMyQuotes();
});
