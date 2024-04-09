#SingleInstance Force
#Include weeklyTheme.ahk
#Include dailyTheme.ahk
#Include seasonalTheme.ahk
#Include deleteEntries.ahk
TraySetIcon("images\journal.png")

; ! changing the date on the calendar on the journal opener, then creating a 
; ! new row on the weekly theme will break it because it's trying to save to a 
; ! new ini section so our row creator doesn't have the values it needs

; ! if there is a newline and a double quote (`"`n) at the end of a line in a
; ! text box in an entry it'll be parsed as an entirely new key and value pair
; ! additionally, any double quotes inside of the text will cause the value to  
; ! end early and not be stored properly
    ; TODO solve this by using IniRead

; TODO button to delete the entries so i don't have to keep going into the ini 
; TODO and manually deleting them

days := ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
entries := StrSplit(IniRead("themeSystemJournal.ini"), "`n")

selectedYear := FormatTime(A_Now, "yyyy")
selectedMon := FormatTime(A_Now, "MM")
selectedDate := FormatTime(A_Now, "dddd, MMMM d, yyyy")
selectedSeason := (selectedMon = 12 or selectedMon = 01 or selectedMon = 02 ? "Winter" : (selectedMon >= 9 ? "Autumn" : (selectedMon >= 6 ? "Summer" : "Spring")))
selectedWDay := FormatTime(A_Now, "WDay")
selectedWeek := []
loop 7 {
    selectedWeek.Push(FormatTime(DateAdd(DateAdd(A_Now, (A_WDay = 1 ? 0 : 8 - A_WDay), "days"), -A_Index + 1, "days"), "dddd, MMMM d, yyyy"))
}
selectedWeekName := selectedWeek[7] " - " selectedWeek[1]
; //FormatTime(DateAdd(A_Now, (A_WDay = 1 ? -6 : -A_WDay + 2), "days"), "dddd, MMMM d, yyyy") " - " FormatTime(DateAdd(A_Now, (A_WDay = 1 ? 0 : 8 - A_Index), "days"), "dddd, MMMM d, yyyy")

taskCompletion := Map() 
weeklyEntry := Map()
for entry in StrSplit(IniRead("themeSystemJournal.ini", selectedWeekName,, ""), "`n") {
    weeklyEntry[StrSplit(entry, "=")[1]] := StrSplit(entry, "=")[2]
}
weeklyEntryControls := weeklyEntry.Clone()
newRowData := ""
deletedRowData := []

defaultQuestions := Map(
    "title", "`"Where are you today?`"", 
    "box1", "`"What was good about your day?`"", 
    "box2", "`"What was bad about your day?`"", 
    "box3", "`"What are you thinking about?`"", 
    "boxTask", "`"What's the most important task for the day?`"", 
    "theme", "`"What's your theme for the year?`"", 
    "description", "`"What does your theme mean to you?`"", 
    "outcome", "`"What is one outcome you want as a part of your theme?`""
)
dailyEntry := Map()
for entry in StrSplit(IniRead("themeSystemJournal.ini", selectedDate,, ""), "`"`n", "`"") {
    dailyEntry[StrSplit(entry, "=")[1]] := StrSplit(entry, "=", "`"")[2]
}
    

journalOpener := Gui("+AlwaysOnTop +Resize", "Theme System Journal")

seasonalEntry := Map()
    for entry in StrSplit(IniRead("themeSystemJournal.ini", selectedSeason " " selectedYear,, ""), "`"`n", "`"") {
        seasonalEntry[StrSplit(entry, "=")[1]] := StrSplit(entry, "=", "`"")[2]
    }
seasonalControlDataToWrite := ""

journalOpener.AddPicture("h30 w410 xm vseasonButton", "images\" (HasVal(entries, selectedSeason " " selectedYear) ? StrLower(selectedSeason) : "no-entry") "-season.png")
journalOpener["seasonButton"].OnEvent("Click", createSeasonal)
journalOpener.AddText(
    "xm ym h30 w410 BackgroundTrans Center vseasonText", 
    selectedSeason " " A_Year
).SetFont((HasVal(entries, selectedSeason " " selectedYear) ? "c000000" : "c838383") " s17")

journalOpener.AddPicture("h50 w410 xm Section vweekButton", "images\" (HasVal(entries, selectedWeekName) ? "" : "no-entry-") "week.png")
journalOpener["weekButton"].OnEvent("Click", createWeekly)
journalOpener.AddText(
    "xm ys h50 w410 BackgroundTrans Center vweekText",
    selectedWeekName
).SetFont((HasVal(entries, selectedWeekName) ? "c000000" : "c838383") " s15") ; s28

for day in days {
    journalOpener.AddPicture(
        "h50 w50 " (A_Index = 1 ? "xm" : "x+m") " ys+60 v" day, 
        "images\" (HasVal(entries, selectedWeek[8 - A_Index]) ? "" : "no-entry-") StrLower(day) "-daily.png"
    ) ; window should be about 1450 px
    journalOpener[day].OnEvent("Click", createDaily)
}

dateSelector := journalOpener.AddMonthCal("w410 vdateSelector xm") ; the calendar is about 300 px by default
dateSelector.OnEvent("Change", changeDate)

journalOpener.AddButton("w410 vdeleteButton", "Delete Entries")
journalOpener["deleteButton"].OnEvent("Click", createDeleteWindow)

journalOpener.Show("Center")



changeDate(*) {
    global 

    selectedYear := FormatTime(dateSelector.Value, "yyyy")
    selectedMon := FormatTime(dateSelector.Value, "MM")
    selectedDate := FormatTime(dateSelector.Value, "dddd, MMMM d, yyyy")
    selectedSeason := (selectedMon = 12 or selectedMon = 01 or selectedMon = 02 ? "Winter" : (selectedMon >= 9 ? "Autumn" : (selectedMon >= 6 ? "Summer" : "Spring")))
    selectedWDay := FormatTime(dateSelector.Value, "WDay")
    selectedWeek := []
    loop 7 {
        selectedWeek.Push(FormatTime(DateAdd(DateAdd(dateSelector.Value, (selectedWDay = 1 ? 0 : 8 - selectedWDay), "days"), -A_Index + 1, "days"), "dddd, MMMM d, yyyy"))
    }
    selectedWeekName := selectedWeek[7] " - " selectedWeek[1]

    weeklyEntry := Map()
    for entry in StrSplit(IniRead("themeSystemJournal.ini", selectedWeekName,, ""), "`n") {
        weeklyEntry[StrSplit(entry, "=")[1]] := StrSplit(entry, "=")[2]
    }
    weeklyEntryControls := weeklyEntry.Clone()

    dailyEntry := Map()
    for entry in StrSplit(IniRead("themeSystemJournal.ini", selectedDate,, ""), "`"`n", "`"") {
        dailyEntry[StrSplit(entry, "=")[1]] := StrSplit(entry, "=", "`"")[2]
    }

    seasonalEntry := Map()
    for entry in StrSplit(IniRead("themeSystemJournal.ini", selectedSeason " " selectedYear,, ""), "`"`n", "`"") {
        seasonalEntry[StrSplit(entry, "=")[1]] := StrSplit(entry, "=", "`"")[2]
    }
    
    journalOpener["seasonButton"].Value := "images\" (HasVal(entries, selectedSeason " " selectedYear) ? StrLower(selectedSeason) : "no-entry") "-season.png"

    journalOpener["seasonText"].Value := (selectedMon = 12 or selectedMon = 01 or selectedMon = 02 ? "Winter" : (selectedMon >= 9 ? "Autumn" : (selectedMon >= 6 ? "Summer" : "Spring"))) " " A_Year
    journalOpener["seasonText"].SetFont((HasVal(entries, selectedSeason " " selectedYear) ? "c000000" : "c838383"))
    
    journalOpener["weekButton"].Value := "images\" (HasVal(entries, selectedWeekName) ? "" : "no-entry-") "week.png"

    journalOpener["weekText"].Value := FormatTime(DateAdd(dateSelector.Value, (selectedWDay = 1 ? -6 : -selectedWDay + 2), "days"), "dddd, MMMM d, yyyy") " - " FormatTime(DateAdd(dateSelector.Value, (selectedWDay = 7 ? 1 : 8 - selectedWDay), "days"), "dddd, MMMM d, yyyy") 
    journalOpener["weekText"].SetFont((HasVal(entries, selectedWeekName) ? "c000000" : "c838383"))

    for day in days {
        journalOpener[day].Value := "images\" (HasVal(entries, selectedWeek[7 - A_Index + 1]) ? "" : "no-entry-") StrLower(day) "-daily.png" 
    }
}

test(*) {
    MsgBox("this is a test")
}

; credit to @jNizM on the forums 
HasVal(haystack, needle) { 
    if !(IsObject(haystack)) || (haystack.Length = 0)
        return 0
    for index, value in haystack
        if (value = needle)
            return index
    return 0
}
