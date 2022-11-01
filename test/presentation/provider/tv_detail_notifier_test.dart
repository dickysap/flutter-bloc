import 'package:dartz/dartz.dart';
import '../../../core/lib/common/failure.dart';
import '../../../core/lib/common/state_enum.dart';
import '../../../core/lib/domain/entities/tv.dart';
import '../../../core/lib/domain/usecases/get_tv_detail.dart';
import '../../../core/lib/domain/usecases/get_tv_recomendations.dart';
import '../../../core/lib/domain/usecases/get_tv_watchlist_status.dart';
import '../../../core/lib/domain/usecases/remove_tv_watchlist.dart';
import '../../../core/lib/domain/usecases/save_tv_watchlist.dart';
import '../../../tv/lib/presentation/provider/tv_detail_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_detail_notifier_test.mocks.dart';

@GenerateMocks([
  GetTvDetail,
  GetTvRecommendations,
  GetTvWatchListStatus,
  SaveTvWatchlist,
  RemoveTvWatchlist,
])
void main() {
  late TvDetailNotifier tvDetailNotifier;
  late MockGetTvDetail mockGetTvDetail;

  late MockGetTvRecommendations mockGetTvRecommendations;
  late MockGetTvWatchListStatus mockGetTvWatchListStatus;
  late MockSaveTvWatchlist mockSaveTvWatchlist;
  late MockRemoveTvWatchlist mockRemoveTvWatchlist;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetTvDetail = MockGetTvDetail();
    mockGetTvRecommendations = MockGetTvRecommendations();
    mockGetTvWatchListStatus = MockGetTvWatchListStatus();
    mockSaveTvWatchlist = MockSaveTvWatchlist();
    mockRemoveTvWatchlist = MockRemoveTvWatchlist();
    tvDetailNotifier = TvDetailNotifier(
      getTvDetail: mockGetTvDetail,
      getTvRecommendations: mockGetTvRecommendations,
      getTvWatchListStatus: mockGetTvWatchListStatus,
      saveTvWatchlist: mockSaveTvWatchlist,
      removeTvWatchlist: mockRemoveTvWatchlist,
    )..addListener(() {
        listenerCallCount += 1;
      });
  });

  final tId = 1;

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
  final tMovies = <Tv>[tMovie];

  void _arrangeUsecase() {
    when(mockGetTvDetail.execute(tId))
        .thenAnswer((_) async => Right(testTvDetail));
    when(mockGetTvRecommendations.execute(tId))
        .thenAnswer((_) async => Right(tMovies));
  }

  group('Get Movie Detail', () {
    test('should get data from the usecase', () async {
      // arrange
      _arrangeUsecase();
      // act
      await tvDetailNotifier.fetchTvDetail(tId);
      // assert
      verify(mockGetTvDetail.execute(tId));
      verify(mockGetTvRecommendations.execute(tId));
    });

    test('should change state to Loading when usecase is called', () {
      // arrange
      _arrangeUsecase();
      // act
      tvDetailNotifier.fetchTvDetail(tId);
      // assert
      expect(tvDetailNotifier.tvDetailState, RequestState.Loading);
      expect(listenerCallCount, 1);
    });

    test('should change movie when data is gotten successfully', () async {
      // arrange
      _arrangeUsecase();
      // act
      await tvDetailNotifier.fetchTvDetail(tId);
      // assert
      expect(tvDetailNotifier.tvDetailState, RequestState.Loaded);
      expect(tvDetailNotifier.tv, testTvDetail);
      expect(listenerCallCount, 3);
    });

    test('should change recommendation movies when data is gotten successfully',
        () async {
      // arrange
      _arrangeUsecase();
      // act
      await tvDetailNotifier.fetchTvDetail(tId);
      // assert
      expect(tvDetailNotifier.tvDetailState, RequestState.Loaded);
      expect(tvDetailNotifier.tvRecommendation, tMovies);
    });
  });

  group('Get Movie Recommendations', () {
    test('should get data from the usecase', () async {
      // arrange
      _arrangeUsecase();
      // act
      await tvDetailNotifier.fetchTvDetail(tId);
      // assert
      verify(mockGetTvRecommendations.execute(tId));
      expect(tvDetailNotifier.tvRecommendation, tMovies);
    });

    test('should update recommendation state when data is gotten successfully',
        () async {
      // arrange
      _arrangeUsecase();
      // act
      await tvDetailNotifier.fetchTvDetail(tId);
      // assert
      expect(tvDetailNotifier.tvRecommendationState, RequestState.Loaded);
      expect(tvDetailNotifier.tvRecommendation, tMovies);
    });

    test('should update error message when request in successful', () async {
      // arrange
      when(mockGetTvDetail.execute(tId))
          .thenAnswer((_) async => Right(testTvDetail));
      when(mockGetTvRecommendations.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Failed')));
      // act
      await tvDetailNotifier.fetchTvDetail(tId);
      // assert
      expect(tvDetailNotifier.tvRecommendationState, RequestState.Error);
      expect(tvDetailNotifier.message, 'Failed');
    });
  });

  group('Watchlist', () {
    test('should get the watchlist status', () async {
      // arrange
      when(mockGetTvWatchListStatus.execute(1)).thenAnswer((_) async => true);
      // act
      await tvDetailNotifier.loadWatchlistStatusTv(1);
      // assert
      expect(tvDetailNotifier.isTvAddedToWatchlist, true);
    });

    test('should execute save watchlist when function called', () async {
      // arrange
      when(mockSaveTvWatchlist.execute(testTvDetail))
          .thenAnswer((_) async => Right('Success'));
      when(mockGetTvWatchListStatus.execute(testTvDetail.id))
          .thenAnswer((_) async => true);
      // act
      await tvDetailNotifier.addWatchlist(testTvDetail);
      // assert
      verify(mockSaveTvWatchlist.execute(testTvDetail));
    });

    test('should execute remove watchlist when function called', () async {
      // arrange
      when(mockRemoveTvWatchlist.execute(testTvDetail))
          .thenAnswer((_) async => Right('Removed'));
      when(mockGetTvWatchListStatus.execute(testTvDetail.id))
          .thenAnswer((_) async => false);
      // act
      await tvDetailNotifier.removeFromWatchlistTv(testTvDetail);
      // assert
      verify(mockRemoveTvWatchlist.execute(testTvDetail));
    });

    test('should update watchlist status when add watchlist success', () async {
      // arrange
      when(mockSaveTvWatchlist.execute(testTvDetail))
          .thenAnswer((_) async => Right('Added to Watchlist'));
      when(mockGetTvWatchListStatus.execute(testTvDetail.id))
          .thenAnswer((_) async => true);
      // act
      await tvDetailNotifier.addWatchlist(testTvDetail);
      // assert
      verify(mockGetTvWatchListStatus.execute(testTvDetail.id));
      expect(tvDetailNotifier.isTvAddedToWatchlist, true);
      expect(tvDetailNotifier.watchlistMessageTv, 'Added to Watchlist');
      expect(listenerCallCount, 1);
    });

    test('should update watchlist message when add watchlist failed', () async {
      // arrange
      when(mockSaveTvWatchlist.execute(testTvDetail))
          .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
      when(mockGetTvWatchListStatus.execute(testTvDetail.id))
          .thenAnswer((_) async => false);
      // act
      await tvDetailNotifier.addWatchlist(testTvDetail);
      // assert
      expect(tvDetailNotifier.watchlistMessageTv, 'Failed');
      expect(listenerCallCount, 1);
    });
  });

  group('on Error', () {
    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetTvDetail.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      when(mockGetTvRecommendations.execute(tId))
          .thenAnswer((_) async => Right(tMovies));
      // act
      await tvDetailNotifier.fetchTvDetail(tId);
      // assert
      expect(tvDetailNotifier.tvDetailState, RequestState.Error);
      expect(tvDetailNotifier.message, 'Server Failure');
      expect(listenerCallCount, 1);
    });
  });
}
