import 'package:flutter/material.dart';
import 'package:riverpod_x_yasien/core/enum/loading_state.dart';

@immutable
class ActivityModel {
  final String activity;
  final String type;
  final int participants;
  final LoadingState loadingState;

  const ActivityModel({
    this.activity = '',
    this.type = '',
    this.participants = 0,
    this.loadingState = LoadingState.progress,
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      activity: json['activity'],
      type: json['type'],
      participants: json['participants'],
    );
  }

  ActivityModel copyWith({
    String? activity,
    String? type,
    int? participants,
    LoadingState? loadingState,
  }) {
    return ActivityModel(
      activity: activity ?? this.activity,
      type: type ?? this.type,
      participants: participants ?? this.participants,
      loadingState: loadingState ?? this.loadingState,
    );
  }

  factory ActivityModel.initialState() {
    return const ActivityModel(
      activity: '',
      type: '',
      participants: 0,
      loadingState: LoadingState.progress,
    );
  }
}
