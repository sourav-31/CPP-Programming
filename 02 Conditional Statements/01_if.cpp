#include <iostream>
using namespace std;

int main()
{
    int age;
    cout << " Please enter your age: \n";
    cin >> age;
    if (age >= 18)
    {
        cout << "You're Eligible to vote\n";
    } else
    {
        cout << "You're not Eligible to vote\n";
    }

    return 0;
}