part of 'app_cubit.dart';

class CastState extends Equatable {
  const CastState({
    this.statusConnect = FormzSubmissionStatus.initial,
  });

  final FormzSubmissionStatus statusConnect;

  CastState copyWith({
    FormzSubmissionStatus? statusConnect,
  }) {
    return CastState(
      statusConnect: statusConnect ?? this.statusConnect,
    );
  }

  @override
  List<Object> get props => [
        statusConnect,
      ];
}
