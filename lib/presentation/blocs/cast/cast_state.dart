part of 'cast_cubit.dart';

class CastState extends Equatable {
  const CastState({
    this.statusFetchDevice = FormzSubmissionStatus.initial,
    this.statusConnectDevice = FormzSubmissionStatus.initial,
    this.listDevice = const [],
  });

  final FormzSubmissionStatus statusFetchDevice;
  final FormzSubmissionStatus statusConnectDevice;
  final List<Device> listDevice;

  CastState copyWith({
    FormzSubmissionStatus? statusFetchDevice,
    FormzSubmissionStatus? statusConnectDevice,
    List<Device>? listDevice,
  }) {
    return CastState(
      statusFetchDevice: statusFetchDevice ?? this.statusFetchDevice,
      listDevice: listDevice ?? this.listDevice,
      statusConnectDevice: statusConnectDevice ?? this.statusConnectDevice,
    );
  }

  @override
  List<Object> get props => [
        statusFetchDevice,
        listDevice,
        statusConnectDevice,
      ];
}
