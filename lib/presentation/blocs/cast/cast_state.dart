part of 'cast_cubit.dart';

class CastState extends Equatable {
  const CastState({
    this.statusConnect = FormzSubmissionStatus.initial,
    this.listDevice = const [],
  });

  final FormzSubmissionStatus statusConnect;
  final List<Device> listDevice;

  CastState copyWith({
    FormzSubmissionStatus? statusConnect,
    List<Device>? listDevice,
  }) {
    return CastState(
      statusConnect: statusConnect ?? this.statusConnect,
      listDevice: listDevice ?? this.listDevice,
    );
  }

  @override
  List<Object> get props => [
        statusConnect,
        listDevice,
      ];
}
