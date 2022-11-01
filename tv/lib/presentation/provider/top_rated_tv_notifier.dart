import 'package:core/common/state_enum.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/usecases/get_top_rated_tv.dart';
import 'package:flutter/cupertino.dart';

class TopRatedTvNotifier extends ChangeNotifier {
  final GetTopRatedTv getTopRatedTv;

  TopRatedTvNotifier({required this.getTopRatedTv});

  RequestState _state = RequestState.Empty;
  RequestState get state => _state;

  List<Tv> _topRatedTv = [];
  List<Tv> get topRatedTv => _topRatedTv;

  String _message = '';
  String get message => _message;

  Future<void> fetchTopRatedTv() async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await getTopRatedTv.execute();

    result.fold(
      (failure) {
        _message = failure.message;
        _state = RequestState.Error;
        notifyListeners();
      },
      (tvData) {
        _topRatedTv = tvData;
        _state = RequestState.Loaded;
        notifyListeners();
      },
    );
  }
}
