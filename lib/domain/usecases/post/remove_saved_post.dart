import 'package:dartz/dartz.dart';

import '../../error/failures.dart';
import '../../models/post.dart';
import '../../repository/post_repository.dart';
import '../usecase.dart';

class RemoveSavedPost implements UseCase<bool, Post> {
  RemoveSavedPost(this.postRepository);

  final PostRepository postRepository;

  @override
  Future<Either<Failure, bool>> call(Post post) async {
    try {
      await postRepository.removePost(post);
      return const Right(true);
    } catch (error) {
      return Left(Failure.fromException(error));
    }
  }
}
