import 'package:bmi_calculator/app.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (c, s) => const BMIHomePage())
  ],
);
