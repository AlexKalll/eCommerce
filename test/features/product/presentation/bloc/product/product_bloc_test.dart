import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ecommerce/core/error/failure.dart';
import 'package:ecommerce/core/usecase.dart';
import 'package:ecommerce/features/product/domain/entities/product.dart';
import 'package:ecommerce/features/product/domain/usecases/create_product.dart';
import 'package:ecommerce/features/product/domain/usecases/delete_product.dart';
import 'package:ecommerce/features/product/domain/usecases/get_all_products.dart';
import 'package:ecommerce/features/product/domain/usecases/update_product.dart';
import 'package:ecommerce/features/product/presentation/bloc/product/product_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'product_bloc_test.mocks.dart';

@GenerateMocks([GetAllProducts, CreateProduct, UpdateProduct, DeleteProduct])
void main() {
  late GetAllProducts getAllProducts;
  late CreateProduct createProduct;
  late UpdateProduct updateProduct;
  late DeleteProduct deleteProduct;
  late ProductsBloc productsBloc;

  setUp(() {
    getAllProducts = MockGetAllProducts();
    createProduct = MockCreateProduct();
    updateProduct = MockUpdateProduct();
    deleteProduct = MockDeleteProduct();
    productsBloc = ProductsBloc(
      getAllProducts: getAllProducts,
      createProduct: createProduct,
      updateProduct: updateProduct,
      deleteProduct: deleteProduct,
    );
  });

  const tProduct = Product(
      id: 'id',
      name: 'name',
      description: 'description',
      price: 123.45,
      imageUrl: 'https://product.image.com/id');
  const tProducts = [tProduct];

  test('initial state should be ProductsInitial', () {
    expect(productsBloc.state, const ProductsInitial([]));
  });

  group('loading products', () {
    blocTest<ProductsBloc, ProductsState>(
        'emits [ProductsLoadInProgress, ProductsLoadSuccess] when product is loaded successfully',
        build: () => productsBloc,
        setUp: () => when(getAllProducts(NoParams()))
            .thenAnswer((_) async => const Right(tProducts)),
        act: (bloc) => bloc.add(ProductsLoadRequested()),
        expect: () =>
            const [ProductsLoadInProgress([]), ProductsLoadSuccess(tProducts)]);

    blocTest<ProductsBloc, ProductsState>(
        'emits [ProductsLoadInProgress, ProductsFailure] when error occurs',
        build: () => productsBloc,
        setUp: () => when(getAllProducts(NoParams()))
            .thenAnswer((_) async => const Left(ServerFailure('error'))),
        act: (bloc) => bloc.add(ProductsLoadRequested()),
        expect: () =>
            const [ProductsLoadInProgress([]), ProductsFailure('error', [])]);
  });

  group('create new products', () {
    blocTest<ProductsBloc, ProductsState>(
        'emits [ProductsAddInProgress, ProductsAddSuccess] on success',
        build: () => productsBloc,
        setUp: () {
          when(createProduct(const CreateProductParams(tProduct)))
              .thenAnswer((_) async => const Right(tProduct));
          when(getAllProducts(NoParams()))
              .thenAnswer((_) async => const Right(tProducts));
        },
        act: (bloc) => bloc.add(const ProductsProductAdded(tProduct)),
        expect: () => const [
              ProductsAddInProgress([]),
              ProductsAddSuccess(tProduct, tProducts)
            ]);

    blocTest<ProductsBloc, ProductsState>(
        'emits [ProductsAddInProgress, ProductsFailure] on error',
        build: () => productsBloc,
        setUp: () {
          when(createProduct(const CreateProductParams(tProduct)))
              .thenAnswer((_) async => const Left(ServerFailure('error')));
          when(getAllProducts(NoParams()))
              .thenAnswer((_) async => const Right(tProducts));
        },
        act: (bloc) => bloc.add(const ProductsProductAdded(tProduct)),
        expect: () =>
            const [ProductsAddInProgress([]), ProductsFailure('error', [])]);
  });

  group('update products', () {
    blocTest<ProductsBloc, ProductsState>(
        'emits [ProductsUpdateInProgress, ProductsUpdateSuccess] on success',
        build: () => productsBloc,
        setUp: () {
          when(updateProduct(const UpdateProductParams(tProduct)))
              .thenAnswer((_) async => const Right(tProduct));
        },
        act: (bloc) => bloc.add(const ProductsProductUpdated(tProduct)),
        expect: () => const [
              ProductsUpdateInProgress([]),
              ProductsUpdateSuccess(tProducts)
            ]);

    blocTest<ProductsBloc, ProductsState>(
        'emits [ProductsUpdateInProgress, ProductsFailure] on error',
        build: () => productsBloc,
        setUp: () {
          when(updateProduct(const UpdateProductParams(tProduct)))
              .thenAnswer((_) async => const Left(ServerFailure('error')));
        },
        act: (bloc) => bloc.add(const ProductsProductUpdated(tProduct)),
        expect: () =>
            const [ProductsUpdateInProgress([]), ProductsFailure('error', [])]);
  });

  group('delete products', () {
    blocTest<ProductsBloc, ProductsState>(
        'emits [ProductsDeleteInProgress, ProductsDeleteSuccess] on success',
        build: () => productsBloc,
        setUp: () {
          when(deleteProduct(DeleteProductParams(tProduct.id)))
              .thenAnswer((_) async => const Right(unit));
        },
        act: (bloc) => bloc.add(const ProductsProductDeleted(tProduct)),
        expect: () => [
              const ProductsDeleteInProgress([]),
              ProductsDeleteSuccess(tProduct.name, tProducts)
            ]);

    blocTest<ProductsBloc, ProductsState>(
        'emits [ProductsDeleteInProgress, ProductsFailure] on error',
        build: () => productsBloc,
        setUp: () {
          when(deleteProduct(DeleteProductParams(tProduct.id)))
              .thenAnswer((_) async => const Left(ServerFailure('error')));
        },
        act: (bloc) => bloc.add(const ProductsProductDeleted(tProduct)),
        expect: () =>
            const [ProductsDeleteInProgress([]), ProductsFailure('error', [])]);
  });
}