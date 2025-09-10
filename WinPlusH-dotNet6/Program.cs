using System;
using System.Runtime.InteropServices;
using System.Threading;

namespace WinPlusH_dotNet;

class Program
{
    // Windows API imports for keyboard simulation
    [DllImport("user32.dll")]
    static extern void keybd_event(byte bVk, byte bScan, uint dwFlags, UIntPtr dwExtraInfo);

    // Key event flags
    const int KEYEVENTF_KEYDOWN = 0x0000;
    const int KEYEVENTF_KEYUP = 0x0002;
    
    // Virtual key codes
    const byte VK_LWIN = 0x5B;  // Left Windows key
    const byte VK_H = 0x48;     // H key

    static void Main()
    {
        try
        {
            // Simulate Win+H key combination
            SimulateWinPlusH();
        }
        catch
        {
            // Silent failure - no console output for pen button usage
            Environment.Exit(1);
        }
    }

    static void SimulateWinPlusH()
    {
        // Press Windows key
        keybd_event(VK_LWIN, 0, KEYEVENTF_KEYDOWN, UIntPtr.Zero);
        Thread.Sleep(50);
        
        // Press H key
        keybd_event(VK_H, 0, KEYEVENTF_KEYDOWN, UIntPtr.Zero);
        Thread.Sleep(50);
        
        // Release H key
        keybd_event(VK_H, 0, KEYEVENTF_KEYUP, UIntPtr.Zero);
        Thread.Sleep(10);
        
        // Release Windows key
        keybd_event(VK_LWIN, 0, KEYEVENTF_KEYUP, UIntPtr.Zero);
    }
}
