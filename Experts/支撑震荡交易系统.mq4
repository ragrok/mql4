//+------------------------------------------------------------------+
//|                                               支撑位震荡系统.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+

//--- 输入参数
input double takeProfitPoint =600;
input double stopPoint =100;
input double maxOpen = 0.03;
//--- 固定参数
double lots = 0.01;

//--- EA标识
string comment = "Ea开单";
int magicNum = 82934231;

//--- 全局变量
datetime lasttime;
double xR3,xR2,xR1,xP,xS1,xS2,xS3;



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {

   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {


  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   calculatePivotPoint();
   calculateTakeProfit();
   trading();
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void trading()   //下单交易
  {
//下单前检查,检查不通过不下订单
   if(tradingPreCheck() == false)
      return;
   double preColsePrice1 = iClose(Symbol(),Period(),1); //前一根k线收盘价
   double preColsePrice2 = iClose(Symbol(),Period(),2); //前两根k线收盘价
   double middlePrice1 = (xR1 + xP)/2;
   double bidPrice = Bid;
   if(bidPrice < xR1  && bidPrice > middlePrice1 && preColsePrice2 > preColsePrice1)//---当前价格小于R1，大于R1+P的中间价,开空单，且前两根k线收盘价是下跌趋势
     {
      double closePrice1= (xR1 + xP)/2;
      double closePrice2= askPrice - closePrice1 < minStopPoint*Point ? askPrice - minStopPoint*Point : closePrice1; //止损价防止极端情况出现，规定最大小损价
      double closePrice3= askPrice - closePrice2 > maxStopPoint*Point ? askPrice - maxStopPoint*Point : closePrice2; //止损价防止极端情况出现，规定最大止损价
      int orderId =  OrderSend(Symbol(),OP_BUY,lots,Ask,3,closePrice3,xR3,comment,magicNum,0,clrNONE);
      Print("多单编号：",orderId);
     }
   double middlePrice2 = (xS1 + xS2)/2;
  double askPrice = Ask;
   if(bidPrice > xS1  && bidPrice < middlePrice2 && preColsePrice2 < preColsePrice1)//---当前价格大于S1和S2的中间价，小于S1,开空单，止损位为S1+P的中间价,止盈位为S3
     {
      double closePrice1= (xS1 + xP)/2;
      double closePrice2= closePrice1 - bidPrice < minStopPoint*Point ? bidPrice + minStopPoint*Point : closePrice1;  //止损价防止极端情况出现，规定最大小损价
      double closePrice3= closePrice2 - bidPrice > maxStopPoint*Point ? bidPrice + maxStopPoint*Point : closePrice2;  //止损价防止极端情况出现，规定最大止损价
      int orderId =  OrderSend(Symbol(),OP_SELL,lots,Bid,3,closePrice3,xS3,comment,magicNum,0,clrNONE);
      Print("空单编号：",orderId);
     }
  }
//+------------------------------------------------------------------+
//|                  交易前检查                                                |
//+------------------------------------------------------------------+
bool tradingPreCheck()
  {
   if(OrdersTotal() >= maxOpen)
      return false;
   if(Time[0] == lasttime)
      return false; //每时间周期检查一次  时间控制
   lasttime = Time[0];

   if(TimeDayOfWeek(CurTime()) == 1)
     {
      if(TimeHour(CurTime()) < 3)
         return false; //周一早8点前不做  时间控制
     }
   if(TimeDayOfWeek(CurTime()) == 5)
     {
      if(TimeHour(CurTime()) > 19)
         return false; //周五晚11点后不做
     }
   return true;
  }
//+------------------------------------------------------------------+
//|                                计算止盈                                 |
//+------------------------------------------------------------------+
void calculateTakeProfit()   //跟踪止赢
  {
   bool bs = false;
   for(int i = 0; i < OrdersTotal(); i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false)
         break;
      if(OrderType() == OP_BUY && OrderSymbol() == Symbol() && OrderMagicNumber() == magicNum)
        {
         if((Bid - OrderOpenPrice()) > (TrailingStop * MarketInfo(OrderSymbol(), MODE_POINT)))     //开仓价格 当前止损和当前价格比较判断是否要修改跟踪止赢设置
           {
            if(OrderStopLoss() < Bid - TrailingStop * MarketInfo(OrderSymbol(), MODE_POINT))
              {
               bs = OrderModify(OrderTicket(), OrderOpenPrice(), Bid - TrailingStop * MarketInfo(OrderSymbol(), MODE_POINT), OrderTakeProfit(),0, Green);
              }
           }
        }
      else
         if(OrderType() == OP_SELL && OrderSymbol() == Symbol() && OrderMagicNumber() == magicNum)
           {
            if((OrderOpenPrice() - Ask) > (TrailingStop * MarketInfo(OrderSymbol(), MODE_POINT)))   //开仓价格 当前止损和当前价格比较判断是否要修改跟踪止赢设置

              {
               if((OrderStopLoss()) > (Ask + TrailingStop * MarketInfo(OrderSymbol(), MODE_POINT)))
                 {
                  bs = OrderModify(OrderTicket(), OrderOpenPrice(),
                                   Ask + TrailingStop * MarketInfo(OrderSymbol(), MODE_POINT), OrderTakeProfit(),0, Tan);
                 }
              }
           }
     }
  }
//+------------------------------------------------------------------+

//平仓持有的买单
void closeBuy()
  {
   if(OrdersTotal() > 0)
     {
      for(int i=OrdersTotal()-1; i>=0; i--)
        {
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false)
            break;
         if(OrderType()==OP_BUY && OrderSymbol() == Symbol() && OrderMagicNumber() == magicNum)
           {
            OrderClose(OrderTicket(),OrderLots(),Bid,3,White);
           }
        }
     }
  }
//平仓持有的卖单
void closeSell()
  {
   if(OrdersTotal() > 0)
     {
      for(int i=OrdersTotal()-1; i>=0; i--)
        {
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false)
            break;
         if(OrderType()==OP_SELL && OrderSymbol() == Symbol() && OrderMagicNumber() == magicNum)
           {
            OrderClose(OrderTicket(),OrderLots(),Ask,3,White);
           }
        }
     }
  }



void calculatePivotPoint() /*枢轴点*/
  {
   double xH=iHigh(Symbol(),PERIOD_D1,iHighest(Symbol(),PERIOD_D1,MODE_HIGH,1,1));
   double xL=iLow(Symbol(),PERIOD_D1,iLowest(Symbol(),PERIOD_D1,MODE_LOW,1,1));
   double xC=iClose(Symbol(),PERIOD_D1,1);
//PrintFormat("昨日最高价：{%f},昨日最低价：{%f},昨日收盘价：{%f}",xH,xL,xC);
   xP=(xH+xL+xC)/3;
   xR1=2*xP-xL;
   xS1=2*xP-xH;
   xR2=xP+(xR1-xS1);
   xS2=xP-(xR1-xS1);
   xR3=xH+2*(xP-xL);
   xS3=xL-2*(xH-xP);
//PrintFormat("P价：{%f},R1价：{%f},S1价：{%f},R2价：{%f},S2价：{%f},R3价：{%f}S3价：{%f},",xP,xR1,xS1,xR2,xS2,xR3,xS3);
  }
//+------------------------------------------------------------------+
