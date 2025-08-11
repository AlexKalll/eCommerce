import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/http.dart';
import 'core/network/network_info.dart';
import 'features/auth/data/datasources/local/auth_local_data_source.dart';
import 'features/auth/data/datasources/local/auth_local_data_source_impl.dart';
import 'features/auth/data/datasources/remote/auth_remote_data_source.dart';
import 'features/auth/data/datasources/remote/auth_remote_data_source_impl.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/get_current_user.dart';
import 'features/auth/domain/usecases/login.dart';
import 'features/auth/domain/usecases/logout.dart';
import 'features/auth/domain/usecases/register.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/product/data/data_sources/local/local_data_source.dart';
import 'features/product/data/data_sources/local/local_data_source_impl.dart';
import 'features/product/data/data_sources/remote/remote_data_source.dart';
import 'features/product/data/data_sources/remote/remote_data_source_impl.dart';
import 'features/product/data/repositories/product_repository_impl.dart';
import 'features/product/domain/repositories/product_repository.dart';
import 'features/product/domain/usecases/create_product.dart';
import 'features/product/domain/usecases/delete_product.dart';
import 'features/product/domain/usecases/get_all_products.dart';
import 'features/product/domain/usecases/update_product.dart';
import 'features/product/presentation/bloc/product/product_bloc.dart';

final serviceLocator = GetIt.instance;

Future<void> init() async {
  //! Features
  //! Feature_#1 (Product) -----------------------------------------------------

  // Bloc
  serviceLocator.registerFactory(() => ProductsBloc(
      createProduct: serviceLocator(),
      updateProduct: serviceLocator(),
      getAllProducts: serviceLocator(),
      deleteProduct: serviceLocator()));

  // Use cases
  serviceLocator.registerLazySingleton(() => CreateProduct(serviceLocator()));
  serviceLocator.registerLazySingleton(() => UpdateProduct(serviceLocator()));
  serviceLocator.registerLazySingleton(() => DeleteProduct(serviceLocator()));
  serviceLocator.registerLazySingleton(() => GetAllProducts(serviceLocator()));

  // Repository
  serviceLocator.registerLazySingleton<ProductRepository>(() =>
      ProductRepositoryImpl(
          networkInfo: serviceLocator(),
          remoteDataSource: serviceLocator(),
          localDataSource: serviceLocator()));

  // Data
  serviceLocator.registerLazySingleton<ProductLocalDataSource>(
      () => ProductLocalDataSourceImpl(sharedPreferences: serviceLocator()));
  serviceLocator.registerLazySingleton<ProductRemoteDataSource>(
      () => ProductRemoteDataSourceImpl(client: serviceLocator()));

  //! Features
  //! Feature_#2 (Auth) -----------------------------------------------------

  // Bloc
  serviceLocator.registerFactory(() => AuthBloc(
      login: serviceLocator(),
      register: serviceLocator(),
      logout: serviceLocator(),
      getCurrentUser: serviceLocator()));

  // Use cases
  serviceLocator.registerLazySingleton(() => Login(serviceLocator()));
  serviceLocator.registerLazySingleton(() => Register(serviceLocator()));
  serviceLocator.registerLazySingleton(() => Logout(serviceLocator()));
  serviceLocator.registerLazySingleton(() => GetCurrentUser(serviceLocator()));

  // Repository
  serviceLocator.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
      client: serviceLocator(),
      remoteDataSource: serviceLocator(),
      localDataSource: serviceLocator(),
      networkInfo: serviceLocator()));

  // Data
  serviceLocator.registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(sharedPreferences: serviceLocator()));
  serviceLocator.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(client: serviceLocator()));

  //! Core ---------------------------------------------------------------------
  serviceLocator.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(serviceLocator()));

  //! External -----------------------------------------------------------------
  final sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton(() => sharedPreferences);
  serviceLocator.registerLazySingleton(() => InternetConnectionChecker());
  serviceLocator.registerLazySingleton(() => http.Client());
  serviceLocator.registerLazySingleton(() => HttpClient(
      multipartRequestFactory: multipartRequestFactory,
      client: serviceLocator()));
}