program bomberman;

uses crt, sysutils;

var map: array [1..20, 1..20] of byte;  //osszes pixel tombje
    x, y: integer;                      //fej koordinatai
    dx, dy: integer;                    //mozgasi valtozok
    bx, by: integer;                    //bomba koordinatai
    lx, ly: integer;                    //level up koordinatai
    timer: integer;                     //bomba idomeroje
    bsz: integer;                       //bomba szamlalo
    i, j: integer;                      //ciklusvaltozok
    prev: byte;                         //bomba visszaallito valtozo
    f: text;                            //map fajlvaltozoja
    filename: string;                   //map fajlneve
    gameover: byte;                     //jatek vegenek valtozoja
    tempx, tempy, tempd: byte;          //ideiglenes valtozok beolvasashoz
    xx, yy: integer;                    //ciklusvaltozok
    altx, alty: integer;                //egyeb ideiglenes valtozok
    c: char;                            //beolvasott karakter
    ccopy: char;                        //beolvasott karakter masolata
    rep: char;                          //meg egy karakter
    level: integer;                     //level szamlalo
    level2: string;                     //level szamlalo pt2

//procedures

procedure prepare;
begin

    clrscr;
    level2 := IntToStr(level);
    filename := 'levels/level' + level2 + '.lvl';

    assign(f, filename);
    reset(f);

    //koordinatak beolvasasa a fajlbol
    while (not eof(f)) do begin

        readln(f, tempx, c, tempy, c, tempd);

        //specialis helyek keresese
        if (tempd = 3) then begin

            lx := tempx;
            ly := tempy;

        end;

        if (tempd = 4) then begin

            x := tempx;
            y := tempy;
            tempd := 0;

        end;

        map[tempx, tempy] := tempd;

    end;

    //keret megrajzolasa
    for xx := 1 to 20 do begin

        gotoxy(xx, 21);
        write(#124);

    end;

    for yy := 1 to 20 do begin

        gotoxy(21, yy);
        write(#124);

    end;

    //objektumok berajzolasa
    for xx := 1 to 20 do begin

        for yy := 1 to 20 do begin

            gotoxy(xx, yy);

            case map[xx, yy] of

                0: write(' ');
                1: begin textcolor(black); write(#178); textcolor(white); end;
                2: begin textcolor(blue); write(#176); textcolor(white); end;
                3: begin textcolor(red); write(#3); textcolor(white); end;
                4: begin textcolor(yellow); write(#2); textcolor(white); end;

            end;

        end;

    end;

    close(f);

    //valtozo nullazasok
    gameover := 0;
    prev := 0;
    bsz := 0;
    dx := 0;
    dy := 0;
    c := #119;

end;

procedure deleti;
begin

    gotoxy(x, y);
    if (map[x, y] = 5) then write(#15) else write(' ');

end;

procedure moving;
begin

    ccopy := c;

    if keypressed then begin

        c := readkey;

        if (ord(c) = 0) then c := readkey;

    end;

    deleti;

    case c of

        #72: begin dx := 0; dy := -1; end;
        #80: begin dx := 0; dy := 1; end;
        #75: begin dx := -1; dy := 0; end;
        #77: begin dx := 1; dy := 0; end;

    end;

    x := x + dx;
    y := y + dy;

    if (x = 0) then x := 1;
    if (x = 21) then x := 20;
    if (y = 0) then y := 1;
    if (y = 21) then y := 20;

    if (map[x, y] = 1) or (map[x, y] = 2) then begin

        x := x - dx;
        y := y - dy;

    end;

    gotoxy(x, y);

end;

procedure writi;
begin

    gotoxy(x, y);
    textcolor(yellow); write(#2); textcolor(white);
    gotoxy(x, y);

end;

procedure bomb;
begin

    if (ord(c) = 32) and (bsz = 0) then begin

        gotoxy(x, y);
        c := ccopy;
        map[x, y] := 5;
        bx := x;
        by := y;
        write(#15);
        bsz := 1;
        timer := 6;

    end;

end;

procedure explosioneffect(altx: integer; alty: integer);
begin

    if ((altx <> 0) and (altx <> 21) and (alty <> 0) and (alty <> 21)) then begin

        if ((altx = x) and (alty = y)) then gameover := 1;

        case map[altx, alty] of

            0: begin gotoxy(altx, alty); write(' '); end; //nothing
            1: begin gotoxy(altx, alty); write(#178); end; //solid brick
            2: begin gotoxy(altx, alty); map[altx, alty] := 0; write(' '); end; //broken brick
            3: begin gotoxy(altx, alty); write(#3); end; //level exit

        end;

    end;

end;

procedure flash(altx: integer; alty: integer);
begin

    if ((altx <> 0) and (altx <> 21) and (alty <> 0) and (alty <> 21)) then begin

        gotoxy(altx, alty); write(#219);

    end;

end;

procedure explode;
begin

    //visszaszamlalas
    if (bsz = 1) then begin
        timer := timer - 1;

        //robbanas masodik resze
        if (prev = 1) then begin

            for i:= -1 to 1 do begin

                for j:= -1 to 1 do begin

                    altx := bx + i;
                    alty := by - j;
                    explosioneffect(altx, alty);

                end;

            end;

            prev := 0;
            bsz := 0;

        end;

        //robbanas elso resze
        if (timer = 0) then begin

            for i:= -1 to 1 do begin

                for j:= -1 to 1 do begin

                    altx := bx + i;
                    alty := by - j;
                    flash(altx, alty);

                end;

            end;

            map[bx, by] := 0;
            prev := 1;
            gotoxy(x, y);

        end;

    end;

end;

procedure ending;
begin

    clrscr;

    case gameover of

        0: writeln('Thanks for playing!');
        1: writeln('Better luck next time!');
        2: begin writeln('Level up!'); level := level + 1; end;

    end;

    rep := readkey;

end;

begin

    CursorOff;
    textbackground(green);

    level := 0;

    repeat

        prepare;

        repeat

            moving;
            writi;
            bomb;
            explode;

            if (lx = x) and (ly = y) then gameover := 2;

            delay(100);

        until(c = #27) or (gameover <> 0);

        ending;

    until(rep = #27);

    textbackground(black);
    CursorOn;

end.
