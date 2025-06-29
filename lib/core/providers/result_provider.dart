import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/result.dart';
import '../services/result_service.dart';

final resultServiceProvider = Provider<ResultService>((ref) => ResultService());

final resultProvider =
    FutureProvider.family<QuizResult?, String>((ref, resultId) async {
  final service = ref.watch(resultServiceProvider);
  return service.getResult(resultId);
});

final userResultsProvider =
    FutureProvider.family<List<QuizResult>, String>((ref, adminEmail) async {
  final service = ref.watch(resultServiceProvider);
  return service.getResultsForUser(adminEmail);
});

final resultActionsProvider = Provider<ResultActions>((ref) {
  final service = ref.watch(resultServiceProvider);
  return ResultActions(service);
});

class ResultActions {
  final ResultService _service;
  ResultActions(this._service);

  Future<void> saveResult(QuizResult result) => _service.saveResult(result);
}
