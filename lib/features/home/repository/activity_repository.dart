import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_x_yasien/core/types/failure.dart';
import 'package:riverpod_x_yasien/models/activity_model.dart';

final activityRepositoryProvider = Provider<ActivityRepository>((ref) {
  return ActivityRepository();
});

class ActivityRepository {
  final _dio = Dio();

  Future<Either<Failure, ActivityModel>> getActivity() async {
    try {
      final response = await _dio.get('http://www.boredapi.com/api/activity');

      final activity = ActivityModel.fromJson(response.data);

      return Right(activity);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
