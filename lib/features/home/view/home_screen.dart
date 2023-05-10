import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/enum/loading_state.dart';
import '../controller/activity_controller.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(activityControllerSNProvider.notifier).getActivity();
    });
  }

  @override
  Widget build(BuildContext context) {
    final response = ref.watch(activityControllerSNProvider);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(activityControllerSNProvider.notifier).reloadActivity();
        },
        child: const Icon(Icons.refresh),
      ),
      appBar: AppBar(
        title: const Text('Flutter Demo Home Page'),
      ),
      body: response.loadingState == LoadingState.progress
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    response.activity,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  Text(
                    response.type,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Text(
                    response.participants.toString(),
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ],
              ),
            ),
    );
  }
}
