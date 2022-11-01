import 'package:dartz/dartz.dart';
import '../../../core/lib/common/failure.dart';
import '../../../core/lib/common/state_enum.dart';
import '../../../core/lib/domain/entities/tv.dart';
import '../../../core/lib/domain/usecases/get_top_rated_tv.dart';
import '../../../tv/lib/presentation/provider/top_rated_tv_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'top_rated_tv_notifier_test.mocks.dart';

@GenerateMocks([GetTopRatedTv])
void main() {
  late MockGetTopRatedTv mockGetTopRatedTv;
  late TopRatedTvNotifier topRatedTvNotifier;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetTopRatedTv = MockGetTopRatedTv();
    topRatedTvNotifier = TopRatedTvNotifier(getTopRatedTv: mockGetTopRatedTv)
      ..addListener(() {
        listenerCallCount++;
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

  test('should change state to loading when usecase is called', () async {
    // arrange
    when(mockGetTopRatedTv.execute())
        .thenAnswer((_) async => Right(tMovieList));
    // act
    topRatedTvNotifier.fetchTopRatedTv();
    // assert
    expect(topRatedTvNotifier.state, RequestState.Loading);
    expect(listenerCallCount, 1);
  });

  test('should change movies data when data is gotten successfully', () async {
    // arrange
    when(mockGetTopRatedTv.execute())
        .thenAnswer((_) async => Right(tMovieList));
    // act
    await topRatedTvNotifier.fetchTopRatedTv();
    // assert
    expect(topRatedTvNotifier.state, RequestState.Loaded);
    expect(topRatedTvNotifier.topRatedTv, tMovieList);
    expect(listenerCallCount, 2);
  });

  test('should return error when data is unsuccessful', () async {
    // arrange
    when(mockGetTopRatedTv.execute())
        .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
    // act
    await topRatedTvNotifier.fetchTopRatedTv();
    // assert
    expect(topRatedTvNotifier.state, RequestState.Error);
    expect(topRatedTvNotifier.message, 'Server Failure');
    expect(listenerCallCount, 2);
  });
}
