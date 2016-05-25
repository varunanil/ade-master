import processing.sound.*;

SoundFile soundfile;

boolean GBM = false;
float gbmMT = 75;

void gbm(){
  if(currentMeditation > gbmMT){
    textSize(20);
    fill(204, 102, 0);
    text("Get Busy!", 440, 215);
    soundfile = new SoundFile(this, "airhorn.mp3");
    soundfile.play();
  }
}