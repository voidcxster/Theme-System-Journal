#Requires AutoHotkey v2.0


; entry := IniRead("themeSystemJournal.ini", "Monday, December 18, 2023 - Sunday, December 24, 2023")
; entry := 'fefefe=ewafawfewa'
; MsgBox RegExMatch(entry, "^[a-zA-Z]+=", &matchObj)
; loop matchObj.Count {
;     MsgBox matchObj.Pos[A_Index]
; }

entries := Map()

entry := IniRead("themeSystemJournal.ini", "Monday, November 27, 2023 - Sunday, December 3, 2023")
keys := []

matchPos := 1
while RegExMatch(entry, "m)^[a-zA-Z0-9]+(?=\=)", &matchObj, matchPos) {
    keys.Push(matchObj[])
    matchPos := matchObj.Pos + matchObj.Len
    MsgBox matchObj[]
}

for key in keys {
    entries[key] := IniRead("themeSystemJournal.ini", "Monday, November 27, 2023 - Sunday, December 3, 2023", key, "")
}

for key, value in entries {
    MsgBox key " : " value
}