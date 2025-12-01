on run argv
    if (count of argv) is 0 then return
    set imgPath to item 1 of argv

    tell application "Finder"
        set desktop picture to POSIX file imgPath
    end tell
end run