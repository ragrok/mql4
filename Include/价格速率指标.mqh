//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| 翌疸钼 铒屦圉梃                                                |
//+------------------------------------------------------------------+
class trading
  {
private:
   string            textcom;
   bool              useECNNDD;
   double            ND(double pr);
   int               NormE(int pr);
   double            NormL(double lo);
   bool              ChekPar(int tip,double oop,double osl,double otp,double op,double sl,double tp,int mod=0);
   int               SendOrd(int tip,double lo,double op,double sl,double tp,string com);
   bool              StopLev(double pr1,double pr2);
   bool              Freez(double pr1,double pr2);
   bool              FreeM(double lo);
   string            StrTip(int tip);
   string            Errors(int id);
   void              Err(int id);

public:
   bool              ruErr;
   int               Magic;
   string            Com;
   int               slipag;
   double            Lot;
   bool              Lot_const;
   double            Risk;
   int               NumTry;
   color             BayCol;
   color             SelCol;
   bool              ClosePosAll(int OrdType=-1);
   bool              OpnOrd(int tip,double op_l,double op_pr,int stop,int take);
   double            Lots();
   int               Dig();

  };
//+------------------------------------------------------------------+
//| OpnOrd                                                           |
//+------------------------------------------------------------------+
bool trading:: OpnOrd(int tip,double op_l,double op_pr,int stop,int take)
  {
   bool res=false;
   long stoplevel=SymbolInfoInteger(_Symbol,SYMBOL_TRADE_STOPS_LEVEL);
   double sl=0.0,tp=0.0;
   if(MathMod(tip,2.0)==0.0)
     {
      if(!useECNNDD)
        {
         if(stop>0)
            sl=op_pr-NormE(stop)*Point;
         if(take>0)
            tp=op_pr+NormE(take)*Point;
        }
     }
   else
     {
      if(!useECNNDD)
        {
         if(stop>0)
            sl=op_pr+NormE(stop)*Point;
         if(take>0)
            tp=op_pr-NormE(take)*Point;
        }
     }
   if(SendOrd(tip,op_l,op_pr,sl,tp,Com)>0)
      res=true;
   int er=GetLastError();
   if(er>0)
      textcom=StringConcatenate(textcom,"\n",__FUNCTION__,Errors(er),"  ",TimeCurrent());
   return(res);
  }
//+------------------------------------------------------------------+
//| SendOrd                                                          |
//+------------------------------------------------------------------+
int trading:: SendOrd(int tip,double lo,double op,double sl,double tp,string com)
  {
   int i=0,tiket=0;
   if(!FreeM(lo))
      return(tiket);
   color col=SelCol;
   if(MathMod(tip,2.0)==0.0)
      col=BayCol;
   for(i=1; i<NumTry; i++)
     {
      switch(tip)
        {
         case 0:
            op=Ask;
            break;
         case 1:
            op=Bid;
            break;
        }
      if(!ChekPar(tip,0.0,0.0,0.0,op,sl,tp,0))
         break;
      tiket=OrderSend(_Symbol,tip,NormL(lo),ND(op),slipag,ND(sl),ND(tp),com,Magic,0,col);
      if(tiket>0)
         break;
      else
        {
         int er=GetLastError();
         textcom=StringConcatenate(textcom,"\n",__FUNCTION__,"硒栳赅 铗牮桢 镱玷鲨?,StrTip(tip)," : ",
                                 Errors(er)," ,镱稃蜿?",IntegerToString(i)," ",TimeCurrent());
         Err(er);
        }
     }
   return(tiket);
  }
//+------------------------------------------------------------------+
//| ClosePosAll                                                      |
//+------------------------------------------------------------------+
bool trading::ClosePosAll(int OrdType=-1)
  {
   double price;
   int i;
   bool _Ans=true;
   for(int pos=OrdersTotal()-1; pos>=0; pos--)
     {
      if(!OrderSelect(pos,SELECT_BY_POS,MODE_TRADES))
         continue;
      if(OrderSymbol()!=_Symbol || OrderMagicNumber()!=Magic)
         continue;
      int order_type=OrderType();
      if(order_type>1 || (OrdType>=0 && OrdType!=order_type))
         continue;
      RefreshRates();
      i=0;
      bool Ans=false;
      while(!Ans && i<NumTry)
        {
         if(order_type==OP_BUY)
            price=Bid;
         else
            price=Ask;
         Ans=OrderClose(OrderTicket(),OrderLots(),ND(price),slipag);
         if(!Ans)
           {
            int er=GetLastError();
            if(er>0)
               textcom=StringConcatenate(textcom,"\n",__FUNCTION__,Errors(er),"  ",TimeCurrent());
           }
         i++;
        }
      if(!Ans)
         _Ans=false;
     }
   return(_Ans);
  }
//+------------------------------------------------------------------+
//| ND                                                               |
//+------------------------------------------------------------------+
double trading:: ND(double pr)
  {
   double res=NormalizeDouble(pr,_Digits);
   int er=GetLastError();
   if(er>0)
      textcom=StringConcatenate(textcom,"\n",__FUNCTION__,Errors(er),"  ",TimeCurrent());
   return(res);
  }
//+------------------------------------------------------------------+
//| NormE                                                            |
//+------------------------------------------------------------------+
int trading:: NormE(int pr)
  {
   long res=SymbolInfoInteger(_Symbol,SYMBOL_TRADE_STOPS_LEVEL);
   res++;
   if(pr>res)
      res=pr;
   int er=GetLastError();
   if(er>0)
      textcom=StringConcatenate(textcom,"\n",__FUNCTION__,Errors(er),"  ",TimeCurrent());
   return(int(res));
  }
//+------------------------------------------------------------------+
//| NormL                                                            |
//+------------------------------------------------------------------+
double trading:: NormL(double lo)
  {
   double res=lo;
   int mf=int(MathCeil(lo/SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_STEP)));
   res=mf*SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_STEP);
   res=MathMax(res,SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN));
   res=MathMin(res,SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MAX));
   int er=GetLastError();
   if(er>0)
      textcom=StringConcatenate(textcom,"\n",__FUNCTION__,Errors(er),"  ",TimeCurrent());
   return(res);
  }
//+------------------------------------------------------------------+
//| Errors                                                           |
//+------------------------------------------------------------------+
string trading:: Errors(int id)
  {
   string res="";
   if(ruErr)
     {
      switch(id)
        {
         case 0:
            res=" 湾?铠栳铌. ";
            break;
         case 1:
            res=" 湾?铠栳觇, 眍 疱珞朦蜞?礤桤忮耱屙. ";
            break;
         case 2:
            res=" 吾 铠栳赅. ";
            break;
         case 3:
            res=" 湾镳噔桦 镟疣戾蝠? ";
            break;
         case 4:
            res=" 翌疸钼 皴疴屦 玎?? ";
            break;
         case 5:
            res=" 羊囵? 忮瘃? 觌桢眚耜钽?蝈痨桧嚯? ";
            break;
         case 6:
            res=" 湾?疋玷 ?蝾疸钼 皴疴屦铎. ";
            break;
         case 7:
            res=" 湾漕耱囹铟眍 镳噔. ";
            break;
         case 8:
            res=" 央桫觐?鬣耱 玎镳铖? ";
            break;
         case 9:
            res=" 湾漕矬耱桁? 铒屦圉? 磬痼? 趔黻鲨铐桊钼囗桢 皴疴屦? ";
            break;
         case 64:
            res=" 痒弪 玎犭铌桊钼囗. ";
            break;
         case 65:
            res=" 湾镳噔桦 眍戾?聍弪? ";
            break;
         case 128:
            res=" 锐蝈?耩铌 铈桎囗? 耦忮瘌屙? 皲咫觇. ";
            break;
         case 129:
            res=" 湾镳噔桦? 鲥磬. ";
            break;
         case 130:
            res=" 湾镳噔桦 耱铒? ";
            break;
         case 131:
            res=" 湾镳噔桦 钺? ";
            break;
         case 132:
            res=" 宣眍?玎牮. ";
            break;
         case 133:
            res=" 翌疸钼? 玎镳妁屙? ";
            break;
         case 134:
            res=" 湾漕耱囹铟眍 溴礤?潆 耦忮瘌屙? 铒屦圉梃. ";
            break;
         case 135:
            res=" 皱磬 桤戾龛豚顸. ";
            break;
         case 136:
            res=" 湾?鲥? ";
            break;
         case 137:
            res=" 琉铌屦 玎?? ";
            break;
         case 138:
            res=" 皖恹?鲥睇. ";
            break;
         case 139:
            res=" 勿溴?玎犭铌桊钼囗 ?箧?钺疣徉螓忄弪?. ";
            break;
         case 140:
            res=" 朽琊屮屙?蝾朦觐 镱牦镪? ";
            break;
         case 141:
            res=" 央桫觐?祉钽?玎镳铖钼. ";
            break;
         case 145:
            res=" 填滂翳赅鲨 玎镳妁屙? 蜞?赅?铕溴?耠桫觐?犭桤铌 ?瘥黻? ";
            break;
         case 146:
            res=" 项漶桉蝈爨 蝾疸钼腓 玎?蜞. ";
            break;
         case 147:
            res=" 锐镱朦珙忄龛?溧螓 桉蝈麇龛 铕溴疣 玎镳妁屙?狃铌屦铎. ";
            break;
         case 148:
            res=" 暑腓麇耱忸 铗牮 ?铗腩驽眄 铕溴痤?漕耱桡腩 镳邃咫? 篑蜞眍怆屙眍泐 狃铌屦铎. ";
            break;
         case 149:
            res=" 斟滏桊钼囗桢 玎镳妁屙?";
            break;
         case 150:
            res=" 青镳妁屙?镳噔桦囔?FIFO ";
            break;
         case 4000:
            res=" 湾?铠栳觇. ";
            break;
         case 4001:
            res=" 湾镳噔桦 箨噻囹咫?趔黻鲨? ";
            break;
         case 4002:
            res=" 软溴犟 爨耨桠?- 忭?滂囡噻铐? ";
            break;
         case 4003:
            res=" 湾?镟?蜩 潆 耱尻?趔黻鲨? ";
            break;
         case 4004:
            res=" 襄疱镱腠屙桢 耱尻?镱耠?疱牦瘃桠眍泐 恹珙忄. ";
            break;
         case 4005:
            res=" 袜 耱尻?礤?镟?蜩 潆 镥疱溧麒 镟疣戾蝠钼. ";
            break;
         case 4006:
            res=" 湾?镟?蜩 潆 耱痤觐忸泐 镟疣戾蝠? ";
            break;
         case 4007:
            res=" 湾?镟?蜩 潆 怵屐屙眍?耱痤觇. ";
            break;
         case 4008:
            res=" 湾桧桷栲腓玷痤忄眄? 耱痤赅. ";
            break;
         case 4009:
            res=" 湾桧桷栲腓玷痤忄眄? 耱痤赅 ?爨耨桠? ";
            break;
         case 4010:
            res=" 湾?镟?蜩 潆 耱痤觐忸泐 爨耨桠? ";
            break;
         case 4011:
            res=" 央桫觐?潆桧磬 耱痤赅. ";
            break;
         case 4012:
            res=" 务蜞蝾?铗 溴脲龛 磬 眍朦. ";
            break;
         case 4013:
            res=" 腻脲龛?磬 眍朦. ";
            break;
         case 4014:
            res=" 湾桤忮耱磬 觐爨礓? ";
            break;
         case 4015:
            res=" 湾镳噔桦 镥疱躅? ";
            break;
         case 4016:
            res=" 湾桧桷栲腓玷痤忄眄 爨耨桠. ";
            break;
         case 4017:
            res=" 蔓珙恹 DLL 礤 疣琊屮屙? ";
            break;
         case 4018:
            res=" 湾忸珈铈眍 玎沭箸栩?徼犭桀蝈牦. ";
            break;
         case 4019:
            res=" 湾忸珈铈眍 恹玮囹?趔黻鲨? ";
            break;
         case 4020:
            res=" 蔓珙恹 忭屮龛?徼犭桀蝈黜 趔黻鲨?礤 疣琊屮屙? ";
            break;
         case 4021:
            res=" 湾漕耱囹铟眍 镟?蜩 潆 耱痤觇, 忸玮疣屐铋 桤 趔黻鲨? ";
            break;
         case 4022:
            res=" 谚耱屐?玎?蜞. ";
            break;
         case 4023:
            res=" 署栩梓羼赅 铠栳赅 恹珙忄 DLL-趔黻鲨?";
            break;
         case 4024:
            res=" 马篁疱眄 铠栳赅 ";
            break;
         case 4025:
            res=" 湾?镟?蜩 ";
            break;
         case 4026:
            res=" 湾忮痦 箨噻囹咫?";
            break;
         case 4027:
            res=" 央桫觐?祉钽?镟疣戾蝠钼 纛痨囹桊钼囗? 耱痤觇 ";
            break;
         case 4028:
            res=" 阻耠?镟疣戾蝠钼 镳邂噱?麒耠?镟疣戾蝠钼 纛痨囹桊钼囗? 耱痤觇 ";
            break;
         case 4029:
            res=" 湾忮痦 爨耨桠 ";
            break;
         case 4030:
            res=" 灭圄桕 礤 铗忮鬣弪 ";
            break;
         case 4050:
            res=" 湾镳噔桦铄 觐腓麇耱忸 镟疣戾蝠钼 趔黻鲨? ";
            break;
         case 4051:
            res=" 湾漕矬耱桁铄 珥圜屙桢 镟疣戾蝠?趔黻鲨? ";
            break;
         case 4052:
            res=" 马篁疱眄 铠栳赅 耱痤觐忸?趔黻鲨? ";
            break;
         case 4053:
            res=" 硒栳赅 爨耨桠? ";
            break;
         case 4054:
            res=" 湾镳噔桦铄 桉镱朦珙忄龛?爨耨桠?蜞殪皴痂? ";
            break;
         case 4055:
            res=" 硒栳赅 镱朦珙忄蝈朦耜钽?桧滂赅蝾疣. ";
            break;
         case 4056:
            res=" 锑耨桠?礤耦忪羼蜩禧. ";
            break;
         case 4057:
            res=" 硒栳赅 钺疣犷蜿?汶钺嚯?镥疱戾眄. ";
            break;
         case 4058:
            res=" 秒钺嚯? 镥疱戾眄? 礤 钺磬痼驽磬. ";
            break;
         case 4059:
            res=" 泽黻鲨 礤 疣琊屮屙??蝈耱钼铎 疱骅戾. ";
            break;
         case 4060:
            res=" 泽黻鲨 礤 疣琊屮屙? ";
            break;
         case 4061:
            res=" 硒栳赅 铗镳噔觇 镱黩? ";
            break;
         case 4062:
            res=" 捂桎噱蝰 镟疣戾蝠 蜩镟 string. ";
            break;
         case 4063:
            res=" 捂桎噱蝰 镟疣戾蝠 蜩镟 integer. ";
            break;
         case 4064:
            res=" 捂桎噱蝰 镟疣戾蝠 蜩镟 double. ";
            break;
         case 4065:
            res=" ?赅麇耱忮 镟疣戾蝠?铈桎噱蝰 爨耨桠. ";
            break;
         case 4066:
            res=" 青镳铠屙睇?桉蝾痂麇耜桢 溧眄 ?耦耱?龛?钺眍怆屙?. ";
            break;
         case 4067:
            res=" 硒栳赅 镳?恹镱腠屙梃 蝾疸钼铋 铒屦圉梃. ";
            break;
         case 4068:
            res=" 绣耋瘃 礤 磬殇屙 ";
            break;
         case 4069:
            res=" 绣耋瘃 礤 镱滗屦骅忄弪? ";
            break;
         case 4070:
            res=" 捏犭桕囹 疱耋瘃?";
            break;
         case 4071:
            res=" 硒栳赅 桧桷栲腓玎鲨?镱朦珙忄蝈朦耜钽?桧滂赅蝾疣 ";
            break;
         case 4099:
            res=" 暑礤?羿殡? ";
            break;
         case 4100:
            res=" 硒栳赅 镳?疣犷蝈 ?羿殡铎. ";
            break;
         case 4101:
            res=" 湾镳噔桦铄 桁 羿殡? ";
            break;
         case 4102:
            res=" 央桫觐?祉钽?铗牮 羿殡钼. ";
            break;
         case 4103:
            res=" 湾忸珈铈眍 铗牮?羿殡. ";
            break;
         case 4104:
            res=" 湾耦忪羼蜩禧?疱骅?漕耱箫??羿殡? ";
            break;
         case 4105:
            res=" 丸 钿桧 铕溴?礤 恹狃囗. ";
            break;
         case 4106:
            res=" 湾桤忮耱睇?耔焘铍. ";
            break;
         case 4107:
            res=" 湾镳噔桦 镟疣戾蝠 鲥睇 潆 蝾疸钼铋 趔黻鲨? ";
            break;
         case 4108:
            res=" 湾忮痦 眍戾?蜩赍蜞. ";
            break;
         case 4109:
            res=" 翌疸钼? 礤 疣琊屮屙? 湾钺躅滂祛 怅膻麒螯 铒鲨?朽琊屮栩?耦忮蝽桕?蝾疸钼囹??疋铋耱忄?耧屦蜞. ";
            break;
         case 4110:
            res=" 碾桧睇?镱玷鲨?礤 疣琊屮屙? 湾钺躅滂祛 镳钼屦栩?疋铋耱忄 耧屦蜞. ";
            break;
         case 4111:
            res=" 暑痤蜿桢 镱玷鲨?礤 疣琊屮屙? 湾钺躅滂祛 镳钼屦栩?疋铋耱忄 耧屦蜞. ";
            break;
         case 4200:
            res=" 吾牝 箧?耋耱怏弪. ";
            break;
         case 4201:
            res=" 青镳铠屙?礤桤忮耱眍?疋铋耱忸 钺牝? ";
            break;
         case 4202:
            res=" 吾牝 礤 耋耱怏弪. ";
            break;
         case 4203:
            res=" 湾桤忮耱睇?蜩?钺牝? ";
            break;
         case 4204:
            res=" 湾?桁屙?钺牝? ";
            break;
         case 4205:
            res=" 硒栳赅 觐铕滂磬?钺牝? ";
            break;
         case 4206:
            res=" 湾 磬殇屙?箨噻囗眍?镱漕觏? ";
            break;
         case 4207:
            res=" 硒栳赅 镳?疣犷蝈 ?钺牝铎 ";
            break;
         case 4210:
            res=" 湾桤忮耱眍?疋铋耱忸 沭圄桕?";
            break;
         case 4211:
            res=" 灭圄桕 礤 磬殇屙 ";
            break;
         case 4212:
            res=" 湾 磬殇屙?镱漕觏?沭圄桕?";
            break;
         case 4213:
            res=" 软滂赅蝾?礤 磬殇屙 ";
            break;
         case 4220:
            res=" 硒栳赅 恹犷疣 桧耱痼戾眚?";
            break;
         case 4250:
            res=" 硒栳赅 铗镳噔觇 push-筲邃铎脲龛 ";
            break;
         case 4251:
            res=" 硒栳赅 镟疣戾蝠钼 push-筲邃铎脲龛 ";
            break;
         case 4252:
            res=" 逾邃铎脲龛 玎镳妁屙?";
            break;
         case 4253:
            res=" 央桫觐?鬣耱 玎镳铖?铗覃腙?push-筲邃铎脲龛?";
            break;
         case 5001:
            res=" 央桫觐?祉钽?铗牮 羿殡钼 ";
            break;
         case 5002:
            res=" 湾忮痦铄 桁 羿殡?";
            break;
         case 5003:
            res=" 央桫觐?潆桧眍?桁 羿殡?";
            break;
         case 5004:
            res=" 硒栳赅 铗牮? 羿殡?";
            break;
         case 5005:
            res=" 硒栳赅 疣珈妁屙? 狍翦疣 蝈犟蝾忸泐 羿殡?";
            break;
         case 5006:
            res=" 硒栳赅 箐嚯屙? 羿殡?";
            break;
         case 5007:
            res=" 湾忮痦 蹂礓?羿殡?(羿殡 玎牮 桦?礤 猁?铗牮) ";
            break;
         case 5008:
            res=" 湾忮痦 蹂礓?羿殡?(桧溴犟 蹂礓豚 铗耋蝰蜮箦??蜞犭桷? ";
            break;
         case 5009:
            res=" 脏殡 漕腈屙 猁螯 铗牮 ?綦嚆铎 FILE_WRITE ";
            break;
         case 5010:
            res=" 脏殡 漕腈屙 猁螯 铗牮 ?綦嚆铎 FILE_READ ";
            break;
         case 5011:
            res=" 脏殡 漕腈屙 猁螯 铗牮 ?綦嚆铎 FILE_BIN ";
            break;
         case 5012:
            res=" 脏殡 漕腈屙 猁螯 铗牮 ?綦嚆铎 FILE_TXT ";
            break;
         case 5013:
            res=" 脏殡 漕腈屙 猁螯 铗牮 ?綦嚆铎 FILE_TXT 桦?FILE_CSV ";
            break;
         case 5014:
            res=" 脏殡 漕腈屙 猁螯 铗牮 ?綦嚆铎 FILE_CSV ";
            break;
         case 5015:
            res=" 硒栳赅 黩屙? 羿殡?";
            break;
         case 5016:
            res=" 硒栳赅 玎镨耔 羿殡?";
            break;
         case 5017:
            res=" 朽珈屦 耱痤觇 漕腈屙 猁螯 箨噻囗 潆 溻铊黜 羿殡钼 ";
            break;
         case 5018:
            res=" 湾忮痦 蜩?羿殡?(潆 耱痤觐恹?爨耨桠钼-TXT, 潆 怦艴 漯筱桴-BIN)";
            break;
         case 5019:
            res=" 脏殡 怆弪? 滂疱牝铕桢?";
            break;
         case 5020:
            res=" 脏殡 礤 耋耱怏弪 ";
            break;
         case 5021:
            res=" 脏殡 礤 祛驽?猁螯 镥疱玎镨襦?";
            break;
         case 5022:
            res=" 湾忮痦铄 桁 滂疱牝铕梃 ";
            break;
         case 5023:
            res=" 蔫疱牝铕? 礤 耋耱怏弪 ";
            break;
         case 5024:
            res=" 雨噻囗睇?羿殡 礤 怆弪? 滂疱牝铕桢?";
            break;
         case 5025:
            res=" 硒栳赅 箐嚯屙? 滂疱牝铕梃 ";
            break;
         case 5026:
            res=" 硒栳赅 铟桉蜿?滂疱牝铕梃 ";
            break;
         case 5027:
            res=" 硒栳赅 桤戾礤龛 疣珈屦?爨耨桠?";
            break;
         case 5028:
            res=" 硒栳赅 桤戾礤龛 疣珈屦?耱痤觇 ";
            break;
         case 5029:
            res=" 羊痼牝箴?耦溴疰栩 耱痤觇 桦?滂磬扈麇耜桢 爨耨桠?";
            break;
         default :
            res=" 湾桤忮耱磬 铠栳赅. ";
        }
     }
   else
      res= StringConcatenate(GetLastError());
   int er=GetLastError();
   if(er>0)
      textcom=StringConcatenate(textcom,"\n",__FUNCTION__,Errors(er),"  ",TimeCurrent());
   return(res);
  }
//+------------------------------------------------------------------+
//| Lots                                                             |
//+------------------------------------------------------------------+
double trading:: Lots()
  {
   double res;
   if(!Lot_const)
      res=Lot;
   else
      if(Risk>0.0)
         res=(AccountBalance()/(100.0/Risk))/MarketInfo(_Symbol,MODE_MARGINREQUIRED);
   int er=GetLastError();
   if(er>0)
      textcom=StringConcatenate(textcom,"\n",__FUNCTION__,Errors(er),"  ",TimeCurrent());
   return(res);
  }
//+------------------------------------------------------------------+
//| ChekPar                                                          |
//+------------------------------------------------------------------+
bool trading:: ChekPar(int tip,double oop,double osl,double otp,double op,double sl,double tp,int mod=0)
  {
   bool res=true;
   double pro=0.0,prc=0.0;
   if(MathMod(tip,2.0)==0.0)
     {pro=Ask; prc=Bid;}
   else
     {pro=Bid; prc=Ask;}
   switch(mod)
     {
      case 0:
         switch(tip)
           {
            case 0:
               if(sl>0.0 && !StopLev(prc,sl))
                 {
                  res=false;
                  break;
                 }
               if(tp>0.0 && !StopLev(tp,prc))
                 {
                  res=false;
                  break;
                 }
               break;
            case 1:
               if(sl>0.0 && !StopLev(sl,prc))
                 {
                  res=false;
                  break;
                 }
               if(tp>0.0 && !StopLev(prc,tp))
                 {
                  res=false;
                  break;
                 }
               break;
            case 2:
               if(!StopLev(pro,op))
                 {
                  res=false;
                  break;
                 }
               if(sl>0.0 && !StopLev(op,sl))
                 {
                  res=false;
                  break;
                 }
               if(tp>0.0 && !StopLev(tp,op))
                 {
                  res=false;
                  break;
                 }
               break;
            case 3:
               if(!StopLev(op,pro))
                 {
                  res=false;
                  break;
                 }
               if(sl>0.0 && !StopLev(sl,op))
                 {
                  res=false;
                  break;
                 }
               if(tp>0.0 && !StopLev(op,tp))
                 {
                  res=false;
                  break;
                 }
               break;
            case 4:
               if(!StopLev(op,pro))
                 {
                  res=false;
                  break;
                 }
               if(sl>0.0 && !StopLev(op,sl))
                 {
                  res=false;
                  break;
                 }
               if(tp>0.0 && !StopLev(tp,op))
                 {
                  res=false;
                  break;
                 }
               break;
            case 5:
               if(!StopLev(pro,op))
                 {
                  res=false;
                  break;
                 }
               if(sl>0.0 && !StopLev(sl,op))
                 {
                  res=false;
                  break;
                 }
               if(tp>0.0 && !StopLev(op,tp))
                 {
                  res=false;
                  break;
                 }
               break;
           }
         break;
      case 1:
         switch(tip)
           {
            case 0:
               if(osl>0.0 && !Freez(prc,osl))
                 {
                  res=false;
                  break;
                 }
               if(otp>0.0 && !Freez(otp,prc))
                 {
                  res=false;
                  break;
                 }
               break;
            case 1:
               if(osl>0.0 && !Freez(osl,prc))
                 {
                  res=false;
                  break;
                 }
               if(otp>0.0 && !Freez(prc,otp))
                 {
                  res=false;
                  break;
                 }
               break;
           }
         break;
      case 2:
         if(prc>oop)
           {
            if(!Freez(prc,oop))
              {
               res=false;
               break;
              }
           }
         else
           {
            if(!Freez(oop,prc))
              {
               res=false;
               break;
              }
           }
         break;
      case 3:
         switch(tip)
           {
            case 0:
               if(osl>0.0 && !Freez(prc,osl))
                 {
                  res=false;
                  break;
                 }
               if(otp>0.0 && !Freez(otp,prc))
                 {
                  res=false;
                  break;
                 }
               if(sl>0.0 && !StopLev(prc,sl))
                 {
                  res=false;
                  break;
                 }
               if(tp>0.0 && !StopLev(tp,prc))
                 {
                  res=false;
                  break;
                 }
               break;
            case 1:
               if(osl>0.0 && !Freez(osl,prc))
                 {
                  res=false;
                  break;
                 }
               if(otp>0.0 && !Freez(prc,otp))
                 {
                  res=false;
                  break;
                 }
               if(sl>0.0 && !StopLev(sl,prc))
                 {
                  res=false;
                  break;
                 }
               if(tp>0.0 && !StopLev(prc,tp))
                 {
                  res=false;
                  break;
                 }
               break;
            case 2:
               if(sl>0.0 && !StopLev(op,sl))
                 {
                  res=false;
                  break;
                 }
               if(tp>0.0 && !StopLev(tp,op))
                 {
                  res=false;
                  break;
                 }
               if(!StopLev(pro,op) || !Freez(pro,op))
                 {
                  res=false;
                  break;
                 }
               break;
            case 3:
               if(sl>0.0 && !StopLev(sl,op))
                 {
                  res=false;
                  break;
                 }
               if(tp>0.0 && !StopLev(op,tp))
                 {
                  res=false;
                  break;
                 }
               if(!StopLev(op,pro) || !Freez(op,pro))
                 {
                  res=false;
                  break;
                 }
               break;
            case 4:
               if(sl>0.0 && !StopLev(op,sl))
                 {
                  res=false;
                  break;
                 }
               if(tp>0.0 && !StopLev(tp,op))
                 {
                  res=false;
                  break;
                 }
               if(!StopLev(op,pro) || !Freez(op,pro))
                 {
                  res=false;
                  break;
                 }
               break;
            case 5:
               if(sl>0.0 && !StopLev(sl,op))
                 {
                  res=false;
                  break;
                 }
               if(tp>0.0 && !StopLev(op,tp))
                 {
                  res=false;
                  break;
                 }
               if(!StopLev(pro,op) || !Freez(pro,op))
                 {
                  res=false;
                  break;
                 }
               break;
           }
         break;
     }
   int er=GetLastError();
   if(er>0)
      textcom=StringConcatenate(textcom,"\n",__FUNCTION__,Errors(er),"  ",TimeCurrent());
   return(res);
  }
//+------------------------------------------------------------------+
//| StopLev                                                          |
//+------------------------------------------------------------------+
bool trading:: StopLev(double pr1,double pr2)
  {
   bool res=true;
   long par=SymbolInfoInteger(_Symbol,SYMBOL_TRADE_STOPS_LEVEL);
   if(long(MathCeil((pr1-pr2)/Point))<=par)
      res=false;
   int er=GetLastError();
   if(er>0)
      textcom=StringConcatenate(textcom,"\n",__FUNCTION__,Errors(er),"  ",TimeCurrent());
   return(res);
  }
//+------------------------------------------------------------------+
//| Freez                                                            |
//+------------------------------------------------------------------+
bool trading:: Freez(double pr1,double pr2)
  {
   bool res=true;
   long par=SymbolInfoInteger(_Symbol,SYMBOL_TRADE_FREEZE_LEVEL);
   if(long(MathCeil((pr1-pr2)/Point))<=par)
      res=false;
   int er=GetLastError();
   if(er>0)
      textcom=StringConcatenate(textcom,"\n",__FUNCTION__,Errors(er),"  ",TimeCurrent());
   return(res);
  }
//+------------------------------------------------------------------+
//| StrTip                                                           |
//+------------------------------------------------------------------+
string trading:: StrTip(int tip)
  {
   string name;
   switch(tip)
     {
      case 1:
         name=" Sell ";
         break;
      case 2:
         name=" BuyLimit ";
         break;
      case 3:
         name=" SellLimit ";
         break;
      case 4:
         name=" BuyStop ";
         break;
      case 5:
         name=" SellStop ";
         break;
      default:
         name=" Buy ";
     }
   int er=GetLastError();
   if(er>0)
      textcom=StringConcatenate(textcom,"\n",__FUNCTION__,Errors(er),"  ",TimeCurrent());
   return(name);
  }
//+------------------------------------------------------------------+
//| Err                                                              |
//+------------------------------------------------------------------+
void trading:: Err(int id)
  {
   if(id==6 || id==129 || id==130 || id==136)
      Sleep(5000);
   if(id==128 || id==142 || id==143 || id==4 || id==132)
      Sleep(60000);
   if(id==145)
      Sleep(15000);
   if(id==146)
      Sleep(10000);
   int er=GetLastError();
   if(er>0)
      textcom=StringConcatenate(textcom,"\n",__FUNCTION__,Errors(er),"  ",TimeCurrent());
  }
//+------------------------------------------------------------------+
//| FreeM                                                            |
//+------------------------------------------------------------------+
bool trading:: FreeM(double lot)
  {
   bool res=true;
   if(lot*SymbolInfoDouble(_Symbol,SYMBOL_MARGIN_INITIAL)>AccountFreeMargin())
      res=false;
   if(!res)
      Alert("Not enough money to open a position");
   int er=GetLastError();
   if(er>0)
      textcom=StringConcatenate(textcom,"\n",__FUNCTION__,Errors(er),"  ",TimeCurrent());
   return(res);
  }
//+------------------------------------------------------------------+
//| Dig                                                              |
//+------------------------------------------------------------------+
int trading:: Dig()
  {
   int dig;
   if(_Digits==5 || _Digits==3 || _Digits==1)
      dig=10;
   else
      dig=1;
   int er=GetLastError();
   if(er>0)
      textcom=StringConcatenate(textcom,"\n",__FUNCTION__,Errors(er),"  ",TimeCurrent());
   return(dig);
  }
//+------------------------------------------------------------------+
