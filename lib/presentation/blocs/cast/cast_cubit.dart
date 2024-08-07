import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:flutter/services.dart';

import '../../../core/bloc/base_cubit.dart';

part 'cast_state.dart';

class CastCubit extends BaseCubit<CastState> {
  CastCubit() : super(const CastState());
  static const platform = MethodChannel('unisoft_cast_tv');

  Future<void> fetchListDevice() async {
    try {
      final List<dynamic> devicesMap =
          await platform.invokeMethod('get_list_device');

      final List<Device> listDevices = devicesMap
          .map(
            (device) => Device.fromMap(
              Map<String, dynamic>.from(device),
            ),
          )
          .toList();

      emit(
        state.copyWith(
          statusConnect: FormzSubmissionStatus.success,
          listDevice: listDevices,
        ),
      );
    } on PlatformException catch (_) {
      emit(
        state.copyWith(
          statusConnect: FormzSubmissionStatus.failure,
        ),
      );
    }
  }
}

class Device {
  final String name;
  final String id;

  Device({
    required this.name,
    required this.id,
  });

  factory Device.fromMap(Map<String, dynamic> map) {
    return Device(
      name: map['name'],
      id: map['id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id': id,
    };
  }
}
