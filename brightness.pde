//import processing.serial.*;

//Serial myPort; 





//void sensor_check() {
//  if (myPort.available() > 0) {
//    char inByte = '1';
//    StringBuffer outputBuffer = new StringBuffer(3);
//    while (inByte!='.') {
//      inByte = myPort.readChar();
//      if (inByte != '.')
//        outputBuffer.append(inByte);
//    }
//    myPort.readChar(); 
//    String op = outputBuffer.toString();
//    //println(op);

//    int b_factor = Integer.parseInt(op);

//    last_level = current_level;

//    if(b_factor >= 70 && b_factor < 100){
//        current_level = 3;
//        set_brightness(50);
//      }
//      else if(b_factor >= 100){
//        current_level = 4;
//        set_brightness(100);
//      }
//      else if(b_factor >= 20 && b_factor < 70){
//        current_level = 2;
//        set_brightness(30);
//      }
//      else if(b_factor <= 25){
//        current_level = 1;
//        set_brightness(10);
//      }
//   }
//}

void set_brightness() {
  loop_time = System.currentTimeMillis();
  if (loop_time >= (base_time + 5*1000)) {
    //println("brightness at: " + b_factor);
    String command = String.format("$brightness = %d;", b_factor)
      + "$delay = 5;"
      +"$WMIJob = Get-WmiObject -Namespace root\\wmi -Class WmiMonitorBrightnessMethods -AsJob;"   
      +"Wait-Job -ID $WMIJob.ID -Timeout 20;"
      +"$os = Receive-Job $WMIJob.ID;"
      + "$os.wmisetbrightness($delay, $brightness)";


    PowerShellResponse response = PowerShell.executeSingleCommand(command);
    //Print results
    //println("PowerShell :" + response.getCommandOutput());
    base_time = loop_time;
  }
}