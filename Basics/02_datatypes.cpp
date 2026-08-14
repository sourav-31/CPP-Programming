#include <iostream>
using namespace std;
int main() 
{
    int age = 25;
    char grade = 'A';
    float price = 99.69f; /* f/F should be written otherwise
                            it will be taken as double instead of float  */
    double percentage = 89.25;
    bool Result = true; // 1 for true & 0 for false

    cout << age << endl;
    cout << grade << "\n";
    cout << price << endl;
    cout << percentage << endl;
    cout << Result << endl;
}