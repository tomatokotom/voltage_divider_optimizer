
// Vout = Vin*R1/(R1+R2)


float resMin=140000;
float resMax=240000;
float Vin = 3.3;

//int dacRes= 1024; 
int dacRes= 1;
int resInBits= 9;


int targetValueMin=0;
int targetValueMax=127;

int resistancesByDecades=96;
int numberOfDecades=7;
int decadeIndex=1;

float [] resistorArray;

float vMin, vMax;
float actualResistor;
float voltageDividerRange;

void setup() {

  for (int i = 0; i<=resInBits; i++) {

    dacRes=dacRes*2;
  }


  resistorArray = new float[resistancesByDecades*(numberOfDecades+1)];

  for (int i=0; i<resistancesByDecades*numberOfDecades; i++) {
    if (i>resistancesByDecades*decadeIndex)decadeIndex+=1;

    vMin=Vin*(resMin/(resMin+E96[i%resistancesByDecades]*pow(10, decadeIndex-1)));
    vMax=Vin*(resMax/(resMax+E96[i%resistancesByDecades]*pow(10, decadeIndex-1)));

    resistorArray[i]=vMax-vMin;
  }



  float maxValue=0; //or int, if it's an array of ints

  int position=-1;

  for (int i=0; i<resistorArray.length; i++) 
  {
    if (resistorArray[i]>maxValue) 
    {
      position=i; 
      maxValue=resistorArray[i];
    }
  }
  if (position==-1)
  {
    println("Oops, all values are less than 0");
  } else
  {
    voltageDividerRange= maxValue/Vin;

    float voltageMin=Vin*(resMin/(resMin+E96[position%resistancesByDecades]*pow(10, int(position/resistancesByDecades))));
    float voltageMax=Vin*(resMax/(resMax+E96[position%resistancesByDecades]*pow(10, int(position/resistancesByDecades))));

    print("voltage Minimum: "+voltageMin+" V");
    print("    -    ");
    println("voltage Maximum: "+voltageMax+" V"); 
    print("interval max: "+maxValue+" V");
    print("    -    ");
    //    print("position: "+position);
    //    print("    -    ");
    println("valeur resistance: "+ int(E96[position%resistancesByDecades]*pow(10, int(position/resistancesByDecades)))+" ohms");
    println("Range: "+voltageDividerRange*100+" %" +"    -    nombre de pas : "+ (int(voltageDividerRange*dacRes)));
    println("Plus petit pas: "+ (int(voltageMax*dacRes)/100));
    int vl=int(voltageMax*dacRes/100)+(int(voltageDividerRange*dacRes));
    println();
    println("formule:");
    println("map(monCapteur,"+int(voltageMax*dacRes)/100+","+vl +","+targetValueMin+","+targetValueMax+");");
  }
  exit();
}