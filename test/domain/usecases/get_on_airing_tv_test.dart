import 'package:dartz/dartz.dart';
import '../../../core/lib/domain/entities/tv.dart';
import '../../../core/lib/domain/usecases/get_tv_on_airing.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetOnAiringTv usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = GetOnAiringTv(mockTvRepository);
  });

  final tTv = <Tv>[];

  test('should get list of movies from the repository', () async {
    // arrange
    when(mockTvRepository.getOnAirTv()).thenAnswer((_) async => Right(tTv));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(tTv));
  });
}
