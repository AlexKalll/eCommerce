import 'package:go_router/go_router.dart';

import '../../../features/product/domain/entities/product.dart';
import '../../../features/product/presentation/pages/pages.dart';
import 'app_routes.dart';

final router = GoRouter(
  routes: <RouteBase>[
    //
    GoRoute(
      path: Routes.home,
      builder: (context, state) => HomePage(),
    ),

    //
    GoRoute(
      path: Routes.productDetail,
      builder: (context, state) {
        final product = state.extra as Product;
        return ProductDetailPage(product: product);
      },
    ),

    //
    GoRoute(
      path: Routes.addProduct,
      builder: (context, state) => const AddProductPage(),
    ),

    //
    GoRoute(
      path: Routes.updateProduct,
      builder: (context, state) {
        final product = state.extra as Product;
        return UpdateProductPage(product: product);
      },
    ),
  ],
);