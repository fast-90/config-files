-- Check if Emacs has any open windows
tell application "System Events"
     if (count windows of process "Emacs") is greater than 0 then
        -- If Emacs has open windows, activate it
        tell application "Emacs" to activate
     else
        -- If no open windows, run emacsclient in the shell
        do shell script "/opt/homebrew/bin/emacsclient -nc"
        tell application "Emacs" to activate
     end if
end tell