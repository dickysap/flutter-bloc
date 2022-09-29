import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_popular_tv.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv.dart';
import 'package:ditonton/domain/usecases/get_tv_on_airing.dart';
import 'package:ditonton/presentation/provider/tv_list_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_list_notifier_test.mocks.dart';

@GenerateMocks([GetOnAiringTv, GetPopularTv, GetTopRatedTv])
void main() {
  late TvListNotifier tvListNotifier;
  late MockGetOnAiringTv mockGetOnAiringTv;
  late MockGetPopularTv mockGetPopularTv;
  late MockGetTopRatedTv mockGetTopRatedTv;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetOnAiringTv = MockGetOnAiringTv();
    mockGetPopularTv = MockGetPopularTv();
    mockGetTopRatedTv = MockGetTopRatedTv();
    tvListNotifier = TvListNotifier(
      getOnAiringTv: mockGetOnAiringTv,
      getPopularTv: mockGetPopularTv,
      getTopRatedTv: mockGetTopRatedTv,
    )..addListener(() {
        listenerCallCount += 1;
      });
  });

  final tMovie = Tv(
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

  final tMovieList = <Tv>[tMovie];

  group('now playing movies', () {
    test('initialState should be Empty', () {
      expect(tvListNotifier.onAiringState, equals(RequestState.Empty));
    });

    test('should get data from the usecase', () async {
      // arrange
      when(mockGetOnAiringTv.execute())
          .thenAnswer((_) async => Right(tMovieList));
      // act
      tvListNotifier.fetchOnAiringTv();
      // assert
      verify(mockGetOnAiringTv.execute());
    });

    test('should change state to Loading when usecase is called', () {
      // arrange
      when(mockGetOnAiringTv.execute())
          .thenAnswer((_) async => Right(tMovieList));
      // act
      tvListNotifier.fetchOnAiringTv();
      // assert
      expect(tvListNotifier.onAiringState, RequestState.Loading);
    });

    test('should change movies when data is gotten successfully', () async {
      // arrange
      when(mockGetOnAiringTv.execute())
          .thenAnswer((_) async => Right(tMovieList));
      // act
      await tvListNotifier.fetchOnAiringTv();
      // assert
      expect(tvListNotifier.onAiringState, RequestState.Loaded);
      expect(tvListNotifier.nowOnAiringTv, tMovieList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetOnAiringTv.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await tvListNotifier.fetchOnAiringTv();
      // assert
      expect(tvListNotifier.onAiringState, RequestState.Error);
      expect(tvListNotifier.mesage, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('popular movies', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(mockGetPopularTv.execute())
          .thenAnswer((_) async => Right(tMovieList));
      // act
      tvListNotifier.fetchOnPopularTv();
      // assert
      expect(tvListNotifier.poplarTvState, RequestState.Loading);
      // verify(tvListNotifier.setState(RequestState.Loading));
    });

    test('should change movies data when data is gotten successfully',
        () async {
      // arrange
      when(mockGetPopularTv.execute())
          .thenAnswer((_) async => Right(tMovieList));
      // act
      await tvListNotifier.fetchOnPopularTv();
      // assert
      expect(tvListNotifier.poplarTvState, RequestState.Loaded);
      expect(tvListNotifier.poplarTv, tMovieList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetPopularTv.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await tvListNotifier.fetchOnPopularTv();
      // assert
      expect(tvListNotifier.poplarTvState, RequestState.Error);
      expect(tvListNotifier.mesage, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('top rated movies', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(mockGetTopRatedTv.execute())
          .thenAnswer((_) async => Right(tMovieList));
      // act
      tvListNotifier.fetchTopRatedTv();
      // assert
      expect(tvListNotifier.topRatedTvState, RequestState.Loading);
    });

    test('should change movies data when data is gotten successfully',
        () async {
      // arrange
      when(mockGetTopRatedTv.execute())
          .thenAnswer((_) async => Right(tMovieList));
      // act
      await tvListNotifier.fetchTopRatedTv();
      // assert
      expect(tvListNotifier.topRatedTvState, RequestState.Loaded);
      expect(tvListNotifier.topRatedTv, tMovieList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetTopRatedTv.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await tvListNotifier.fetchTopRatedTv();
      // assert
      expect(tvListNotifier.topRatedTvState, RequestState.Error);
      expect(tvListNotifier.mesage, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
