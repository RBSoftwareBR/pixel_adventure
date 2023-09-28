enum PlayerState {
  doubleJump('Double Jump 32x32.png',6),
  fall('Fall 32x32.png',1),
  hit('Hit 32x32.png',7),
  idle('Idle 32x32.png',11),
  jump('Jump 32x32.png',1),
  running('Run 32x32.png',12),
  wallJump('Wall Jump 32x32.png',5);

  final int amount;
  final String animationName;
  const PlayerState(this.animationName,this.amount);
}

getAnimationPathFromAsset(final String asset, PlayerState state){
  List<String> pathAsList =  asset.split('/');
  return 'Main Characters/${pathAsList[pathAsList.length-2]}/${state.animationName}';
}
/*
Double Jump 32x32.png
Fall 32x32.png
Hit 32x32.png
Idle 32x32.png
Jump 32x32.png
Run 32x32.png
Wall Jump 32x32.png
*/
