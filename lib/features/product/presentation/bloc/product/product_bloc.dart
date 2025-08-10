import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/usecase.dart';
import '../../../domain/entities/product.dart';
import '../../../domain/usecases/create_product.dart';
import '../../../domain/usecases/delete_product.dart';
import '../../../domain/usecases/get_all_products.dart';
import '../../../domain/usecases/update_product.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final CreateProduct createProduct;
  final UpdateProduct updateProduct;
  final GetAllProducts getAllProducts;
  final DeleteProduct deleteProduct;

  ProductsBloc({
    required this.createProduct,
    required this.updateProduct,
    required this.getAllProducts,
    required this.deleteProduct,
  }) : super(const ProductsInitial([])) {
    on<ProductsLoadRequested>(_onLoadProductsRequested);
    on<ProductsProductAdded>(_onProductAdded);
    on<ProductsProductUpdated>(_onProductUpdated);
    on<ProductsProductDeleted>(_onProductDeleted);
  }

  Future<void> _onLoadProductsRequested(
      ProductsLoadRequested event, Emitter<ProductsState> emit) async {
    emit(ProductsLoadInProgress(state.products));

    final products = await getAllProducts(NoParams());

    products.fold(
      (failure) => emit(ProductsFailure(failure.message, state.products)),
      (products) => emit(ProductsLoadSuccess(products)),
    );
  }

  Future<void> _onProductAdded(
      ProductsProductAdded event, Emitter<ProductsState> emit) async {
    emit(ProductsAddInProgress(state.products));

    final result = await createProduct(CreateProductParams(event.product));

    final products = await getAllProducts(NoParams());

    result.fold(
      (failure) => emit(ProductsFailure(failure.message, state.products)),
      (product) {
        products.fold(
            (failure) => emit(ProductsFailure(failure.message, state.products)),
            (products) => emit(ProductsAddSuccess(event.product, products)));
      },
    );
  }

  Future<void> _onProductUpdated(
      ProductsProductUpdated event, Emitter<ProductsState> emit) async {
    emit(ProductsUpdateInProgress(state.products));

    final result = await updateProduct(UpdateProductParams(event.product));

    result.fold(
        (failure) => emit(ProductsFailure(failure.message, state.products)),
        (updatedProduct) {
      final newProducts = state.products.map((product) {
        if (product.id == updatedProduct.id) {
          return updatedProduct;
        }
        return product;
      }).toList();

      emit(ProductsUpdateSuccess(newProducts));
    });
  }

  Future<void> _onProductDeleted(
      ProductsProductDeleted event, Emitter<ProductsState> emit) async {
    emit(ProductsDeleteInProgress(state.products));

    final result = await deleteProduct(DeleteProductParams(event.product.id));

    result.fold(
      (failure) => emit(ProductsFailure(failure.message, state.products)),
      (products) => emit(ProductsDeleteSuccess(
        event.product.name,
        state.products.where((product) => event.product != product).toList(),
      )),
    );
  }
}