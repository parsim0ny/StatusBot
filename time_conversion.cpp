// Creates timeConvert executable that is called from bot.sh

#include <iostream>
#include <fstream>

using namespace std;

int main()
{
    int idle_time = 0;

    ifstream inFile;
    inFile.open("idle_seconds.txt");
    inFile >> idle_time;

    int days = idle_time / 60 / 60 / 24;
    int hours = (idle_time / 60 / 60) % 24;
    int minutes = (idle_time / 60) % 60;
    int seconds = idle_time % 60;

    cout << days << " days, " << hours << " hours, "
        << minutes << " minutes, " << seconds << " seconds.";

    inFile.close();
    return 0;
}
