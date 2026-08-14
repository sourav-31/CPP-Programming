#include <iostream>
using namespace std;

int main() {
    double percentage = 80.55;
    int SGPA = percentage/10; // this will convert double into int (8 byte to 4 byte)
    cout<<percentage<<endl;
    cout<<SGPA<<endl;
    return 0;
}
//similarly we can convert other datatypes into another datatype eg. int to char, etc.
// any datatype can convert to another by using this syntax:
// int to double --> (double)2 --> it will convert 2(int) into 2.00(double)