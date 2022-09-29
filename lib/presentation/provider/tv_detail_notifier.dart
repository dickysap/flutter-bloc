import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_recomendations.dart';
import 'package:ditonton/domain/usecases/get_tv_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_tv_watchlist.dart';
import 'package:ditonton/domain/usecases/save_tv_watchlist.dart';
import 'package:flutter/cupertino.dart';

class TvDetailNotifier extends ChangeNotifier {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Remove from Watchlist';

  final GetTvDetail getTvDetail;
  final GetTvRecommendations getTvRecommendations;
  final GetTvWatchListStatus getTvWatchListStatus;
  final SaveTvWatchlist saveTvWatchlist;
  final RemoveTvWatchlist removeTvWatchlist;

  TvDetailNotifier(
      {required this.getTvDetail,
      required this.getTvRecommendations,
      required this.getTvWatchListStatus,
      required this.removeTvWatchlist,
      required this.saveTvWatchlist});

  late TvDetail _tv;
  TvDetail get tv => _tv;

  RequestState _tvDetailState = RequestState.Empty;
  RequestState get tvDetailState => _tvDetailState;

  List<Tv> _tvRecommendation = [];
  List<Tv> get tvRecommendation => _tvRecommendation;

  RequestState _tvRecommendationState = RequestState.Empty;
  RequestState get tvRecommendationState => _tvRecommendationState;

  String _message = '';
  String get message => _message;

  bool _isTvAddedtoWatchlist = false;
  bool get isTvAddedToWatchlist => _isTvAddedtoWatchlist;

  Future<void> fetchTvDetail(int id) async {
    _tvDetailState = RequestState.Loading;
    notifyListeners();

    final detailTvResult = await getTvDetail.execute(id);
    final tvRecommendationResult = await getTvRecommendations.execute(id);

    detailTvResult.fold((failure) {
      _tvDetailState = RequestState.Error;
      _message = failure.message;
    }, (tv) {
      _tvRecommendationState = RequestState.Loading;
      _tv = tv;
      notifyListeners();
      tvRecommendationResult.fold((failure) {
        _tvRecommendationState = RequestState.Error;
        _message = failure.message;
      }, (tv) {
        _tvRecommendationState = RequestState.Loaded;
        _tvRecommendation = tv;
      });
      _tvDetailState = RequestState.Loaded;
      notifyListeners();
    });
  }

  String _watchlistMessageTv = '';
  String get watchlistMessageTv => _watchlistMessageTv;

  Future<void> addWatchlist(TvDetail tvShow) async {
    final result = await saveTvWatchlist.execute(tvShow);

    await result.fold(
      (failure) async {
        _watchlistMessageTv = failure.message;
      },
      (successMessage) async {
        _watchlistMessageTv = successMessage;
      },
    );

    await loadWatchlistStatusTv(tvShow.id);
  }

  Future<void> removeFromWatchlistTv(TvDetail tvShow) async {
    final result = await removeTvWatchlist.execute(tvShow);

    await result.fold(
      (failure) async {
        _watchlistMessageTv = failure.message;
      },
      (successMessage) async {
        _watchlistMessageTv = successMessage;
      },
    );

    await loadWatchlistStatusTv(tvShow.id);
  }

  Future<void> loadWatchlistStatusTv(int id) async {
    final result = await getTvWatchListStatus.execute(id);
    _isTvAddedtoWatchlist = result;
    notifyListeners();
  }
}
