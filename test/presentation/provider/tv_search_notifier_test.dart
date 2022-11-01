import 'package:dartz/dartz.dart';
import '../../../core/lib/common/failure.dart';
import '../../../core/lib/common/state_enum.dart';
import '../../../core/lib/domain/entities/tv.dart';
import '../../../core/lib/domain/usecases/search_tv.dart';
import '../../../tv/lib/presentation/provider/tv_search_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_search_notifier_test.mocks.dart';

@GenerateMocks([SearchTv])
void main() {
  late TvSearchNotiefier tvSearchNotiefier;
  late MockSearchTv mockSearchTv;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockSearchTv = MockSearchTv();
    tvSearchNotiefier = TvSearchNotiefier(searchTv: mockSearchTv)
      ..addListener(() {
        listenerCallCount += 1;
      });
  });

  final tMovieModel = Tv(
    name: 'name',
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    firstAirDate: 'first_air_date',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    originalName: 'original_name',
    voteAverage: 1,
    voteCount: 1,
  );

  final tMovieList = <Tv>[tMovieModel];
  final tQuery = 'House of the Dragon';

  group('search movies', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(mockSearchTv.execute(tQuery))
          .thenAnswer((_) async => Right(tMovieList));
      // act
      tvSearchNotiefier.fetchSearchTv(tQuery);
      // assert
      expect(tvSearchNotiefier.state, RequestState.Loading);
    });

    test('should change search result data when data is gotten successfully',
        () async {
      // arrange
      when(mockSearchTv.execute(tQuery))
          .thenAnswer((_) async => Right(tMovieList));
      // act
      await tvSearchNotiefier.fetchSearchTv(tQuery);
      // assert
      expect(tvSearchNotiefier.state, RequestState.Loaded);
      expect(tvSearchNotiefier.searchResult, tMovieList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockSearchTv.execute(tQuery))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await tvSearchNotiefier.fetchSearchTv(tQuery);
      // assert
      expect(tvSearchNotiefier.state, RequestState.Error);
      expect(tvSearchNotiefier.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
