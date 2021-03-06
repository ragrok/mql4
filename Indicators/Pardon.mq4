//+------------------------------------------------------------------+
//|                                                       Pardon.mq4 |
/*
 这是一个简化的方向指示指标
 */
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, 环球外汇网友交流群@Aother,448036253@qq.com"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

// 日线报价
double dayRates[2][6];
// 周线报价
double weekRates[2][6];

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   EventSetTimer(1);
   //创建对象
   ObjectCreate(0,"lblTimer",OBJ_LABEL,0,NULL,NULL);
   ObjectCreate(0,"lblTrend",OBJ_LABEL,0,NULL,NULL);
   ObjectCreate(0,"lblAuthor",OBJ_LABEL,0,NULL,NULL);
   ObjectCreate(0,"lblAdvice",OBJ_LABEL,0,NULL,NULL);
   //设置内容
   ObjectSetString(0,"lblTimer",OBJPROP_TEXT,_Symbol+"蜡烛剩余");
   ObjectSetString(0,"lblTrend",OBJPROP_TEXT,"MACD判断");
   ObjectSetString(0,"lblAuthor",OBJPROP_TEXT,"作者：环球外汇网@Aother");
   ObjectSetString(0,"lblAdvice",OBJPROP_TEXT,"操作建议：待定");
   //设置颜色
   ObjectSetInteger(0,"lblTimer",OBJPROP_COLOR,clrBlack);
   ObjectSetInteger(0,"lblTrend",OBJPROP_COLOR,clrRed);
   ObjectSetInteger(0,"lblAuthor",OBJPROP_COLOR,clrGray);
   ObjectSetInteger(0,"lblAdvice",OBJPROP_COLOR,clrRed);
   //--- 定位右上角 
   ObjectSetInteger(0,"lblTimer",OBJPROP_CORNER ,CORNER_RIGHT_UPPER); 
   ObjectSetInteger(0,"lblTrend",OBJPROP_CORNER,CORNER_RIGHT_UPPER);
   ObjectSetInteger(0,"lblAuthor",OBJPROP_CORNER,CORNER_RIGHT_UPPER);
   //--- 定位右下角
   ObjectSetInteger(0,"lblAdvice",OBJPROP_CORNER,CORNER_RIGHT_LOWER);
   //设置XY坐标
   ObjectSetInteger(0,"lblTimer",OBJPROP_XDISTANCE,200);   
   ObjectSetInteger(0,"lblTimer",OBJPROP_YDISTANCE,40);
   ObjectSetInteger(0,"lblTrend",OBJPROP_XDISTANCE,200);  
   ObjectSetInteger(0,"lblTrend",OBJPROP_YDISTANCE,60);
   ObjectSetInteger(0,"lblAuthor",OBJPROP_XDISTANCE,200);
   ObjectSetInteger(0,"lblAuthor",OBJPROP_YDISTANCE,80);
   ObjectSetInteger(0,"lblAdvice",OBJPROP_XDISTANCE,450);
   ObjectSetInteger(0,"lblAdvice",OBJPROP_YDISTANCE,20);
   
   // 日线轴心
   ObjectCreate(0,"lnDayPP",OBJ_HLINE,0,NULL,NULL);
   ObjectSetInteger(0,"lnDayPP",OBJPROP_COLOR,clrRed);
   ObjectSetInteger(0,"lnDayPP",OBJPROP_STYLE,STYLE_SOLID);
   ObjectSetInteger(0,"lnDayPP",OBJPROP_WIDTH,1);
   //日线S1
   ObjectCreate(0,"lnDayS1",OBJ_HLINE,0,NULL,NULL);
   ObjectSetInteger(0,"lnDayS1",OBJPROP_COLOR,clrRed);
   ObjectSetInteger(0,"lnDayS1",OBJPROP_STYLE,STYLE_DASH);
   ObjectSetInteger(0,"lnDayS1",OBJPROP_WIDTH,1);
   //日线R1
   ObjectCreate(0,"lnDayR1",OBJ_HLINE,0,NULL,NULL);
   ObjectSetInteger(0,"lnDayR1",OBJPROP_COLOR,clrRed);
   ObjectSetInteger(0,"lnDayR1",OBJPROP_STYLE,STYLE_DASH);
   ObjectSetInteger(0,"lnDayR1",OBJPROP_WIDTH,1);
   
   // 周线轴心
   ObjectCreate(0,"lnWeekPP",OBJ_HLINE,0,NULL,NULL);
   ObjectSetInteger(0,"lnWeekPP",OBJPROP_COLOR,clrOrange);
   ObjectSetInteger(0,"lnWeekPP",OBJPROP_STYLE,STYLE_SOLID);
   ObjectSetInteger(0,"lnWeekPP",OBJPROP_WIDTH,1);
   //周线S1
   ObjectCreate(0,"lnWeekS1",OBJ_HLINE,0,NULL,NULL);
   ObjectSetInteger(0,"lnWeekS1",OBJPROP_COLOR,clrOrange);
   ObjectSetInteger(0,"lnWeekS1",OBJPROP_STYLE,STYLE_DASH);
   ObjectSetInteger(0,"lnWeekS1",OBJPROP_WIDTH,1);
   //周线R1
   ObjectCreate(0,"lnWeekR1",OBJ_HLINE,0,NULL,NULL);
   ObjectSetInteger(0,"lnWeekR1",OBJPROP_COLOR,clrOrange);
   ObjectSetInteger(0,"lnWeekR1",OBJPROP_STYLE,STYLE_DASH);
   ObjectSetInteger(0,"lnWeekR1",OBJPROP_WIDTH,1);
   
   return(INIT_SUCCEEDED);
}


//+------------------------------------------------------------------+
//| Expert 运行结束 function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   EventKillTimer();
   ObjectsDeleteAll(0, 0, OBJ_LABEL);
   Print("EA运行结束，已经卸载" );
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
   // 趋势感知：上一个收盘价的指标
   //MACD主要，大周期
   double macdBigMain = iMACD(_Symbol,PERIOD_H4,12,26,9,PRICE_CLOSE,MODE_MAIN,1);
   //MACD信号，大周期
   double macdBigSignal = iMACD(_Symbol,PERIOD_H4,12,26,9,PRICE_CLOSE,MODE_SIGNAL,1);
   //日线、周线轴心
   ArrayCopyRates(dayRates, _Symbol, PERIOD_D1);
   ArrayCopyRates(weekRates, _Symbol, PERIOD_W1);
   //典型： (yesterday_high + yesterday_low + yesterday_close)/3
   //给予收盘价更高权重： (yesterday_high + yesterday_low +2* yesterday_close)/4
   double dayClose = dayRates[1][4];
   double dayHigh = dayRates[1][3];
   double dayLow = dayRates[1][2];
   double weekClose = weekRates[1][4];
   double weekHigh = weekRates[1][3];
   double weekLow = weekRates[1][2];
   // 轴心
   double dayPP = (dayHigh + dayLow + 2*dayClose)/4;
   double weekPP = (weekHigh + weekLow + 2*weekClose)/4;
   // 支撑1：(2 * P) - H
   // 阻力1： (2 * P) - L
   double dayS1 = 2*dayPP - dayHigh;
   double dayP1 = 2*dayPP - dayLow;
   double weekS1 = 2*weekPP - weekHigh;
   double weekP1 = 2*weekPP - weekLow;
   
   ObjectMove(0,"lnDayPP",0,NULL,dayPP);
   ObjectMove(0,"lnDayS1",0,NULL,dayS1);
   ObjectMove(0,"lnDayR1",0,NULL,dayP1);
   ObjectMove(0,"lnWeekPP",0,NULL,weekPP);
   ObjectMove(0,"lnWeekS1",0,NULL,weekS1);
   ObjectMove(0,"lnWeekR1",0,NULL,weekP1);

   // 操作建议
   string advice = "";
   
   //MACD走势判定
   //多头趋势
   if(macdBigSignal>0 && macdBigMain>macdBigSignal)
   {
      ObjectSetString(0,"lblTrend",OBJPROP_TEXT,"大周期MACD：多头趋势↑");
      advice = "守则：只做多，汇价下探触及60均线进多，趋势改变平仓";
   }
   else if(macdBigSignal<0 && macdBigMain<macdBigSignal)
   {
      ObjectSetString(0,"lblTrend",OBJPROP_TEXT,"大周期MACD：空头趋势↓");
      advice = "守则：只做空，汇价上探触及60均线进空，趋势改变平仓";
   }
   else
   {
      ObjectSetString(0,"lblTrend",OBJPROP_TEXT,"大周期MACD：调整震荡~");
      advice = "建议：多空皆可，顶部开空，底部开多";   
   }
   
   // 显示操作建议
   ObjectSetString(0,"lblAdvice",OBJPROP_TEXT,advice);
   ObjectSetInteger(0,"lblAdvice",OBJPROP_XDISTANCE,18*StringLen(advice) + 16); 
   
}
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
{
   // 定时刷新计算当前蜡烛剩余时间
   long hour = Time[0] + 60 * Period() - TimeCurrent();
   long minute = (hour - hour % 60) / 60;
   long second = hour % 60;
   ObjectSetString(0,"lblTimer",OBJPROP_TEXT,StringFormat("%s蜡烛剩余：%d分%d秒",_Symbol,minute,second));
}
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
{
   
}
//+------------------------------------------------------------------+
