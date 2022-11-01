import 'package:dartz/dartz.dart';
import '../../common/failure.dart';
import '../entities/tv.dart';
import '../repositories/tv_repository.dart';

class GetOnAiringTv {
  final TvRepository repository;

  GetOnAiringTv(this.repository);

  Future<Either<Failure, List<Tv>>> execute() {
    return repository.getOnAirTv();
  }
}
