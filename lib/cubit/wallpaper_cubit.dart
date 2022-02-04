import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'wallpaper_state.dart';

class WallpaperCubit extends Cubit<WallpaperState> {
  WallpaperCubit() : super(WallpaperInitial());
}
