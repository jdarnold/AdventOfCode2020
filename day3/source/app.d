import std.stdio;
import std.file;

int slope_x=0;
int slope_y=0;

void ridesled(ref char[][]terrain, ref int trees, long x, long y)
{
    //writefln("Checking %d, %d",x,y);

    if (x >= terrain[y].length)
        x = x % terrain[y].length;

    if (terrain[y][x] == '#')
    { // we hit a tree!
        ++trees;
    }

    y += slope_y;
    if ( y < terrain.length )
        ridesled(terrain, trees, x + slope_x, y);
}

void main()
{
    auto f = File("terrain.txt");
    auto map = f.byLine();

    char[][] terrain;
    int x = 0;
    int y = 0;
    foreach (row; map)
    {
        terrain.length++;
        x = 0;
        terrain[y] = new char[row.length];
        foreach (space; row)
        {
            //writefln("%d %d",x,y);
            terrain[y][x] = space;
            ++x;
        }
        ++y;
    }

    long sledx = 0;
    long sledy = 0;
    int trees = 0;

    slope_x = 3;
    slope_y = 1;
    ridesled(terrain, trees, sledx, sledy);
    writefln("# of trees for slope %d,%d: %d", slope_x, slope_y, trees);
    long total_trees = trees;

    slope_x = 1;
    slope_y = 1;
    sledx = sledy = trees = 0;
    ridesled(terrain, trees, sledx, sledy);
    writefln("# of trees for slope %d,%d: %d", slope_x, slope_y, trees);
    total_trees *= trees;
    
    slope_x = 7;
    slope_y = 1;
    sledx = sledy = trees = 0;
    ridesled(terrain, trees, sledx, sledy);
    writefln("# of trees for slope %d,%d: %d", slope_x, slope_y, trees);
    total_trees *= trees;

    slope_x = 5;
    slope_y = 1;
    sledx = sledy = trees = 0;
    ridesled(terrain, trees, sledx, sledy);
    writefln("# of trees for slope %d,%d: %d", slope_x, slope_y, trees);
    total_trees *= trees;

    slope_x = 1;
    slope_y = 2;
    sledx = sledy = trees = 0;
    ridesled(terrain, trees, sledx, sledy);
    writefln("# of trees for slope %d,%d: %d", slope_x, slope_y, trees);
    total_trees *= trees;

    writefln("Total number of trees: %d", total_trees);
}
