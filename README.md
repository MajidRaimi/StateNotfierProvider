## Riverpod using StateNotifierProvider and fetch data from API

### To approach this project, I have used the following packages:

- [Riverpod](https://pub.dev/packages/riverpod)
- [Dio](https://pub.dev/packages/dio)
- [DartZ](https://pub.dev/packages/dartz)

### What is our approach?

- We will use the StateNotifierProvider to manage the state of our application.
- Fetch data from API using Dio.

### How to do it?

1. Create Our Model
   - Create a `models` file and create a `activity_model.dart` file.
   - Create an immutable class `ActivityModel` that must contain
     - All variables that we need to fetch from API.
     - Constructor Without Parameters
     - `.fromJson()` factory method
     - `.copyWith()` factory method
     - `.initialState()` factory method _Not much needed_
2. Create Our Repository
   - Create a `repositories` file and create a `activity_repository.dart` file.
   - Create a class named `ActivityRepository` that must contain
     - A `Dio` instance
     - A `Future` method named `getActivity()` that must return a `ActivityModel` object that must return either `ActivityModel` or `Failure`.
   - Create a Simple Provider named `activityRepositoryProvider` that must return a `ActivityRepository` object.
3. Create Our Controller
   - Create a `controllers` file and create a `activity_controller.dart` file.
   - Create a class named `ActivityController` that must contain
     - A `StateNotifier` named `activityStateNotifier` that must return a `ActivityModel` object.
     - A `Future` method named `getActivity()` that return nothing or void.
   - Create a State Notifier Provider named `activityControllerSNProvider` that must return a `ActivityModel` and `ActivityController` object.
4. Create Our View
   - Create a `views` file and create a `home_screen.dart` file.
   - Create a Consumer State Full Widget named `HomeScreen` that must contain
     - A `initState()` function with bindings.
   - Display your data

<hr>

### 1 - Create Our Model

- Create a `models` file and create a `activity_model.dart` file.
- Create an immutable class `ActivityModel` that must contain.

```dart
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
```

#### <span style="color: cyan"> Explanation </span>

- `@immutable` is used to make our class immutable.
- `LoadingState` is an enum that we will already created.
- `LoadingState.progress` is the default value of our `loadingState` variable.
- All the variables are optional and have a default value.
- `factory ModelName.fromJson(Map<String, dynamic> json)` is a factory method that will return a `ModelName` object.
- `ModelName copyWith({})` is a factory method that will return a `ModelName` object.
- `factory ModelName.initialState()` is a factory method that will return a `ModelName` object with the initial values.

<hr>

### 2 - Create Our Repository

- Create a `repositories` file and create a `activity_repository.dart` file.
- Create a class named `ActivityRepository` that must contain.

```dart
class ActivityRepository {
  final Dio _dio;

  ActivityRepository(this._dio);

  Future<Either<Failure, ActivityModel>> getActivity() async {
    try {
      final response = await _dio.get('http://www.boredapi.com/api/activity');
      final activity = ActivityModel.fromJson(response.data);
      return Right(activity);
    } on DioError catch (e) {
      return Left(Failure(e.message));
    }
  }
}
```
- Create a Simple Provider named `activityRepositoryProvider` that must return a `ActivityRepository` object.

```dart
final activityRepositoryProvider = Provider<ActivityRepository>((ref) => ActivityRepository());
```

#### <span style="color: cyan"> Explanation </span>
- `NameRepository` is a class that will contain a `Dio` instance.
- `NameRepository` is a class that will contain a `Future` method named `doSomething()` that will return a `NameModel` object or a `Failure` object.
- `nameRepositoryProvider` is a simple provider that will return a `NameRepository` object.

<hr>

### 3 - Create Our Controller

- Create a `controllers` file and create a `activity_controller.dart` file.
- Create a class named `ActivityController` that must contain two things the `Ref` and the `_repo` while constructing  .

```dart
class ActivityController extends StateNotifier<ActivityModel> {
  ActivityController(Ref ref)
      : _repo = ref.read(activityRepositoryProvider),
        super(const ActivityModel());

  final ActivityRepository _repo;
}
```

- Create a `Future` method named `getActivity()` that return nothing or void.
```dart
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
```
All you need to do to change the state is to use the `state` variable and the `copyWith()` method.

- Create a State Notifier Provider named `activityControllerSNProvider` that must return a `ActivityModel` and `ActivityController` object.

```dart
final activityControllerSNProvider = StateNotifierProvider<ActivityController, ActivityModel>(
  (ref) => ActivityController(ref),
);
```

#### <span style="color: cyan"> Explanation </span>
- `NameController` is a class that will contain a `Ref` and a `NameRepository` instance.
- `NameController` is a class that will contain a `Future` method named `doSomething()` that will return nothing or void.
- `nameControllerSNProvider` is a State Notifier Provider that will return a `NameModel` and `NameController` object. Example: `StateNotifierProvider<NameController, NameModel>`
- `ref.read(nameRepositoryProvider)` is used to read the `NameRepository` instance.
- `state = state.copyWith()` is used to change the state.
- `state.copyWith()` is a method that will return a `NameModel` object with the new values.

<hr>

### 4 - Create Our View
- Create a `views` folder and create a `home_screen.dart` file.
- Create a Consumer State Full Widget named `HomeScreen` that must contain.

```dart
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
      body: response.loadingState == LoadingState.progress
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    response.activity, // There will be the activity
                  ),
                ],
              ),
            ),
    );
  }
}
```

#### <span style="color: cyan"> Explanation </span>
- `HomeScreen` is a Consumer State Full Widget that will contain a `Ref` instance.
- `initState` is a method that will be called when the widget is created.
- `WidgetsBinding.instance.addPostFrameCallback` is a method that will be called after the widget is created. _will ensure that there is no problems in the widget tree_
- `ref.read(nameControllerSNProvider.notifier).doSomething()` is the way to access our methods in the controller.
- `ref.watch(activityControllerSNProvider)` is the way to access our state (values) in the controller.


<hr>

### That's it, you have created your first State Notifier Provider.