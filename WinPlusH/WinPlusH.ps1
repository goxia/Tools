# WinPlusH - Windows Voice Input Shortcut Tool
# Silent version without any output
# Version: 1.3

# Clear any existing type definitions
try {
    Remove-TypeData Keyboard -ErrorAction SilentlyContinue
} catch {}

# Add Windows API type definition with unique name
Add-Type @"
using System;
using System.Runtime.InteropServices;
public class WinAPI {
    [DllImport("user32.dll")]
    public static extern void keybd_event(byte bVk, byte bScan, int dwFlags, int dwExtraInfo);
}
"@

# Constants
$VK_LWIN = 0x5B         # Left Windows key
$VK_H = 0x48            # H key  
$KEYEVENTF_KEYUP = 0x0002   # Key release flag

try {
    # Simulate Win+H key combination with proper timing (completely silent)
    [WinAPI]::keybd_event($VK_LWIN, 0, 0, 0)      # Press Win key
    Start-Sleep -Milliseconds 100                  # Hold for 100ms
    
    [WinAPI]::keybd_event($VK_H, 0, 0, 0)         # Press H key
    Start-Sleep -Milliseconds 50                   # Hold both for 50ms
    
    [WinAPI]::keybd_event($VK_H, 0, $KEYEVENTF_KEYUP, 0)  # Release H key
    Start-Sleep -Milliseconds 50                   # Wait 50ms
    
    [WinAPI]::keybd_event($VK_LWIN, 0, $KEYEVENTF_KEYUP, 0)  # Release Win key
    
    # No output - completely silent operation
} 
catch {
    # Silent error handling - no output
}

exit 0
