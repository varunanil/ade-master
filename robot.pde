import java.awt.*;

Robot keybot;

float autokeyAT = 75.0;
boolean autokey = false;

void keybot_init() {
  try { //try and create a new robot named keybot
    keybot = new Robot();
  }
  catch(AWTException e) { //If there is an error, print it out to the console
    e.printStackTrace();
  }
}

void keybot(float n) {    
  if (currentAttention > autokeyAT) { 
    if (n == 0)
      keybot.keyPress(java.awt.event.KeyEvent.VK_Q);
    else if (n == 1)
      keybot.keyPress(java.awt.event.KeyEvent.VK_W);
    else if (n == 2)
      keybot.keyPress(java.awt.event.KeyEvent.VK_A);
    else if (n == 3)
      keybot.keyPress(java.awt.event.KeyEvent.VK_S);
    else if (n == 4)
      keybot.keyPress(java.awt.event.KeyEvent.VK_D);
    else if (n == 5)
      keybot.keyPress(java.awt.event.KeyEvent.VK_Z);
    else if (n == 6)
      keybot.keyPress(java.awt.event.KeyEvent.VK_X);
    else if (n == 7)
      keybot.keyPress(java.awt.event.KeyEvent.VK_C);
  } else {
    if (n == 0)
      keybot.keyRelease(java.awt.event.KeyEvent.VK_Q);
    else if (n == 1)
      keybot.keyRelease(java.awt.event.KeyEvent.VK_W);
    else if (n == 2)
      keybot.keyRelease(java.awt.event.KeyEvent.VK_A);
    else if (n == 3)
      keybot.keyRelease(java.awt.event.KeyEvent.VK_S);
    else if (n == 4)
      keybot.keyRelease(java.awt.event.KeyEvent.VK_D);
    else if (n == 5)
      keybot.keyRelease(java.awt.event.KeyEvent.VK_Z);
    else if (n == 6)
      keybot.keyRelease(java.awt.event.KeyEvent.VK_X);
    else if (n == 7)
      keybot.keyRelease(java.awt.event.KeyEvent.VK_C);
  }
}