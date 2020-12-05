import std.stdio;
import std.file;
import std.array;
import std.conv;
import std.regex;

bool valid_byr(string byr)
{
    if (byr.empty || byr.length != 4)
        return false;

    try
    {
        const int birthYear = to!int(byr);

        if (birthYear < 1920 || birthYear > 2002)
            return false;
    }
    catch (Exception exc)
    {
        return false;
    }

    return true;
}

bool valid_pid(string pid)
{
    if (pid.length != 9)
        return false;
    try
    {
        int v = to!int(pid);
    }
    catch (Exception exc)
    {
        return false;
    }

    return true;
}

bool valid_iyr(string iyr)
{
    if (iyr.empty || iyr.length != 4)
        return false;
    try
    {
        const int issueYear = to!int(iyr);

        if (issueYear < 2010 || issueYear > 2020)
            return false;
    }
    catch (Exception exc)
    {
        return false;
    }

    return true;
}

bool valid_eyr(string eyr)
{
    if (eyr.empty || eyr.length != 4)
        return false;

    try
    {
        const int expYear = to!int(eyr);

        if (expYear < 2020 || expYear > 2030)
            return false;
    }
    catch (Exception exc)
    {
        return false;
    }

    return true;
}

bool valid_hgt(string hgt)
{

    if (hgt.length < 4 || hgt.length > 5)
        return false;

    const auto msys = hgt[$ - 2 .. $];
    if (msys == "cm")
    {
        if (hgt.length != 5)
            return false;

        const auto s_height = hgt[0 .. 3];
        try
        {
            const auto height = to!int(s_height);
            if (height < 150 || height > 193)
                return false;
        }
        catch (Exception exc)
        {
            return false;
        }
    }
    else if (msys == "in")
    {
        if (hgt.length != 4)
            return false;

        const auto sin_height = hgt[0 .. 2];
        try
        {
            const auto inheight = to!int(sin_height);
            if (inheight < 59 || inheight > 76)
                return false;
        }
        catch (Exception exc)
        {
            return false;
        }
    }
    else
        return false;

    return true;
}

bool valid_hcl(string hcl)
{
    if (hcl.empty)
        return false;

    auto hclReg = ctRegex!(`\#(([a-f]|[0-9])*)`);

    auto m = hcl.matchAll(hclReg);
    if (m.front.empty || m.front[1].length != 6)
        return false;

    return true;
}

bool valid_ecl(string ecl)
{
    if (ecl.empty)
        return false;

    if (ecl == "amb" || ecl == "blu" || ecl == "brn" || ecl == "gry" || ecl == "grn"
            || ecl == "hzl" || ecl == "oth")
        return true;

    return false;
}

void main()
{
    auto f = File("passports.txt");
    auto lines = f.byLine();

    //auto ctr = ctRegex!(`(.+?):(.+?) `);

    struct Passport
    {
        string byr; // (Birth Year)
        string iyr; // (Issue Year)
        string eyr; // (Expiration Year)
        string hgt; // (Height)
        string hcl; // (Hair Color)
        string ecl; // (Eye Color)
        string pid; // (Passport ID)
        string cid; // (Country ID)
        bool valid;
    }

    Passport[] passports;

    Passport* passport = new Passport;
    int validPassportCount = 0;
    int passportCount = 0;

    auto CheckPassport = () {
        if (valid_byr(passport.byr) && valid_iyr(passport.iyr)
                && valid_eyr(passport.eyr) && valid_hgt(passport.hgt)
                && valid_hcl(passport.hcl) && valid_ecl(passport.ecl) && valid_pid(passport.pid))
        { // valid passport. cid is optional
            ++validPassportCount;
        }

    };

    foreach (line; lines)
    {
        //writeln(line);
        auto fields = line.split();

        if (fields.empty())
        { // check passport
            ++passportCount;
            writeln("Checking passport #", passportCount);
            CheckPassport();
            passport = new Passport;
        }
        else
        {
            foreach (field; fields)
            {
                auto vals = field.split(':');
                //writeln(vals);
                switch (vals[0])
                {
                case "byr": // (Birth Year)
                    passport.byr = to!string(vals[1]);
                    break;
                case "iyr": // (Issue Year)
                    passport.iyr = to!string(vals[1]);
                    break;
                case "eyr": // (Expiration Year)
                    passport.eyr = to!string(vals[1]);
                    break;
                case "hgt": // (Height)
                    passport.hgt = to!string(vals[1]);
                    break;
                case "hcl": // (Hair Color)
                    passport.hcl = to!string(vals[1]);
                    break;
                case "ecl": // (Eye Color)
                    passport.ecl = to!string(vals[1]);
                    break;
                case "pid":
                    passport.pid = to!string(vals[1]);
                    break;
                case "cid":
                    passport.cid = to!string(vals[1]);
                    break;
                default:
                    writefln("Unknown fld: %s", vals[0]);
                    break;

                }
            }
        }

    }

    // Check one more time, just in case
    CheckPassport();

    writeln("Valid Passport count = ", validPassportCount);
}
