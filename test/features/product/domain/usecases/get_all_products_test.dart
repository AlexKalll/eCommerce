import 'package:dartz/dartz.dart';
import 'package:ecommerce/core/usecase.dart';
import 'package:ecommerce/features/product/domain/entities/product.dart';
import 'package:ecommerce/features/product/domain/repositories/product_repository.dart';
import 'package:ecommerce/features/product/domain/usecases/get_all_products.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// Run the following command to generate needed files:
// dart run build_runner build
import 'get_all_products_test.mocks.dart';

@GenerateMocks([ProductRepository])
void main() {
  late GetAllProducts getAllProducts;
  late MockProductRepository mockProductRepository;

  setUp(() {
    mockProductRepository = MockProductRepository();
    getAllProducts = GetAllProducts(mockProductRepository);
  });

  test('should get all products from the repository', () async {
    // arrange
    final tProduct = <Product>[];

    when(mockProductRepository.getProducts())
        .thenAnswer((_) async => Right(tProduct));

    // act
    final result = await getAllProducts(NoParams());

    // assert
    expect(result, Right(tProduct));
    verify(mockProductRepository.getProducts());
    verifyNoMoreInteractions(mockProductRepository);
  });
}
