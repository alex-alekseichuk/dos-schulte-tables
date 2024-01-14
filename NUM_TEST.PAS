Uses Crt,Dos,Graph,Mouse;

Const X0 = 30;  { Main Rect }
      Y0 = 30;
      dx = 70;
      dy = 70;

      PUSH = 1;
      POP  = 0;

      Xl   = 430;  { Number Rect }
      Yl   = 20;

      Xt   = 20;    { Time Rect }
      Yt   = 440;

      PixelsPerSec = 5 ;


Const GrDr : Integer = 0 ;
   Current : Byte    = 1 ;
      TTime : Word    = 0 ;
Var   GrMd : Integer ;
   xb,yb,i : Byte;
       x,y : Integer;
       ManName : String [80];

    b_H,b_M,b_S,b_ss : Word;

    t_H,t_M,t_S,t_s100 : Word;  { Время на начало }
        tH,tM,tS,tS100 : Word;  { Время на end }


Type Kletka = record
        n:Byte;
        s:String [3];
      end;

Var A : Array [1..25] of Kletka ;
    M : Array [1..5,1..5] of Kletka Absolute A;


Function Timer(h1,m1,s1,ss1,h2,m2,s2,ss2:Word) : Real;
begin
  Timer := ((ss2 + s2*100 + m2*6000 + h2*360000) -
            (ss1 + s1*100 + m1*6000 + h1*360000)) /100 ;
end;


Procedure Sorting;
Var r:array [1..25] of byte;
    t,ii,i,j:Byte;  k:Kletka;
begin
  for ii:=1 to 7 do begin
    for i:=1 to 25 do r[i]:=random(100);
    for i:=1 to 24 do
      for j:=i+1 to 25 do
        if r[i]<r[j] then begin
          t:=r[i];r[i]:=r[j];r[j]:=t;k:=A[i];A[i]:=A[j];A[j]:=k
        end
  end
end;

Procedure Recter(x1,y1,x2,y2:Word);
begin
  setfillstyle(1,7);bar(x1-10,y1-10,x2+10,y2+10);
  setcolor(0);line(x1,y1,x2,y1);line(x1,y1,x1,y2);
  setcolor(15);line(x1,y2,x2,y2);line(x2,y1,x2,y2);
end;

Procedure ShowNumber;
Var s:String[3];
begin recter(xl,yl,xl+70,yl+70);
settextstyle(1,0,5);
str(Current,s);
setcolor(8);
if Current > 9 then outtextxy(xl+11,yl+11,s)
               else outtextxy(xl+26,yl+11,s);
setcolor(15);
if Current > 9 then outtextxy(xl+10,yl+10,s)
               else outtextxy(xl+25,yl+10,s);
settextstyle(0,0,0);
end;


Procedure PopKletka(x,y:Byte);
begin
  setfillstyle(1,7);bar(x0+(x-1)*dx,y0+(y-1)*dy,x0+(x)*dx-1,y0+(y)*dy-1);
  setcolor(15);
  line(x0+(x-1)*dx,y0+(y-1)*dy,x0+(x-1)*dx,y0+(y)*dy-1);
  line(x0+(x-1)*dx,y0+(y-1)*dy,x0+(x)*dx-1,y0+(y-1)*dy);
  setcolor(0);
  line(x0+(x)*dx-1,y0+(y)*dy-1,x0+(x-1)*dx,y0+(y)*dy-1);
  line(x0+(x)*dx-1,y0+(y)*dy-1,x0+(x)*dx-1,y0+(y-1)*dy);
  settextstyle(1,0,5);
  if M[x,y].n > 9 then outtextxy(x0+(x-1)*dx+10,y0+(y-1)*dy+10,M[x,y].s)
                  else outtextxy(x0+(x-1)*dx+25,y0+(y-1)*dy+10,M[x,y].s);
  settextstyle(0,0,0);
end;


Procedure PushKletka(x,y:Byte);
begin
  setfillstyle(1,7);bar(x0+(x-1)*dx,y0+(y-1)*dy,x0+(x)*dx-1,y0+(y)*dy-1);
  setcolor(0);
  line(x0+(x-1)*dx,y0+(y-1)*dy,x0+(x-1)*dx,y0+(y)*dy-1);
  line(x0+(x-1)*dx,y0+(y-1)*dy,x0+(x)*dx-1,y0+(y-1)*dy);
  setcolor(15);
  line(x0+(x)*dx-1,y0+(y)*dy-1,x0+(x-1)*dx,y0+(y)*dy-1);
  line(x0+(x)*dx-1,y0+(y)*dy-1,x0+(x)*dx-1,y0+(y-1)*dy);
  setcolor(10);  settextstyle(1,0,5);
  if M[x,y].n > 9 then outtextxy(x0+(x-1)*dx+11,y0+(y-1)*dy+11,M[x,y].s)
                  else outtextxy(x0+(x-1)*dx+26,y0+(y-1)*dy+11,M[x,y].s);
  settextstyle(0,0,0);
end;


Procedure ShowField;
Var x,y:Byte;
begin
  settextstyle(1,0,5);setcolor(0);
  for x:=1 to 5 do
    for y:=1 to 5 do
      PopKletka(x,y);
end;


Function InSide(x,y,x1,y1,x2,y2:Word):Boolean;
begin
  if (x>=x1) and (x<=x2) and (y>=y1) and  (y<=y2)  then InSide:=True
                                                   else InSide:=False;
end;


Procedure CheckTime(mouse:Byte);
begin
  GetTime(tH,tM,tS,tS100);
  if Timer(t_h,t_m,t_s,t_s100,th,tm,ts,ts100)>=(1/PixelsPerSec) then begin
    t_h:=th;t_m:=tm;t_s:=ts;t_s100:=ts100;
    if mouse=1 then MouseOff;
	setcolor(4);line(xt+ttime,yt+1,xt+ttime,yt+9);ttime:=ttime+1;
    if mouse=1 then MouseOn;
  end;
end;

Procedure NewClient;
begin
  recter(x0-10,y0-10,x0+5*dx+10,y0+5*dy+10);Sorting;ShowField;
  TTime:=0;
  Current:=1;ShowNumber;
  recter(xt,yt,xt+600,yt+10);

  GetTime(b_H,b_M,b_S,b_sS);
end;


var f : Text;
	TSR : SearchRec;
    ATTr:Word;
	b:Boolean;
	key:Char;

BEGIN   Randomize;
for i:=1 to 25 do begin  A[i].n:=i;str(i,A[i].s) end;


InitGraph(GrDr,GrMd,'..\BGI'); b:=InitMouse;
SetFillStyle(8,3);Bar(0,0,getmaxx,getmaxy);





NewClient;

MouseOn;
GetTime(t_H,t_M,t_S,t_S100);
repeat CheckTime(1);
  if GetMouse(x,y) > 0 then
    if InSide(x,y,x0,y0,x0+5*dx,y0+5*dy) then begin
      xb := (x-x0) div dx + 1;
      yb := (y-y0) div dy + 1;
      if M[xb,yb].n = Current then begin
        mouseOFF;
        PushKletka(xb,yb);
        repeat CheckTime(0); Until GetMouse(x,y) = 0 ;
        PopKletka(xb,yb);
        Current:=Current+1;ShowNumber;
        MouseON;
      end;
    end;
    if keypressed then begin key:=ReadKey;if key=#0 then key:=ReadKey end
    else Key:=#0;
until (Key=#27) OR (Current > 25) or (TTime=600);
if Key=#0 then begin { Ender }
  assign(f,'Results.txt');findfirst('Results.txt',ATTR,TSR);
  if DosError=0 then append(f) else rewrite(f);

  if ParamCount>0 then ManName:=ParamStr(1) else ManName:='Unknown';
  if Current>25 then writeln(f,ManName,'  ',Timer(b_h,b_m,b_s,b_ss,th,tm,ts,ts100):10:5,'  сек.')
				else writeln(f,ManName,'  --- Очень Плохо ---');

  close(f);
end;
MouseOff;CloseGraph;
END.
