import 'package:bmi_calculator/app.dart';
import 'package:bmi_calculator/feautes/bmi/presentation/views/bmi_input_screen.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (c, s) => const BMIHomePage(),
    ),
    GoRoute(
      path: '/input',
      builder: (c, s) => const BMIInputScreen(),
    ),
  ],
);
