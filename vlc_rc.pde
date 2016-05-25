  // Creates a client that sends input to a server
import processing.net.*; 

void autovolume() { 
  if(currentAttention < 60 && currentMeditation > 50){
    myClient = new Client(this, "localhost",32323);
    myClient.write("volup 1"); 
    myClient.stop();
    delay(200);
  }else if(currentAttention > 60 && currentMeditation < 60){
    myClient = new Client(this, "localhost",32323);
    myClient.write("voldown 1"); 
    myClient.stop();
    delay(100);
    
  }
} 