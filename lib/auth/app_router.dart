import 'package:auto_route/auto_route.dart';
import 'package:todolistapp/auth/auth_guard.dart';
import 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: SignupRoute.page,
        ),
        AutoRoute(page: LoginRoute.page),
        AutoRoute(page: HomeRoute.page, initial: true, guards: [AuthGuard()]),
      ];
}
