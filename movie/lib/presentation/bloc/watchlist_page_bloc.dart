import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/usecases/get_watchlist_movies.dart';
import 'package:equatable/equatable.dart';

part 'watchlist_page_event.dart';
part 'watchlist_page_state.dart';

class MovieWatchlistPageBloc
    extends Bloc<FetchWatchlistMovies, WatchlistPageState> {
  final GetWatchlistMovies getWatchlistMovie;

  MovieWatchlistPageBloc(this.getWatchlistMovie)
      : super(WatchlistPageInitial());

  @override
  Stream<WatchlistPageState> mapEventToState(
    FetchWatchlistMovies event,
  ) async* {
    if (event is FetchWatchlistMovies) {
      yield WatchlistPageLoading();
      final result = await getWatchlistMovie.execute();
      yield* result.fold(
        (failure) async* {
          yield WatchlistPageError(failure.message);
        },
        (data) async* {
          yield WatchlistPageLoaded(data);
        },
      );
    }
  }
}
