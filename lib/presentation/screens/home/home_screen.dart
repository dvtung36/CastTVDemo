import 'package:cast/presentation/blocs/cast/cast_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final CastCubit _castCubit;
  bool isFirstScan = true;

  @override
  void initState() {
    super.initState();

    _castCubit = context.read<CastCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connect TV'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                _castCubit.fetchListDevice();
                setState(() {
                  isFirstScan = false;
                });
              },
              child: Text(
                isFirstScan ? 'Scan device' : 'Fetch List Device',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            Expanded(
              child: BlocBuilder<CastCubit, CastState>(
                buildWhen: (previous, current) =>
                    previous.listDevice != current.listDevice ||
                    previous.statusFetchDevice != current.statusFetchDevice,
                builder: (context, state) {
                  if (state.statusFetchDevice.isFailure) {
                    return const Center(
                      child: Text(
                        'Scan device failure',
                        style: TextStyle(color: Colors.black),
                      ),
                    );
                  }
                  if (!state.statusFetchDevice.isSuccess) {
                    return const Center(
                      child: Text(
                        'click scan device',
                        style: TextStyle(color: Colors.black),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      final device = state.listDevice[index];
                      return Padding(
                        padding: const EdgeInsets.all(30),
                        child: InkWell(
                          onTap: () {
                            _castCubit.connectDevice(device);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.cyan,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'ID: ${device.id}: ',
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                  Text(
                                    'name: ${device.name}',
                                    style: const TextStyle(color: Colors.black),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: state.listDevice.length,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
