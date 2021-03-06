////////////////////////////////////////////////////////
//            Momods_Night_Scalper_V2.1_Pro           //
//     Coded by Momods @ worldwide-invest.org         //
//                  March 31, 2013                    //
////////////////////////////////////////////////////////
//        If you make money from this EA              //
//  please make donnation to my paypal Account        //
//              mohddisi@yahoo.com                    //
////////////////////////////////////////////////////////

//V1.3 (March 17, 2013) - Added second condition for Fractals signal
//                      - Added MA Slope filter
//                      - Added settings internally
//
//V1.4 (March 23, 2013) - Fixed a bug in displaying Open/Close hours
//                      - No need to add pair suffix
//                      - Added code to generate master magic number for all pairs based on account number
//                      - Faster back tests
//                      - hide EA name in comments from broker (enter your own)
//                      - Option to hide SL/TP from broker.  Highly dangerous if you are not using VPS.
//                      - Now you can see total profit (loss) for each pair on the display
//                      - Revised settings for several pairs based on optimization
//
//V2.0 (March 31, 2013) - Fixed a bug in calculating trading times for friday
//                      - Added BB to be used either as Signal or filter.
//                      - Added trade spacing time filter (When a trade closes in loss, EA will wait x minutes before opening a same type trade).
//V2.1 (March 31, 2013) - Fixed a bug in calculating trade pause


extern string  EA_Name= "Momods_Night_Scalper_v2.1_Pro";
extern string  C_1="Please Enter your own EA Comment below"; 
extern string  EA_Comment="";     
extern string  S_1="If MAGIC=0, a unique value will be generated by EA";      
extern int     MAGIC = 0;
extern bool    New_Trade=True;
extern string S0="----------------------";
extern double  lot           = 0;
extern double  Risk          = 7.5;
extern bool    Hide_SL_TP    = False;
extern double  TakeProfit    = 60;
extern double  StopLoss      = 40;
extern int     Slippage      = 3;
extern double  Max_Spread    = 6.0;
extern string S1="----------------------";
extern int    GMT_Offset     = 0;
extern int    Open_Hour      = 20;
extern int    Close_Hour     = 23;
extern bool   TradeOnFriday  = False;
extern int    Friday_Hour    =15;
extern string S2="----------------------";
extern bool   Use_Trade_Spacing = false;
extern int    Trade_Spacing_Min = 60;
extern string S3="----------------------";
extern bool    Allow_Second_Trade=false;
extern double  Distance      = 12;
extern double  Lot_Factor    = 0.5;
extern string S4="----------------------";
extern bool   Use_CCI        = False;
extern int    CCI_Period     = 10;
extern double CCI_Entry      = 200;
extern double CCI_Exit       = 140;
extern string S5="----------------------";
extern bool   Use_WPR        = true;
extern int    WPR_Period     = 10;
extern double WPR_Entry      = 91;
extern double WPR_Exit       = 40;
extern string S6="----------------------";
extern bool   Use_Fractals   = true;
extern double MidFractalDist = 5;
extern double OppositFractalDist=10;
extern string S7="----------------------";
extern bool   Use_MA1         = False;
extern int    MA_Period1      = 75;
extern bool   Use_MA2         = False;
extern int    MA_Period2      = 19;
extern bool   Use_MA2_Slope   = False;
extern double MA_Slope       = 1;
extern string S8="----------------------";
extern bool   Use_BB         = False;
extern int    BB_Period      = 10;
extern int    BB_Dev         = 2;
extern int    BB_Range       = 12;
extern int    BB_Penetration = 2;
extern bool   Use_BB_Direction=False;

string S9="---------Global Variables---------------";

bool Trade;
datetime Last_Time;
double Lot;
double LastUpFractal,LastDownFractal;
double midFractal;
int SpreadSampleSize = 10;  
double Spread[0];
string Session="";
int Magic;
int CCI_Buy_Sig;
int CCI_Sell_Sig;
int WPR_Buy_Sig;
int WPR_Sell_Sig;
int MA_Buy_Sig1;
int MA_Sell_Sig1;
int MA_Buy_Sig2;
int MA_Sell_Sig2;
int Fractals_Buy_Sig;
int Fractals_Sell_Sig;  
int CCI_Exit_Buy_Sig;
int CCI_Exit_Sell_Sig;
int WPR_Exit_Buy_Sig;
int WPR_Exit_Sell_Sig; 
int MA_Slope_Buy_Sig;               
int MA_Slope_Sell_Sig;
int BB_Buy_Sig;               
int BB_Sell_Sig;
int Trade_Spacing_Buy_Sig;
int Trade_Spacing_Sell_Sig;
 
double CCI_1,WPR_1, MA_1_1, MA_1_2,MA_2_1,MA_2_2,BB_U_1,BB_U_2,BB_U_3,BB_L_1,BB_L_2,BB_L_3 ;            


int init() {


 if (MAGIC==0) MAGIC=MathFloor(AccountNumber()/49432)*100;
 if (MAGIC>0) MAGIC=MAGIC*100;
 if (StringSubstr(Symbol(),0,6)=="EURCAD")  {Magic=MAGIC+1;}

 if (StringSubstr(Symbol(),0,6)=="EURGBP")  {Magic=MAGIC+2;}
 
 if (StringSubstr(Symbol(),0,6)=="USDCAD")  {Magic=MAGIC+3;}
 
 if (StringSubstr(Symbol(),0,6)=="EURCHF")  {Magic=MAGIC+4;}
 
 if (StringSubstr(Symbol(),0,6)=="USDCHF")  {Magic=MAGIC+5;}
 
 if (StringSubstr(Symbol(),0,6)=="GBPCHF")  {Magic=MAGIC+6;}
 
 if (StringSubstr(Symbol(),0,6)=="GBPCAD")  {Magic=MAGIC+7;}
 
 if (StringSubstr(Symbol(),0,6)=="EURUSD")  {Magic=MAGIC+8;}
 
 if (StringSubstr(Symbol(),0,6)=="CADJPY") Magic=MAGIC+9;
 
 if (StringSubstr(Symbol(),0,6)=="GBPJPY") Magic=MAGIC+10; 
 
 if (StringSubstr(Symbol(),0,6)=="CADCHF") {Magic=MAGIC+11;}
 
 if (StringSubstr(Symbol(),0,6)=="GBPUSD") {Magic=MAGIC+12;}
 
 
 if (StringSubstr(Symbol(),0,6)=="USDJPY") {Magic=MAGIC+13;}
 
 if (StringSubstr(Symbol(),0,6)=="AUDUSD") {Magic=MAGIC+14;}
 
 if (StringSubstr(Symbol(),0,6)=="AUDCAD") Magic=MAGIC+15; 
 
 if (StringSubstr(Symbol(),0,6)=="AUDJPY") Magic=MAGIC+16;
 
 if (StringSubstr(Symbol(),0,6)=="EURAUD") Magic=MAGIC+17;
 
 if (StringSubstr(Symbol(),0,6)=="GBPAUD") Magic=MAGIC+18;
 
 if (StringSubstr(Symbol(),0,6)=="EURNZD") Magic=MAGIC+19; 
 
 if (StringSubstr(Symbol(),0,6)=="GBPNZD") Magic=MAGIC+20;
 
 if (StringSubstr(Symbol(),0,6)=="EURNOK") Magic=MAGIC+21; 
 
 if (StringSubstr(Symbol(),0,6)=="EURSEK") Magic=MAGIC+22;
 
 if (StringSubstr(Symbol(),0,6)=="NZDUSD") Magic=MAGIC+23; 
 
 if (StringSubstr(Symbol(),0,6)=="NZDJPY") Magic=MAGIC+24;
 
 if (StringSubstr(Symbol(),0,6)=="EURJPY") Magic=MAGIC+25; 
 
 if (StringSubstr(Symbol(),0,6)=="AUDCHF") Magic=MAGIC+26; 
 
 if (StringSubstr(Symbol(),0,6)=="NZDCHF") Magic=MAGIC+27;
 
 if (StringSubstr(Symbol(),0,6)=="AUDNZD") Magic=MAGIC+28; 
 
 if (StringSubstr(Symbol(),0,6)=="CHFJPY") Magic=MAGIC+29;
  
 if (StringSubstr(Symbol(),0,6)=="NZDCAD") Magic=MAGIC+30; 
 
 if (StringSubstr(Symbol(),0,6)=="USDDKK") Magic=MAGIC+31;  
  
 if (StringSubstr(Symbol(),0,6)=="USDNOK") Magic=MAGIC+32; 
 
 if (StringSubstr(Symbol(),0,6)=="USDSEK") Magic=MAGIC+33;
  
  
 Open_Hour=Open_Hour+GMT_Offset;
 Close_Hour=Close_Hour+GMT_Offset;
 Friday_Hour=Friday_Hour+GMT_Offset;
 if (Open_Hour>=24)Open_Hour=Open_Hour-24;
 if (Close_Hour>=24)Close_Hour=Close_Hour-24;
     
  
   return (0);
}


int deinit() {
   return (0);
}

// EA Start 

int start() {


//////////////////////////////////// Trade Timing ///////////////////////////////////////////////     
   
   
   Trade = true;
   if (!TradeOnFriday && TimeDayOfWeek(TimeCurrent()-GMT_Offset*3600) == 5) Trade = FALSE;
   if (TradeOnFriday && DayOfWeek() == 5 && TimeHour(TimeCurrent()) > (Friday_Hour)) Trade = FALSE;   
   if (Open_Hour>=24)Open_Hour=Open_Hour-24;
   if (Close_Hour>=24)Close_Hour=Close_Hour-24;   
       
   if (Open_Hour < Close_Hour && (TimeHour(TimeCurrent())<Open_Hour || TimeHour(TimeCurrent())>=Close_Hour)) Trade = FALSE;
   if (Open_Hour > Close_Hour && TimeHour(TimeCurrent())<Open_Hour && TimeHour(TimeCurrent())>= Close_Hour) Trade = FALSE; 
   if (Month()==12 && Day()>22)  Trade = FALSE; 
   if (Month()==1 && Day()<5)  Trade = FALSE; 
   
   if (Trade && MyRealOrdersTotal(Magic)==0 && !Allow_Second_Trade && Spread()<Max_Spread*PointValue() && (Ask-Bid)<Max_Spread*PointValue()) Session="Trade Session Open .. Waiting for trades";
   if (Trade && MyRealOrdersTotal(Magic)==0 && (Spread()>Max_Spread*PointValue()|| (Ask-Bid)>Max_Spread*PointValue())) Session="Trade Session Open .. Spread is High .. Trading Halted";
   if (Trade && MyRealOrdersTotal(Magic)>0 && (Spread()>Max_Spread*PointValue()|| (Ask-Bid)>Max_Spread*PointValue())) Session="Trade Session Open..Waiting to exit trades..Trading Halted"; 
   if (!Trade && MyRealOrdersTotal(Magic)==0) Session="Trade Session Closed";
   if (!Trade && MyRealOrdersTotal(Magic)>0) Session="Trade Session Closed .. Waiting to exit trades"; 
   
////////////////////////////  Add Disply /////////////////////////////

   if (!IsTesting() && !IsOptimization()) Display();
   
////////////////////   Calculate Average Spread  /////////////////////
 
    if (!IsTesting() && !IsOptimization()) Spread(Ask-Bid);
    
/////////////////////////////  Indicator(s) /////////////////////////
     
  if (Trade || OrdersTotal()>0)
  {
     if (Use_CCI) CCI_1 = iCCI(NULL, 0, CCI_Period, PRICE_CLOSE, 0);    
     if (Use_WPR) WPR_1 = iWPR(NULL, 0, WPR_Period, 0);
     if (Use_MA1) MA_1_1  = iMA(NULL,0,MA_Period1,0,MODE_SMMA,PRICE_CLOSE,1);
     if (Use_MA1) MA_1_2  = iMA(NULL,0,MA_Period1,0,MODE_SMMA,PRICE_CLOSE,2);     
     if (Use_MA2 || Use_MA2_Slope) MA_2_1  = iMA(NULL,0,MA_Period2,0,MODE_SMMA,PRICE_CLOSE,1);
     if (Use_MA2 || Use_MA2_Slope) MA_2_2  = iMA(NULL,0,MA_Period2,0,MODE_SMMA,PRICE_CLOSE,2);
     if (Use_BB) BB_L_1  = iBands(NULL,0,BB_Period,BB_Dev,0,PRICE_CLOSE,MODE_LOWER,0);
     if (Use_BB) BB_L_2  = iBands(NULL,0,BB_Period,BB_Dev,0,PRICE_CLOSE,MODE_LOWER,1); 
     if (Use_BB) BB_L_3  = iBands(NULL,0,BB_Period,BB_Dev,0,PRICE_CLOSE,MODE_LOWER,2);          
     if (Use_BB) BB_U_1  = iBands(NULL,0,BB_Period,BB_Dev,0,PRICE_CLOSE,MODE_UPPER,0);          
     if (Use_BB) BB_U_2  = iBands(NULL,0,BB_Period,BB_Dev,0,PRICE_CLOSE,MODE_UPPER,1);
     if (Use_BB) BB_U_3  = iBands(NULL,0,BB_Period,BB_Dev,0,PRICE_CLOSE,MODE_UPPER,2);           

     if (Use_Fractals)
     {    
        for(int a=1;a<Bars;a++){
         if(iFractals(NULL, 0, MODE_UPPER,a)!=0){
            LastUpFractal=iFractals(NULL, 0, MODE_UPPER,a);
            break;
            }
         }
        for(int s=1;s<Bars;s++){
         if(iFractals(NULL, 0, MODE_LOWER,s)!=0){
            LastDownFractal=iFractals(NULL, 0, MODE_LOWER,s);
            break;
            }
         }

        midFractal=(LastUpFractal+LastDownFractal)/2; 
     }
  }   
     

//////////////////////////////////// Trade Signals ///////////////////////////////////////////////      

   CCI_Buy_Sig=0;
   CCI_Sell_Sig=0;  
   WPR_Buy_Sig=0;
   WPR_Sell_Sig=0;
   MA_Buy_Sig1=0;
   MA_Sell_Sig1=0;
   MA_Buy_Sig2=0;
   MA_Sell_Sig2=0;   
   MA_Slope_Buy_Sig=0;
   MA_Slope_Sell_Sig=0;   
   Fractals_Buy_Sig=0;
   Fractals_Sell_Sig=0;
   BB_Buy_Sig=0;
   BB_Sell_Sig=0;
   Trade_Spacing_Buy_Sig=1;
   Trade_Spacing_Sell_Sig=1;      
   
   if (!Use_CCI) {CCI_Buy_Sig=1;CCI_Sell_Sig=1;}
      
   if (!Use_WPR) {WPR_Buy_Sig=1;WPR_Sell_Sig=1;}  
    
   if (!Use_MA1) {MA_Buy_Sig1=1; MA_Sell_Sig1=1;} 
   
   if (!Use_MA2) {MA_Buy_Sig2=1; MA_Sell_Sig2=1;}    
   
   if (!Use_MA2_Slope) {MA_Slope_Buy_Sig=1; MA_Slope_Sell_Sig=1;}    
   
   if (!Use_Fractals) {Fractals_Buy_Sig=1; Fractals_Sell_Sig=1;}
   
   if (!Use_BB) {BB_Buy_Sig=1; BB_Sell_Sig=1;}
   
 
   if (Use_CCI && CCI_1<-CCI_Entry) CCI_Buy_Sig=1;
   if (Use_CCI && CCI_1>CCI_Entry) CCI_Sell_Sig=1;     
   if (Use_WPR && WPR_1<-WPR_Entry) WPR_Buy_Sig=1;  
   if (Use_WPR && WPR_1>-(100-WPR_Entry)) WPR_Sell_Sig=1;    
   if (Use_MA1 && MA_1_1>MA_1_2)  MA_Buy_Sig1=1;   
   if (Use_MA1 && MA_1_1<MA_1_2)  MA_Sell_Sig1=1;
   if (Use_MA2 && MA_2_1>MA_2_2)  MA_Buy_Sig2=1;   
   if (Use_MA2 && MA_2_1<MA_2_2)  MA_Sell_Sig2=1;    
   if (Use_MA2_Slope && (MA_2_1-MA_2_2)>=MA_Slope*PointValue())  MA_Slope_Buy_Sig=1;   
   if (Use_MA2_Slope && (MA_2_2-MA_2_1)>=MA_Slope*PointValue())  MA_Slope_Sell_Sig=1;          
   if (Use_Fractals && Ask<(midFractal-MidFractalDist*PointValue()) && Ask<(LastUpFractal-OppositFractalDist*PointValue())) Fractals_Buy_Sig=1;    
   if (Use_Fractals && Bid>(midFractal+MidFractalDist*PointValue()) && Bid>(LastDownFractal+OppositFractalDist*PointValue())) Fractals_Sell_Sig=1;
   if (Use_BB && !Use_BB_Direction && Ask<BB_L_1 && (BB_U_1-BB_L_1)>BB_Range*PointValue() && BB_L_1-Ask>=BB_Penetration*PointValue()) BB_Buy_Sig=1;
   if (Use_BB && !Use_BB_Direction && Bid>BB_U_1 && (BB_U_1-BB_L_1)>BB_Range*PointValue() && Bid-BB_U_1>=BB_Penetration*PointValue()) BB_Sell_Sig=1;      
   if (Use_BB && Use_BB_Direction && Ask<BB_L_1 && (BB_U_1-BB_L_1)>BB_Range*PointValue() && BB_L_1-Ask>=BB_Penetration*PointValue() && BB_L_1>BB_L_2) BB_Buy_Sig=1;
   if (Use_BB && Use_BB_Direction && Bid>BB_U_1 && (BB_U_1-BB_L_1)>BB_Range*PointValue() && Bid-BB_U_1>=BB_Penetration*PointValue() && BB_U_1<BB_U_2) BB_Sell_Sig=1;   
   if (Use_Trade_Spacing && LastClosedType(Magic)==0 && LastClosedProfit(Magic)<0 && (Time[0]-LastClosedTime(Magic))<Trade_Spacing_Min*60) Trade_Spacing_Buy_Sig=0; 
   if (Use_Trade_Spacing && LastClosedType(Magic)==1 && LastClosedProfit(Magic)<0 && (Time[0]-LastClosedTime(Magic))<Trade_Spacing_Min*60) Trade_Spacing_Sell_Sig=0;     
   
   
   if (!Use_CCI  && !Use_WPR && !Use_Fractals) {Print("You must use at least one signal (CCI, WPR, or Fractals"); return(0);} 
   
//////////////////////////////////// Exit Signals ///////////////////////////////////////////////      

   CCI_Exit_Buy_Sig=0;
   CCI_Exit_Sell_Sig=0;   
   WPR_Exit_Buy_Sig=0;
   WPR_Exit_Sell_Sig=0;      
   
   if (Use_CCI && CCI_1>CCI_Exit) CCI_Exit_Buy_Sig=1;
   if (Use_CCI && CCI_1<-CCI_Exit) CCI_Exit_Sell_Sig=1;      
   if (Use_WPR && WPR_1>-WPR_Exit) WPR_Exit_Buy_Sig=1;  
   if (Use_WPR && WPR_1<(-100+WPR_Exit)) WPR_Exit_Sell_Sig=1;    

               
//////////////////////////////////// Close Trades ///////////////////////////////////////////////      

  if (OrdersTotal()>0)
  {
    for(int k=0; k<OrdersTotal(); k++)     
    {      
       OrderSelect(k, SELECT_BY_POS, MODE_TRADES);      
       if(OrderType()==OP_BUY &&   OrderSymbol()==Symbol() && OrderMagicNumber()==Magic && (CCI_Exit_Buy_Sig==1 || WPR_Exit_Buy_Sig==1) 
           && Spread()<Max_Spread*PointValue() && (Ask-Bid)<Max_Spread*PointValue())
       {                 
         //OrderClose(OrderTicket(),OrderLots(),Bid,3,Violet); // close position 
         CloseAll(Magic);
                                  
       } 
       
       if(OrderType()==OP_SELL &&   OrderSymbol()==Symbol() && OrderMagicNumber()==Magic && (CCI_Exit_Sell_Sig==1 || WPR_Exit_Sell_Sig==1) 
           && Spread()<Max_Spread*PointValue() && (Ask-Bid)<Max_Spread*PointValue())
       {                 
          //OrderClose(OrderTicket(),OrderLots(),Ask,3,Violet); // close position
          CloseAll(Magic);                 
                         
       }
    }  

    for(k=0; k<OrdersTotal(); k++)     
    {      
       OrderSelect(k, SELECT_BY_POS, MODE_TRADES);      
       if(OrderType()==OP_BUY &&   OrderSymbol()==Symbol() && OrderMagicNumber()==Magic && ((Ask-OrderOpenPrice())>=TakeProfit*PointValue()  || (OrderOpenPrice()-Ask)>=StopLoss*PointValue()))
       {                 
         OrderClose(OrderTicket(),OrderLots(),Bid,3,Violet); // close position 
         //CloseAll(Magic);
                                  
       } 
       
       if(OrderType()==OP_SELL &&   OrderSymbol()==Symbol() && OrderMagicNumber()==Magic && ((OrderOpenPrice()-Bid)>=TakeProfit*PointValue()  || (Bid-OrderOpenPrice())>=StopLoss*PointValue()))
       {                 
          OrderClose(OrderTicket(),OrderLots(),Ask,3,Violet); // close position
          //CloseAll(Magic);                 
                         
       }
    }
  }    
  

//////////////////////////////////// Open Trade ///////////////////////////////////////////////    
       
   if (New_Trade && Spread()<Max_Spread*PointValue() && (Ask-Bid)<Max_Spread*PointValue() && MyRealOrdersTotal(Magic)==0  && Trade && Time[0]!=Last_Time 
       && CCI_Buy_Sig==1 && WPR_Buy_Sig==1 && MA_Buy_Sig1==1 && MA_Buy_Sig2==1&& MA_Slope_Buy_Sig==1 && Fractals_Buy_Sig==1 && BB_Buy_Sig==1 && Trade_Spacing_Buy_Sig==1) 
   {

        Lot=CalculateLots(Risk);


        int Ticket_1 = OrderSend(Symbol(), OP_BUY, Lot, Ask, Slippage, 0, 0, EA_Comment, Magic, 0, Lime);
        if (Ticket_1>0)
         {
           Last_Time=iTime(NULL,0,0);
           if (!Hide_SL_TP) ModifyAll();
         }
   }
   
   if (New_Trade && Spread()<Max_Spread*PointValue() && (Ask-Bid)<Max_Spread*PointValue() && MyRealOrdersTotal(Magic)==0  && Trade && Time[0]!=Last_Time 
       && CCI_Sell_Sig==1 && WPR_Sell_Sig==1 && MA_Sell_Sig1==1 && MA_Sell_Sig2==1&& MA_Slope_Sell_Sig && Fractals_Sell_Sig==1 && BB_Sell_Sig==1 && Trade_Spacing_Sell_Sig==1) 
   {

        Lot=CalculateLots(Risk);


        int Ticket_2 = OrderSend(Symbol(), OP_SELL, Lot, Bid, Slippage, 0, 0, EA_Comment, Magic, 0, Red);
        if (Ticket_2>0)
         {
           Last_Time=iTime(NULL,0,0);
           if (!Hide_SL_TP) ModifyAll();
         }
   }   
            

//////////////////////////////////// Second Trade ///////////////////////////////////////////////    
       
   if (MyRealOrdersTotal(Magic)==1  && Allow_Second_Trade && Time[0]!=Last_Time && LastOpenType()==0 && Ask<=(LastBuyPrice()-Distance*PointValue()))
  
   {
        Lot=CalculateLots(Risk*Lot_Factor);

        Ticket_1 = OrderSend(Symbol(), OP_BUY, Lot, Ask, Slippage, 0, 0, EA_Comment, Magic, 0, Lime);
        if (Ticket_1>0)
         {
           Last_Time=iTime(NULL,0,0);
           if (!Hide_SL_TP) ModifyAll();
         }
   }
   
   if (MyRealOrdersTotal(Magic)==1  && Allow_Second_Trade && Time[0]!=Last_Time && LastOpenType()==1 && Bid>=(LastSellPrice()+Distance*PointValue()))
   {

        Lot=CalculateLots(Risk*Lot_Factor);

        Ticket_2 = OrderSend(Symbol(), OP_SELL, Lot, Bid, Slippage, 0, 0, EA_Comment, Magic, 0, Red);
        if (Ticket_2>0)
         {
           Last_Time=iTime(NULL,0,0);
           if (!Hide_SL_TP) ModifyAll();
         }
   }
      
  if   (!Hide_SL_TP && MyRealOrdersTotal(Magic)>0) ModifyAll();    // Double check to make sure all trades have TP and SL          
   
   return (0);
}

// EA End 

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

int MyRealOrdersTotal(int Magic)
{
  int c=0;
  int total  = OrdersTotal();
 
  for (int cnt = 0 ; cnt < total ; cnt++)
  {
    OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES);
    if (OrderMagicNumber() == Magic && OrderSymbol()==Symbol() && OrderType()<=OP_SELL)
    {
      c++;
    }
  }
  return(c);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

double LastSellPrice() 
{
   double l_ord_open_price_8=0;
   int l_ticket_24;
   double ld_unused_0 = 0;
   int l_ticket_20 = 0;
   for (int l_pos_16 = OrdersTotal() - 1; l_pos_16 >= 0; l_pos_16--) {
      OrderSelect(l_pos_16, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != Magic) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == Magic && OrderType() == OP_SELL) {
         l_ticket_24 = OrderTicket();
         if (l_ticket_24 > l_ticket_20) {
            l_ord_open_price_8 = OrderOpenPrice();
            ld_unused_0 = l_ord_open_price_8;
            l_ticket_20 = l_ticket_24;
         }
      }
   }
   return (l_ord_open_price_8);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////

double LastBuyPrice() 
{
   double l_ord_open_price_8=0;
   int l_ticket_24=0;
   double ld_unused_0 = 0;
   int l_ticket_20 = 0;
   for (int l_pos_16 = OrdersTotal() - 1; l_pos_16 >= 0; l_pos_16--) {
      OrderSelect(l_pos_16, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != Magic) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == Magic && OrderType() == OP_BUY ) {
         l_ticket_24 = OrderTicket();
         if (l_ticket_24 > l_ticket_20) {
            l_ord_open_price_8 = OrderOpenPrice();
            ld_unused_0 = l_ord_open_price_8;
            l_ticket_20 = l_ticket_24;
         }
      }
   }
   return (l_ord_open_price_8);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

int LastOpenType() 
{
   int l_ord_type=-1;
   int l_ticket_24=0;
   double ld_unused_0 = 0;
   int l_ticket_20 = 0;
   for (int l_pos_16 = OrdersTotal() - 1; l_pos_16 >= 0; l_pos_16--) {
      OrderSelect(l_pos_16, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != Magic) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == Magic && OrderType() <= OP_SELL) {
         l_ticket_24 = OrderTicket();
         if (l_ticket_24 > l_ticket_20) {
            l_ord_type = OrderType();
            ld_unused_0 = l_ord_type;
            l_ticket_20 = l_ticket_24;
         }
      }
   }
   return (l_ord_type);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////

int CloseAll(int Magic) 
{ 
   for (int cnt = OrdersTotal()-1 ; cnt >= 0; cnt--) 
   { 
      OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES); 
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == Magic && OrderCloseTime()==0) 
      { 
            if(OrderType()==OP_BUY)  OrderClose(OrderTicket(),OrderLots(),Bid,Slippage,Blue); 
            if(OrderType()==OP_SELL) OrderClose(OrderTicket(),OrderLots(),Ask,Slippage,Red); 
      } 
   }
   return(0); 
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

double CalculateLots(double RISK) 
{
   int Lot_Dec;
   double l_minlot_0 = MarketInfo(Symbol(), MODE_MINLOT);
   double l_maxlot_8 = MarketInfo(Symbol(), MODE_MAXLOT);
   double ld_ret_16 = 0.0;
   if (MarketInfo(Symbol(), MODE_MINLOT) < 1.0) Lot_Dec = 1;
   if (MarketInfo(Symbol(), MODE_MINLOT) < 0.1) Lot_Dec = 2;
   if (MarketInfo(Symbol(), MODE_MINLOT) < 0.01) Lot_Dec = 3;
   if (MarketInfo(Symbol(), MODE_MINLOT) < 0.001) Lot_Dec = 4;
   if (MarketInfo(Symbol(), MODE_MINLOT) < 0.0001) Lot_Dec = 5;
   if (lot > 0.0) {ld_ret_16 = lot;return (ld_ret_16);}
   if (ld_ret_16 == 0.0) 
   {
      ld_ret_16=NormalizeDouble(AccountBalance() / 100000.0 * RISK, Lot_Dec);
      if (ld_ret_16 < l_minlot_0) ld_ret_16 = l_minlot_0;
      if (ld_ret_16 > l_maxlot_8) ld_ret_16 = l_maxlot_8;
      return (ld_ret_16);
   }
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

double PointValue() {
   if (MarketInfo(Symbol(), MODE_DIGITS) == 5.0 || MarketInfo(Symbol(), MODE_DIGITS) == 3.0) return (10.0 * Point);
   return (Point);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void ModifyAll() 
{ 
   for (int cnt = OrdersTotal()-1 ; cnt >= 0; cnt--) 
   { 
      OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES); 
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == Magic ) 
      { 
         if (OrderStopLoss()==0 || OrderTakeProfit()==0)
         
            {
               if((OrderType()==OP_BUY)) 
               OrderModify(OrderTicket(),OrderOpenPrice(),ND(OrderOpenPrice()-PointValue()*StopLoss), ND(OrderOpenPrice()+TakeProfit*PointValue()),0,Green); 
               if((OrderType()==OP_SELL)) 
               OrderModify(OrderTicket(),OrderOpenPrice(),ND(OrderOpenPrice()+PointValue()*StopLoss), ND(OrderOpenPrice()-TakeProfit*PointValue()),0,Red);
            }   
      } 
   } 
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

double Spread(double AddValue=0)
{
   double LastValue;
   static double ArrayTotal=0;
   
   if (AddValue == 0 && SpreadSampleSize <= 0) return(Ask-Bid);
   if (AddValue == 0 && ArrayTotal == 0) return(Ask-Bid);
   if (AddValue == 0 ) return(ArrayTotal/ArraySize(Spread));
   
   ArrayTotal = ArrayTotal + AddValue;
   ArraySetAsSeries(Spread, true); 
   if (ArraySize(Spread) == SpreadSampleSize)
      {
      LastValue = Spread[0];
      ArrayTotal = ArrayTotal - LastValue;
      ArraySetAsSeries(Spread, false);
      ArrayResize(Spread, ArraySize(Spread)-1 );
      ArraySetAsSeries(Spread, true);
      ArrayResize(Spread, ArraySize(Spread)+1 ); 
      }
   else ArrayResize(Spread, ArraySize(Spread)+1 ); 
//   Print("ArraySize = ",ArraySize(lSpread)," AddedNo. = ",AddValue);
   ArraySetAsSeries(Spread, false);
   Spread[0] = AddValue;
   return(NormalizeDouble(ArrayTotal/ArraySize(Spread), Digits));
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

double ND(double Price)
{

  double ND_Price=0;
  ND_Price = NormalizeDouble(Price,Digits);
  return(ND_Price);
  
} 

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void Display()
{

   
   Comment( 
            "\n*=====================*",   
            "\n    "+EA_Name,
            "\n*=====================*",
            "\n   "+Session,
            "\n*=====================*",
            "\n    Broker Time          =  ", TimeToStr(TimeCurrent(), TIME_MINUTES),
            "\n    Start Hour             =  "+DoubleToStr(Open_Hour,2),          
            "\n    End Hour              =  "+DoubleToStr(Close_Hour,2), 
            "\n",                        
            "\n    Magic Number       = "+Magic,
            "\n    Maximum Spread   = "+DoubleToStr(Max_Spread,1),
            "\n    Average Spread    = "+DoubleToStr(Spread()/PointValue(),1),
            "\n    Lot size                 =  " +DoubleToStr(CalculateLots(Risk),2),
            "\n    Stop Loss              = "+DoubleToStr(StopLoss,0), 

            "\n*=====================*",                                                            
            "\n    Total Profit (Loss)       = "+DoubleToStr(TotalProfit()+Profit(),2), 
                                                
            "\n*=====================*",
            "\n    B A L A N C E        =  " + DoubleToStr(AccountBalance(),2),
            "\n    E Q U I T Y           =  " + DoubleToStr(AccountEquity(),2),
            "\n*=====================*"
            
 	        );
 	        
} 

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

double TotalProfit()
{
  double profit = 0;
 
  int cnt = OrdersHistoryTotal();
  for (int i=0; i < cnt; i++) {
    if (!OrderSelect(i, SELECT_BY_POS, MODE_HISTORY)) continue;
 
    if (OrderSymbol() == Symbol() && OrderMagicNumber() == Magic) profit += OrderProfit();
  }
 
  return (profit);
}	

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

double Profit()
{
  int c=0;
  int total  = OrdersTotal();
  double Profit=0;
 
  for (int cnt = 0 ; cnt < total ; cnt++)
  {
    OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES);
    if (OrderMagicNumber() == Magic && OrderType()<=OP_SELL)
    {
      Profit=Profit+OrderProfit();
    }
    
  }
   
  return(Profit);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

int LastClosedType(int Magic) {

   int xyz=OrdersHistoryTotal() - 2;
   if (!IsTesting() && !IsOptimization()) xyz=0;
   int l_ord_type=-1;
   int l_ticket_24=0;
   double ld_unused_0 = 0;
   int l_ticket_20 = 0;
   for (int l_pos_16 = OrdersHistoryTotal() - 1; l_pos_16 >= xyz; l_pos_16--) {
      OrderSelect(l_pos_16, SELECT_BY_POS, MODE_HISTORY);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != Magic) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == Magic && OrderType() <= OP_SELL) {
         l_ticket_24 = OrderTicket();
         if (l_ticket_24 > l_ticket_20) {
            l_ord_type = OrderType();
            ld_unused_0 = l_ord_type;
            l_ticket_20 = l_ticket_24;
         }
      }
   }
   return (l_ord_type);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

double LastClosedProfit(int Magic) {

   int xyz=OrdersHistoryTotal() - 2;
   if (!IsTesting() && !IsOptimization()) xyz=0;
   double l_ord_profit=0;
   int l_ticket_24=0;
   double ld_unused_0 = 0;
   int l_ticket_20 = 0;
   for (int l_pos_16 = OrdersHistoryTotal() - 1; l_pos_16 >= xyz; l_pos_16--) {
      OrderSelect(l_pos_16, SELECT_BY_POS, MODE_HISTORY);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != Magic) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == Magic && OrderType() <= OP_SELL) {
         l_ticket_24 = OrderTicket();
         if (l_ticket_24 > l_ticket_20) {
            l_ord_profit = OrderProfit();
            ld_unused_0 = l_ord_profit;
            l_ticket_20 = l_ticket_24;
         }
      }
   }
   return (l_ord_profit);
} 

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

datetime LastClosedTime(int Magic) {

   int xyz=OrdersHistoryTotal() - 2;
   if (!IsTesting() && !IsOptimization()) xyz=0;
   datetime l_ord_time=0;
   int l_ticket_24=0;
   datetime ld_unused_0 = 0;
   int l_ticket_20 = 0;
   for (int l_pos_16 = OrdersHistoryTotal() - 1; l_pos_16 >= xyz; l_pos_16--) {
      OrderSelect(l_pos_16, SELECT_BY_POS, MODE_HISTORY);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != Magic) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == Magic && OrderType() <= OP_SELL) {
         l_ticket_24 = OrderTicket();
         if (l_ticket_24 > l_ticket_20) {
            l_ord_time = OrderCloseTime();
            ld_unused_0 = l_ord_time;
            l_ticket_20 = l_ticket_24;
         }
      }
   }
   return (l_ord_time);
} 
      