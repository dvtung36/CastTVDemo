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
                    previous.listDevice != current.listDevice,
                builder: (context, state) {
                  if (!state.statusConnect.isFailure) {
                    return const Center(
                      child: Text(
                        'Scan device failure',
                        style: TextStyle(color: Colors.black),
                      ),
                    );
                  }
                  if (!state.statusConnect.isSuccess) {
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
                      return Row(
                        children: [
                          Text(
                            '${device.id}: ',
                            style: const TextStyle(color: Colors.black),
                          ),
                          Text(
                            device.name,
                            style: const TextStyle(color: Colors.black),
                          )
                        ],
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
