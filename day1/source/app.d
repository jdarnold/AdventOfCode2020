import std.stdio;
import std.file;
import std.conv;
import std.ascii;

void main()
{
    const auto expenses = std.file.readText("expenses.txt");
    string strExpense;
    int[] intExpense;
    foreach (ec; expenses)
    {

        if ( !isDigit(ec) )
        {
            if ( strExpense.length > 0 )
            {
                //write("'"~strExpense~"' = ");
                auto expense = to!int(strExpense);
                //writeln(expense);
                intExpense = intExpense ~ expense;
                strExpense = "";

            }
        } else {
            strExpense = strExpense ~ ec;
        }    
    }

outter:    foreach (int ie; intExpense)
    {
        foreach (int ie2; intExpense)
        {
            if ( (ie+ie2) == 2020 )
            {
                printf("%d+%d=2020\n",ie,ie2);
                printf("%d*%d= %d\n",ie,ie2,ie*ie2);
                break outter;
            }
        }
    }

outter2:    foreach (int ie; intExpense)
    {
        foreach (int ie2; intExpense)
        {
            foreach (int ie3; intExpense)
            {
                if ( (ie+ie2+ie3) == 2020 )
                {
                    printf("%d+%d+%d=2020\n",ie,ie2,ie3);
                    printf("%d*%d*%d= %d\n",ie,ie2,ie3,ie*ie2*ie3);
                    break outter2;
                }
                
            }
        }
    }

}
