//+------------------------------------------------------------------+
//|                                                       均线交叉策略.mq4 |
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

//---Macd指标参数
int macdFast = 12;
int macdSlow = 26;
int macdSignal = 9;

//---Ea参数
int magicNum = 12345612;
string comment = "均线测试";
double lots = 0.01;

//-- 策略变量
bool goldCross = false;
bool deadCross = false;
datetime timeFlag = 0;

//-- 均线指标参数
int maPeriod = 60;



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
//---

//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   double macdMainValue1 = iMACD(Symbol(),PERIOD_H4,macdFast,macdSlow,macdSignal,PRICE_CLOSE,MODE_MAIN,1);//--MACD均线
   double  macdMainValuePre1 = iMACD(Symbol(),PERIOD_H4,macdFast,macdSlow,macdSignal,PRICE_CLOSE,MODE_MAIN,2);

   double macdSingalValue1 = iMACD(Symbol(),PERIOD_H4,macdFast,macdSlow,macdSignal,PRICE_CLOSE,MODE_SIGNAL,1);//--MACD开仓信号
   double macdSingalValuePre1 = iMACD(Symbol(),PERIOD_H4,macdFast,macdSlow,macdSignal,PRICE_CLOSE,MODE_SIGNAL,2);

   for(int i=0; i < OrdersTotal(); i++)//---平仓
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) && OrderSymbol() == Symbol() && OrderMagicNumber() == magicNum)
        {
         if(OrderType() == OP_BUY)
           {
            if(macdMainValue1 < macdSingalValue1 && macdMainValuePre1 < macdSingalValuePre1)
              {
               OrderClose(OrderTicket(),OrderLots(),Bid,3,clrNONE);
              }
           }
         if(OrderType() == OP_SELL)
           {
            if(macdMainValue1 > macdSingalValue1 && macdMainValuePre1 > macdSingalValuePre1)
              {
               OrderClose(OrderTicket(),OrderLots(),Ask,3,clrNONE);
              }
           }
        }
     }


   if(timeFlag == iTime(Symbol(),0,0))//---开仓K线判断
     {
      return;
     }
   timeFlag = iTime(Symbol(),0,0);

   for(int i=0; i < OrdersTotal(); i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) && OrderSymbol() == Symbol() && OrderMagicNumber() == magicNum)
        {
         return;
        }
     }

   double maValue = iMA(Symbol(),PERIOD_D1,maPeriod,0,MODE_EMA,PRICE_CLOSE,1);//--MA均线
   double maValuePre = iMA(Symbol(),PERIOD_D1,maPeriod,0,MODE_EMA,PRICE_CLOSE,2);

   double macdMainValue = iMACD(Symbol(),PERIOD_D1,macdFast,macdSlow,macdSignal,PRICE_CLOSE,MODE_MAIN,1);//--MACD均线
   double  macdMainValuePre = iMACD(Symbol(),PERIOD_D1,macdFast,macdSlow,macdSignal,PRICE_CLOSE,MODE_MAIN,2);

   double macdSingalValue = iMACD(Symbol(),PERIOD_D1,macdFast,macdSlow,macdSignal,PRICE_CLOSE,MODE_SIGNAL,1);//--MACD开仓信号
   double macdSingalValuePre = iMACD(Symbol(),PERIOD_D1,macdFast,macdSlow,macdSignal,PRICE_CLOSE,MODE_SIGNAL,2);

   if(maValue > maValuePre)//---下多单
     {
      if(macdMainValue > macdSingalValue && macdMainValuePre > macdSingalValuePre) //---金叉
        {
         int orderId =  OrderSend(Symbol(),OP_BUY,lots,Ask,3,0,0,comment,magicNum,0,clrNONE);
         Print("多单订单编号：",orderId);
        }
     }

   if(maValue < maValuePre)//---下空单
     {
      if(macdMainValue < macdSingalValue && macdMainValuePre < macdSingalValuePre) //---金叉
        {
         int orderId =  OrderSend(Symbol(),OP_SELL,lots,Bid,3,0,0,comment,magicNum,0,clrNONE);
         Print("空单订单编号：",orderId);
        }
     }
  }
//+------------------------------------------------------------------+
