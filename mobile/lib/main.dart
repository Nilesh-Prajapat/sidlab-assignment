import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskflow/screens/splash_screen.dart';
import 'package:taskflow/utils/theme/app_theme.dart';
import 'package:taskflow/utils/theme/colors.dart';
import 'api_service/auth_bloc.dart';
import 'api_service/auth_service.dart';
import 'api_service/task_bloc.dart';
import 'api_service/task_service.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/tasks/task_list_screen.dart';
import 'screens/tasks/create_task_screen.dart';
import 'screens/profile/profile_screen.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: AppColors.topBar,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );

  runApp(const TaskflowApp());
}
class TaskflowApp extends StatelessWidget {
  const TaskflowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
          AuthBloc(AuthService())..add(AuthCheckRequested()),
        ),
        BlocProvider(
          create: (_) => TaskBloc(TaskService()),
        ),
      ],
      child:MaterialApp(
        title: 'Taskflow',
        debugShowCheckedModeBanner: false,

        darkTheme: AppTheme.dark,

        themeMode: ThemeMode.dark,

        home: const SplashScreen(),

        routes: {
          '/login': (_) => const LoginScreen(),
          '/register': (_) => const RegisterScreen(),
          '/home': (_) => const AppShell(),
        },
      )
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();

    _screens = [

      HomeScreen(
        onSeeAll: () {
          setState(() {
            _index = 1;
          });
        },

        onAddTask: () {
          setState(() {
            _index = 2;
          });
        },
      ),

      /// TASK LIST
      const TaskListScreen(),

      /// CREATE
      const CreateTaskScreen(),

      /// PROFILE
      const ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_index],

      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          Container(height: 1, color: AppColors.borderMuted),

          NavigationBar(

            selectedIndex: _index,

            onDestinationSelected: (i) {
              setState(() => _index = i);
            },

            destinations: const [

              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home_rounded),
                label: 'HOME',
              ),

              NavigationDestination(
                icon: Icon(Icons.check_box_outline_blank_rounded),
                selectedIcon: Icon(Icons.check_box_rounded),
                label: 'TASKS',
              ),

              NavigationDestination(
                icon: Icon(Icons.add),
                selectedIcon: Icon(Icons.add),
                label: 'ADD',
              ),

              NavigationDestination(
                icon: Icon(Icons.person_outline_rounded),
                selectedIcon: Icon(Icons.person_rounded),
                label: 'PROFILE',
              ),
            ],
          ),
        ],
      ),
    );
  }
}