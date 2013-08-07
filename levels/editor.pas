program leveleditor;
uses crt,sysutils;
var x,y: byte;
	map: array [1..20,1..20] of byte;
	c: char;
	xx,yy: integer;
	dx,dy: integer;
	f: text;
        filename: string;
	

procedure fajl;
begin
    writeln('Level number?');
    readln(filename);

    if (FileExists(filename)) then begin
    assign(f,filename);
    reset(f);
    while (not eof(f)) do
    begin
     readln(f,xx,c,yy,c,x);
     map[xx,yy] := x;

    end;
    close(f);

    clrscr;

    for xx:=1 to 20 do begin

        for yy:=1 to 20 do begin
        gotoxy(xx,yy);
               case map[xx,yy] of
                0: begin write(' '); end;
            1: begin write(#178); end;
            2: begin write(#176); end;
            3: begin write(#3); end;
            4: begin write(#1); end;
            end;

        end;

    end;
    end
    else
    begin
    clrscr;
    for xx := 1 to 20 do begin
	for yy := 1 to 20 do begin

	map[xx,yy] := 0;

	end;
        end;
      end;

end;

procedure kiir;
begin
x:=1;
y:=1;

for yy := 1 to 20 do begin
	gotoxy(21,yy);
	write(#124);
end;

for xx := 1 to 20 do begin
	gotoxy(xx,21);
	write(#45);
end;
end;

procedure help;
begin

gotoxy(22,1);
writeln('Object types:');
gotoxy(22,2);
writeln('0: nothing');
gotoxy(22,3);
writeln('1: solid brick');
gotoxy(22,4);
writeln('2: breakable brick');
gotoxy(22,5);
writeln('3: level exit');
gotoxy(22,6);
writeln('4: spawnpoint');

end;

procedure mozog;
begin

dx := 0;
dy := 0;

if ord(c) = 0 then c := readkey;

case c of
	#72: begin dx:=0; dy:=-1; end;
	#80: begin dx:=0; dy:=1; end;
	#75: begin dx:=-1; dy:=0; end;
	#77: begin dx:=1; dy:=0; end;
end;
x:=x+dx;
y:=y+dy;

if x=0 then x:=1;
if x=21 then x:=20;
if y=0 then y:=1;
if y=21 then y:=20;

gotoxy(x,y);
end;

procedure erzekel;
begin

case c of
	#48: begin map[x,y] := 0; write(' '); gotoxy(x,y); end;
	#49: begin map[x,y] := 1; write(#178); gotoxy(x,y); end;
	#50: begin map[x,y] := 2; write(#176); gotoxy(x,y); end;
	#51: begin map[x,y] := 3; write(#3); gotoxy(x,y); end;
	#52: begin map[x,y] := 4; write(#1); gotoxy(x,y); end;
end;

gotoxy(22,7);
writeln('Selected coordinates: ',x,', ',y,' [',map[x,y],']   ');
gotoxy(x,y);

end;

procedure compile;
begin
assign(f,filename);
    rewrite(f);

for xx := 1 to 20 do begin

for yy := 1 to 20 do begin

writeln(f,xx,' ',yy,' ',map[xx,yy]);

end;

end;

close(f);

end;

begin
clrscr;
fajl;
kiir;
help;
repeat
c := readkey;
mozog;
erzekel;
until((c = #13) or (c = #27));
compile;
end.
