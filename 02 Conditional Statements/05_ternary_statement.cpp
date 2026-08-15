#include <iostream>
using namespace std;

int main()
{
    int n;
    cout << "Enter any integer: ";
    cin >> n;
    n >= 0 ? cout << n << " is positive\n" : cout << n << " is negative\n";
    return 0;
}