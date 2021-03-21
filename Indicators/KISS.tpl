<chart>
id=132058661983956442
comment=MACD����Ҫ=[-0.8]���ź�=[-0.3]
symbol=XAUUSD
period=60
leftpos=21219
digits=2
scale=8
graph=1
fore=1
grid=0
volume=0
scroll=1
shift=1
ohlc=1
one_click=1
one_click_btn=1
askline=1
days=1
descriptions=0
shift_size=15
fixed_pos=0
window_left=0
window_top=0
window_right=408
window_bottom=165
window_type=3
background_color=0
foreground_color=16777215
barup_color=65280
bardown_color=65280
bullcandle_color=0
bearcandle_color=16777215
chartline_color=65280
volumes_color=3329330
grid_color=10061943
askline_color=255
stops_color=255

<window>
height=208
fixed_height=0
<indicator>
name=main
<object>
type=1
object_name=Horizontal Line 20201
period_flags=0
create_time=1524190953
color=255
style=0
weight=1
background=0
filling=0
selectable=1
hidden=0
zorder=0
value_0=151.195333
</object>
<object>
type=2
object_name=lnYesterdayOpen
period_flags=0
create_time=1568683908
color=8421504
style=2
weight=1
background=0
filling=0
selectable=1
hidden=0
zorder=0
time_0=1568768400
value_0=1501.340000
time_1=1568916000
value_1=1501.340000
ray=1
</object>
<object>
type=2
object_name=lnYesterdayClose
period_flags=0
create_time=1568683908
color=8421504
style=2
weight=1
background=0
filling=0
selectable=1
hidden=0
zorder=0
time_0=1568768400
value_0=1493.670000
time_1=1568916000
value_1=1493.670000
ray=1
</object>
<object>
type=2
object_name=lnDayPP
period_flags=0
create_time=1568683908
color=255
style=0
weight=1
background=0
filling=0
selectable=1
hidden=0
zorder=0
time_0=1568854800
value_0=1496.226667
time_1=1568916000
value_1=1496.226667
ray=1
</object>
<object>
type=2
object_name=lnDayS1
period_flags=0
create_time=1568683908
color=255
style=1
weight=1
background=0
filling=0
selectable=1
hidden=0
zorder=0
time_0=1568854800
value_0=1480.893333
time_1=1568916000
value_1=1480.893333
ray=1
</object>
<object>
type=2
object_name=lnDayR1
period_flags=0
create_time=1568683908
color=255
style=1
weight=1
background=0
filling=0
selectable=1
hidden=0
zorder=0
time_0=1568854800
value_0=1509.003333
time_1=1568916000
value_1=1509.003333
ray=1
</object>
<object>
type=23
object_name=lblTimer
period_flags=0
create_time=1568906926
description=XAUUSD����ʣ�ࣺ29��32��
color=32768
font=Arial
fontsize=10
angle=0
anchor_pos=0
background=0
filling=0
selectable=1
hidden=0
zorder=0
corner=1
x_distance=200
y_distance=40
</object>
<object>
type=23
object_name=lblTrend
period_flags=0
create_time=1568906926
description=4H MACD����ͷ��
color=255
font=Arial
fontsize=10
angle=0
anchor_pos=0
background=0
filling=0
selectable=1
hidden=0
zorder=0
corner=1
x_distance=200
y_distance=60
</object>
<object>
type=23
object_name=lblMaGroup
period_flags=0
create_time=1568906926
description=1H�����飺��~
color=255
font=Arial
fontsize=10
angle=0
anchor_pos=0
background=0
filling=0
selectable=1
hidden=0
zorder=0
corner=1
x_distance=200
y_distance=80
</object>
<object>
type=23
object_name=lblAuthor
period_flags=0
create_time=1568906926
description=���ߣ����������@Aother
color=8421504
font=Arial
fontsize=10
angle=0
anchor_pos=0
background=0
filling=0
selectable=1
hidden=0
zorder=0
corner=1
x_distance=200
y_distance=100
</object>
<object>
type=23
object_name=lblAdvice
period_flags=0
create_time=1568906926
description=
color=255
font=Arial
fontsize=10
angle=0
anchor_pos=0
background=0
filling=0
selectable=1
hidden=0
zorder=0
corner=3
x_distance=16
y_distance=20
</object>
</indicator>
<indicator>
name=Moving Average
period=60
shift=0
method=0
apply=0
color=16711680
style=0
weight=1
period_flags=0
show_data=1
</indicator>
<indicator>
name=Moving Average
period=37
shift=0
method=0
apply=0
color=9639167
style=0
weight=1
period_flags=0
show_data=1
</indicator>
<indicator>
name=Custom Indicator
<expert>
name=ZigZag
flags=275
window_num=0
<inputs>
InpDepth=12
InpDeviation=5
InpBackstep=3
</inputs>
</expert>
shift_0=0
draw_0=1
color_0=255
style_0=0
weight_0=0
period_flags=0
show_data=1
</indicator>
</window>

<window>
height=40
fixed_height=0
<indicator>
name=MACD
fast_ema=12
slow_ema=26
macd_sma=9
apply=0
color=16777215
style=0
weight=1
signal_color=16711680
signal_style=0
signal_weight=1
levels_color=16777215
levels_style=0
levels_weight=1
level_0=0.00000000
period_flags=480
show_data=1
</indicator>
<indicator>
name=Moving Average
period=1
shift=0
method=0
apply=7
color=16777215
style=0
weight=1
period_flags=0
show_data=1
</indicator>
</window>

<window>
height=41
fixed_height=0
<indicator>
name=Stochastic Oscillator
kperiod=5
dperiod=3
slowing=3
method=0
apply=0
color=11186720
style=0
weight=1
color2=255
style2=2
weight2=1
min=0.00000000
max=100.00000000
levels_color=12632256
levels_style=2
levels_weight=1
level_0=20.00000000
level_1=80.00000000
period_flags=0
show_data=1
</indicator>
</window>

<expert>
name=KISS
flags=275
window_num=0
</expert>
</chart>
