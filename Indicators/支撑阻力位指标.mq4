//+------------------------------------------------------------------+
//|                                                      支撑阻力位指标.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window


enum eTimeFrame {M1=1,M5=5,M15=15,M30=30,H1=60,H4=240,D1=1440};
extern eTimeFrame pTimeFrame=1440;//时间周期
extern int pCount=1;//要计算的周期数
extern int pShift=0;//偏移量

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping

//---
   return(INIT_SUCCEEDED);
  }

//--+-----+--+------+---------+-+---+-+---+--+-----+--+------+---------+-+---+-+---+--+-----+--+------+---------+-+---+-+---+--+-----+--+------+---------+-+---+-+---
void OnTick()
  {
   double xR3,xR2,xR1,xP,xS1,xS2,xS3;
   GetPivotPoint(Symbol(),xR3,xR2,xR1,xP,xS1,xS2,xS3,pTimeFrame,pCount,pShift);
   CreateLine("PivotPoint",xP,Red);
   CreateLine("R3",xR3,White);
   CreateLine("R2",xR2,Yellow);
   CreateLine("R1",xR1,Aqua);
   CreateLine("S1",xS1,Aqua);
   CreateLine("S2",xS2,Yellow);
   CreateLine("S3",xS3,White);
  }

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//---

//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+

//--+-----+--+------+---------+-+---+-+---+--+-----+--+------+---------+-+---+-+---+--+-----+--+------+---------+-+---+-+---+--+-----+--+------+---------+-+---+-+---
void GetPivotPoint(string xSymbol,double &xR3,double &xR2,double &xR1,double &xP,double &xS1,double &xS2,double &xS3,int xTimeFrame=1440,int xCount=1,int xShift=0) /*枢轴点*/
  {
   double xH=iHigh(xSymbol,xTimeFrame,iHighest(xSymbol,xTimeFrame,MODE_HIGH,xCount,xShift+1));
   double xL=iLow(xSymbol,xTimeFrame,iLowest(xSymbol,xTimeFrame,MODE_LOW,xCount,xShift+1));
   double xC=iClose(xSymbol,xTimeFrame,xShift+1);
   xP=(xH+xL+xC)/3;
   xR1=2*xP-xL;
   xS1=2*xP-xH;
   xR2=xP+(xR1-xS1);
   xS2=xP-(xR1-xS1);
   xR3=xH+2*(xP-xL);
   xS3=xL-2*(xH-xP);
  }
//--+-----+--+------+---------+-+---+-+---+--+-----+--+------+---------+-+---+-+---+--+-----+--+------+---------+-+---+-+---+--+-----+--+------+---------+-+---+-+---
void CreateLine(string xObjectName,double xPrice,color xColor=Red,string xFont="微软雅黑",int xFontSize=10)
  {
   ObjectDelete(0,xObjectName);
   ObjectCreate(0,xObjectName,OBJ_HLINE,0,0,xPrice);
   ObjectSetInteger(0, xObjectName, OBJPROP_COLOR, xColor);
   string xLabelName=xObjectName+"_Text";
   ObjectDelete(0,xLabelName);
   ObjectCreate(0,xLabelName,OBJ_TEXT,0,iTime(Symbol(),Period(),10),xPrice);
   int xDigits=StrToInteger(DoubleToStr(MarketInfo(Symbol(),MODE_DIGITS),0));
   ObjectSetString(0,xLabelName,OBJPROP_TEXT,xObjectName+"("+DoubleToStr(xPrice,xDigits)+")");
   ObjectSetString(0,xLabelName,OBJPROP_FONT,xFont);
   ObjectSetInteger(0,xLabelName,OBJPROP_FONTSIZE,xFontSize);
   ObjectSetInteger(0,xLabelName,OBJPROP_COLOR,xColor);
  }
//--+-----+--+------+---------+-+---+-+---+--+-----+--+------+---------+-+---+-+---+--+-----+--+------+---------+-+---+-+---+--+-----+--+------+---------+-+---+-+---
void ChartInit()
  {
   ObjectsDeleteAll(0,0,-1);
   ChartSetInteger(0,CHART_MODE,CHART_LINE);
   ChartSetInteger(0,CHART_SHOW_GRID,false);
  }
//+------------------------------------------------------------------+
