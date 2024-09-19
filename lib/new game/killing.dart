
import 'package:play_pointz/new%20game/men.dart';

class Killed {
  bool isKilled;
  Men men;

  Killed({this.isKilled = false, this.men});

  Killed.none(){
    isKilled = false;
  }
}