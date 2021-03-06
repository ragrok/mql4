//+------------------------------------------------------------------+
//|                                                       tester.mq4 |
//|                                                Alexander Fedosov |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Alexander Fedosov"
#property strict
#include <../Include/价格速率指标.mqh>      //埋镱祛汔蝈朦磬 徼犭桀蝈赅 潆 蝾疸钼 铒屦圉栝
//+------------------------------------------------------------------+
//| 相疣戾蝠?耦忮蝽桕?                                             |
//+------------------------------------------------------------------+
input int             SL = 40;               // 羊铒-腩耨
input int             TP = 70;               // 义殛-镳铘栩
input bool            Lot_perm=true;         // 祟?铗 徉豚眈?
input double          lt=0.01;               // 祟?
input double          risk = 2;              // 需耜 溴镱玷蜞, %
input int             slippage= 5;           // 橡铖赅朦琨忄龛?
input int             magic=2356;            // 锑滏桕
input int             period=8;              // 襄痂钿 桧滂赅蝾疣 RSI
input ENUM_TIMEFRAMES tf=PERIOD_CURRENT;     // 朽犷麒?蜞殪麴彘?
int dg,index_rsi,index_ac;
trading tr;
//+------------------------------------------------------------------+
//| Expert Advisor initialization function                           |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- 铒疱溴脲龛?镥疱戾眄 潆 怦镱祛汔蝈朦眍泐 觌囫襦 蝾疸钼 趔黻鲨?
//--- 琨?铠栳铌, 痼耨觇?桦?镱 箪铍鬣龛?
   tr.ruErr=true;
   tr.Magic=magic;
   tr.slipag=slippage;
   tr.Lot_const=Lot_perm;
   tr.Lot=lt;
   tr.Risk=risk;
//--- 觐腓麇耱忸 镱稃蝾?镳?篑蜞眍怅?蝾疸钼铋 铒屦圉梃.
   tr.NumTry=5;
//--- 铒疱溴脲龛?溴?蜩黜 珥嚓钼 镱耠?玎?蝾?磬 蝈牦?沭圄桕?
   dg=tr.Dig();
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| 秒噔磬 趔黻鲨 疣聍弪?                                         |
//+------------------------------------------------------------------+
void OnTick()
  {
   depth_trend();
   speed_ac();
//--- 镳钼屦赅 磬 蝾, 黩?礤?箧?铗牮 铕溴痤?
   if(OrdersTotal()<1)
     {
      //--- 镳钼屦赅 篑腩忤?磬 镱牦镪?
      if(Buy())
         tr.OpnOrd(OP_BUY,tr.Lots(),Ask,SL*dg,TP*dg);
      //--- 镳钼屦赅 篑腩忤?磬 镳钿噫?
      if(Sell())
         tr.OpnOrd(OP_SELL,tr.Lots(),Bid,SL*dg,TP*dg);
     }
//--- 羼螯 铗牮 铕溴疣?
   if(OrdersTotal()>0)
     {
      //--- 镳钼屦屐 ?玎牮噱?蝈 铕溴瘥 磬 镳钿噫? 觐蝾瘥?箐钼脲蜮铕 篑腩忤?玎牮?.
      if(Sell_close())
         tr.ClosePosAll(OP_SELL);
      //--- 镳钼屦屐 ?玎牮噱?蝈 铕溴瘥 磬 镱牦镪? 觐蝾瘥?箐钼脲蜮铕 篑腩忤?玎牮?.
      if(Buy_close())
         tr.ClosePosAll(OP_BUY);
     }
  }
//+------------------------------------------------------------------+
//| 泽黻鲨 铒疱溴脲龛 汶筢桧?蝠屙溧                               |
//+------------------------------------------------------------------+
void depth_trend()
  {
//--- 铒疱溴脲龛?桧溴犟?磬 镱牦镪?
   double rsi=iRSI(Symbol(),tf,period,PRICE_CLOSE,0);
   index_rsi = 0;
   if(rsi>90.0) index_rsi=4;
   else if(rsi>80.0)
      index_rsi=3;
   else if(rsi>70.0)
      index_rsi=2;
   else if(rsi>60.0)
      index_rsi=1;
   else if(rsi<10.0)
      index_rsi=-4;
   else if(rsi<20.0)
      index_rsi=-3;
   else if(rsi<30.0)
      index_rsi=-2;
   else if(rsi<40.0)
      index_rsi=-1;
  }
//+------------------------------------------------------------------+
//| 泽黻鲨 铒疱溴脲龛 耜铕铖蜩 蝠屙溧                              |
//+------------------------------------------------------------------+
void speed_ac()
  {
   double ac[];
   ArrayResize(ac,5);
   for(int i=0; i<5; i++)
      ac[i]=iAC(Symbol(),tf,i);
//---
   index_ac=0;
//--- 耔沩嚯 磬 镱牦镪?
   if(ac[0]>ac[1])
      index_ac=1;
   else if(ac[0]>ac[1] && ac[1]>ac[2])
      index_ac=2;
   else if(ac[0]>ac[1] && ac[1]>ac[2] && ac[2]>ac[3])
      index_ac=3;
   else if(ac[0]>ac[1] && ac[1]>ac[2] && ac[2]>ac[3] && ac[3]>ac[4])
      index_ac=4;
//--- 耔沩嚯 磬 镳钿噫?
   else if(ac[0]<ac[1])
      index_ac=-1;
   else if(ac[0]<ac[1] && ac[1]<ac[2])
      index_ac=-2;
   else if(ac[0]<ac[1] && ac[1]<ac[2] && ac[2]<ac[3])
      index_ac=-3;
   else if(ac[0]<ac[1] && ac[1]<ac[2] && ac[2]<ac[3] && ac[3]<ac[4])
      index_ac=-4;
  }
//+------------------------------------------------------------------+
//| 泽黻鲨 镳钼屦觇 篑腩忤 磬 镱牦镪?                             |
//+------------------------------------------------------------------+
bool Buy()
  {
   bool res=false;
   if((index_rsi==2 && index_ac>=1) || (index_rsi==3 && index_ac==1))
      res=true;
   return (res);
  }
//+------------------------------------------------------------------+
//| 泽黻鲨 镳钼屦觇 篑腩忤 磬 镳钿噫?                             |
//+------------------------------------------------------------------+
bool Sell()
  {
   bool res=false;
   if((index_rsi==-2 && index_ac<=-1) || (index_rsi==-3 && index_ac==-1))
      res=true;
   return (res);
  }
//+------------------------------------------------------------------+
//| 泽黻鲨 镳钼屦觇 篑腩忤 玎牮? 镱玷鲨?磬 镱牦镪?            |
//+------------------------------------------------------------------+
bool Buy_close()
  {
   bool res=false;
   if(index_rsi>2 && index_ac<0)
      res=true;
   return (res);
  }
//+------------------------------------------------------------------+
//| 泽黻鲨 镳钼屦觇 篑腩忤 玎牮? 镱玷鲨?磬 镳钿噫?            |
//+------------------------------------------------------------------+
bool Sell_close()
  {
   bool res=false;
   if(index_rsi<-2 && index_ac>0)
      res=true;
   return (res);
  }
//+------------------------------------------------------------------+
