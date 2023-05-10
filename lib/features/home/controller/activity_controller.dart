import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_x_yasien/core/enum/loading_state.dart';
import 'package:riverpod_x_yasien/models/activity_model.dart';

import '../repository/activity_repository.dart';

final activityControllerSNProvider =
    StateNotifierProvider<ActivityController, ActivityModel>((ref) {
  return ActivityController(ref);
});

class ActivityController extends StateNotifier<ActivityModel> {
  ActivityController(Ref ref)
      : _repo = ref.read(activityRepositoryProvider),
        super(const ActivityModel());

  final ActivityRepository _repo;

  Future<void> getActivity() async {
    state = state.copyWith(
      loadingState: LoadingState.progress,
    );

    final result = await _repo.getActivity();

    result.fold(
      (failure) => state = state.copyWith(
        loadingState: LoadingState.error,
        activity: failure.message,
      ),
      (response) => state = state.copyWith(
        loadingState: LoadingState.success,
        activity: response.activity,
        type: response.type,
        participants: response.participants,
      ),
    );
  }

  Future<void> reloadActivity() async {
    await getActivity();
  }
}
