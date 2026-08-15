#include <iostream>
using namespace std;

int main() {
    char c;
    cout << "Enter a Character: ";
    cin >> c;
    if (c>=65 && c<97)
    {
        cout << "Character is Uppercase\n";
    }
    else if (97<=c && c<123)
    {
        cout << "Character is Lowercase\n";
    }
    else
    {
        cout << "Please enter a character from Alphabet\n";
    }
    return 0;
}