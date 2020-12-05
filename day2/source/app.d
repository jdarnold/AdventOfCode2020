import std.stdio;
import std.stdio;
import std.file;
import std.conv;
import std.ascii;
import std.range;
import std.regex;


void main()
{
    auto file = File("passwords.txt");
    auto lines = file.byLine();

    auto ctr = ctRegex!(`(\d*)-(\d*) (.): (.*)`);

    struct pwd_rule
    {
        int min_count;
        int max_count;
        char letter;
    }

    int valid_password_count = 0;

    auto vp1 = ( pwd_rule pr, string password ) {
        int pc_count = 0;
        foreach(p;password)
        {
            if ( p == pr.letter )
            {
                ++pc_count;
            }
        }

        if ( pc_count >= pr.min_count && pc_count <= pr.max_count )
            valid_password_count++;
    };

    foreach (lpc; lines)
    {
        auto m = lpc.matchAll(ctr);
        pwd_rule prule;
        prule.min_count = to!int(m.front[1]);
        prule.max_count = to!int(m.front[2]);
        prule.letter = m.front[3][0];
        auto password = m.front[4];
        vp1(prule,to!string(password));
    }

    printf("Valid passwords for rule #1: %d\n", valid_password_count);

    valid_password_count= 0;
    auto vp2 = ( pwd_rule pr, string password ) {

        //writeln("Checking "~password);
        if ( password.length < pr.min_count )
        {
            writefln("Skipping %s cuz %d",password,pr.min_count);
            return;
        }
        const bool p1 = password[pr.min_count-1] == pr.letter;
        bool p2 = false;
        if ( password.length >= pr.max_count )
        {
            p2 = password[pr.max_count-1] == pr.letter;
        }

        if ( (p1 && !p2) || (!p1 && p2) )
        {
            valid_password_count++;
        }
    };

    file.rewind();
    lines = file.byLine();

    foreach (lpc2; lines)
    {
        auto m = lpc2.matchAll(ctr);
        pwd_rule prule;
        prule.min_count = to!int(m.front[1]);
        prule.max_count = to!int(m.front[2]);
        prule.letter = m.front[3][0];
        auto password = m.front[4];
        vp2(prule,to!string(password));
    }

    printf("Valid passwords for rule #2: %d\n", valid_password_count);


}
