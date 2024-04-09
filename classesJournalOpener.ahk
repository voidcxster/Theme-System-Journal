#Requires AutoHotkey v2.0
#SingleInstance Force
; #Include weeklyTheme.ahk
; #Include dailyTheme.ahk
; #Include seasonalTheme.ahk
; #Include deleteEntries.ahk
TraySetIcon("images\journal.png")

entryTitles := StrSplit(IniRead("themeSystemJournal.ini"), "`n")

; find all keys in section
; for t in entryTitles {
;     entry := IniRead("themeSystemJournal.ini", "Monday, October 16, 2023 - Sunday, October 22, 2023")
;     RegExMatch(entry, "m)^[a-zA-Z0-9]+=", &matchObj)
;     ; MsgBox matchObj.Count
;     for match in matchObj {
;         ; MsgBox match
;     }
; }
; entries := Map(
;     Map("e", "e"),
;     Map("e", "e")
; )

; credit to @jNizM on the forums 
HasVal(haystack, needle) { 
    if !(IsObject(haystack)) || (haystack.Length = 0)
        return false
    for index, value in haystack
        if (value = needle)
            return index ; true
    return false
}


class ini {

    static __Item[section?, key?] {
        get => IniRead(
            "themeSystemJournal.ini", 
            section ?? unset,
            key ?? unset,
            false ; 0
        )
        ; get { 
        ;     try {
        ;         IniRead(
        ;             "themeSystemJournal.ini", 
        ;             (IsSet(section) ? section : unset),
        ;             (IsSet(key) ? key : unset)
        ;         )
        ;     } 
        ; }
        set => IniWrite(
            value, 
            "themeSystemJournal.ini", 
            section, 
            key ?? unset
        )
    }

    static clear(section) => iniDelete("themeSystemJournal.ini", section)

    static entries() => StrSplit(this[], "`n")

    static has(entry) => HasVal(this.entries(), entry)
    
    static hasPicture(entry) => this.has(entry) ? "" : "no-entry-"

    static hasFont(entry) => this.has(entry) ? "c000000" : "c838383"

    static hasKeyFont(section,  key) => IniRead("themeSystemJournal.ini", section, key, false) ? "norm c000000" : "italic cababab s11"

    ; static outcomes(section) {
    ;     o := Map()

    ;     entry := this[section]
    ;     keys := []

    ;     matchPos := 1
    ;     while RegExMatch(entry, "m)^[a-zA-Z0-9]+(?=\=)", &matchObj, matchPos) {
    ;         keys.Push(matchObj[])
    ;         matchPos := matchObj.Pos + matchObj.Len
    ;         ; MsgBox matchObj[]
    ;     }

    ;     for key in keys {
    ;         if (InStr(key, "outcome", true))
    ;             o[key] := this[section, key]
    ;     }

    ;     return o
    ; }

    ; static tasks(section) {
    ;     o := Map()

    ;     entry := this[section]
    ;     keys := []

    ;     matchPos := 1
    ;     while RegExMatch(entry, "m)^[a-zA-Z0-9]+(?=\=)", &matchObj, matchPos) {
    ;         keys.Push(matchObj[])
    ;         matchPos := matchObj.Pos + matchObj.Len
    ;         ; MsgBox matchObj[]
    ;     }

    ;     for key in keys {
    ;         if (InStr(key, "outcome", true))
    ;             o[key] := this[section, key]
    ;     }

    ;     return o
    ; }

    static outcomes(section) => this.findAllKeys("m)^outcome[0-9]+(?=\=)", section)

    static tasks(section) => this.findAllKeys("m)^row[0-9]+taskName(?=\=)", section)

    static findAllKeys(regEx, section) {
        entryDict := Map()

        entry := this[section]
        ; MsgBox RegExMatch(entry, regEx, &matchObj) entry regEx 
        matchPos := 1
        while RegExMatch(entry, regEx, &matchObj, matchPos) {
            key := matchObj[]
            entryDict[key] := this[section, key]
            matchPos := matchObj.Pos + matchObj.Len
        }

        return entryDict
    }
}


class journalOpener extends Gui {

    ; all days now lowercase
    days := ["mon", "tue", "wed", "thu", "fri", "sat", "sun"]
    seasonList := [
        "Winter", "Winter",
        "Spring", "Spring", "Spring", 
        "Summer", "Summer", "Summer", 
        "Autumn", "Autumn", "Autumn", 
        "Winter"
    ]

    __New() {
        super.__New("+AlwaysOnTop +Resize", "Theme System Journal", this)

        this.updateDates()

        this.addSeasonButton()
        this.addWeekButton()
        this.addDayButtons()
        this.addCalendar()
        this.addDeleteButton()

        this.Show("Center")
    }

    addSeasonButton(season := this.selectedSeasonName) {
        this.AddPicture(
            "h30 w410 xm vseasonButton",
            "images\" (HasVal(ini.entries(), season) ? StrLower(this.selectedSeason) : "no-entry") "-season.png"
        )
        this["seasonButton"].OnEvent(
            "Click",
            "createSeasonal"
        )
        this.AddText(
            "xm ym h30 w410 BackgroundTrans Center vseasonText", 
            this.selectedSeasonName
        ).SetFont(ini.hasFont(this.selectedSeasonName) " s17")
    }

    addWeekButton(week := this.selectedWeekName) {
        this.AddPicture(
            "h50 w410 xm Section vweekButton", 
            "images\" (HasVal(ini.entries(), week) ? "" : "no-entry-") "week.png"
        )
        this["weekButton"].OnEvent(
            "Click", 
            "createWeekly"
        )
        this.AddText(
            "xm ys h50 w410 BackgroundTrans Center vweekText",
            this.selectedWeekName
        ).SetFont(ini.hasFont(this.selectedWeekName) " s15") ; s28
    }

    addDayButtons() {
        for day in this.days { ; window should be about 1450 px
            this.AddPicture(
                ; put first button on new line then the next 7 on the same line
                "h50 w50 x" (A_Index = 1 ? "" : "+") "m ys+60 v" day, 
                "images\" ini.hasPicture(this.selectedWeek[day]) day "-daily.png"
            )
            this[day].OnEvent("Click", "createDaily")
        }
    }

    addCalendar() {
        ; the calendar is about 300 px by default
        this.dateSelector := this.AddMonthCal("w410 vdateSelector xm")
        this.dateSelector.OnEvent("Change", this.updateDates.Bind(this, this.dateSelector))
    }

    addDeleteButton() {
        this.AddButton("w410 vdeleteButton", "Delete Entries")
        this["deleteButton"].OnEvent(
            "Click",
            "createDeleteWindow" 
            ; * unfinished, check what params deleteThemes needs; could also
            ; * make it inherit the journalOpener class since they're so similar
        )
    }

    whichSeason(month) => this.seasonList[month]

    updateDates(calendar?, *) {
        isInit := !IsSet(calendar)
        ; if calendar not given, initialize dates with current time
        date := isInit ? A_Now : calendar.Value

        ; configure dates to match calendar value
        this.selectedYear := FormatTime(date, "yyyy")
        this.selectedMon := FormatTime(date, "MM")
        this.selectedDate := FormatTime(date, "dddd, MMMM d, yyyy")
        this.selectedSeason := this.whichSeason(this.selectedMon)
        this.selectedWDay := FormatTime(date, "WDay")
        this.selectedWeek := Map() ; * because we now have dupllicates for every single day of the week, if we have to enumerate this variable we need to be wary of having two values 
        ; loop 7 { ; old version, new one is reversed
        ;     this.selectedWeek.Push(
        ;         FormatTime(
        ;             DateAdd(
        ;                 DateAdd(
        ;                     date,
        ;                     this.selectedWDay = 1 ? 0 : 8 - this.selectedWDay,
        ;                     "days"
        ;                 ),
        ;                 1 - A_Index,
        ;                 "days"
        ;             ),
        ;             "dddd, MMMM d, yyyy"
        ;         ))
        ; }
        monWeekStart := DateAdd(
            date,
            this.selectedWDay = 1 ? 1 : 2 - this.selectedWDay,
            "days"
        )
        loop 7 {
            nextDay := A_Index - 1 ; to include monday in the list
            d := FormatTime(
                DateAdd(monWeekStart, nextDay, "days"),
                "dddd, MMMM d, yyyy"
            )
            this.selectedWeek[this.days[A_Index]] := d
            this.selectedWeek[A_Index] := d
        }
        this.selectedWeekName := this.selectedWeek[1] " - " this.selectedWeek[7]
        this.selectedSeasonName := this.selectedSeason " " this.selectedYear

        if not isInit { ; update ui for new date
            this["seasonButton"].Value := "images\" (HasVal(ini.entries(), this.selectedSeasonName) ? StrLower(this.selectedSeason) : "no-entry") "-season.png"

            this["seasonText"].Value := this.selectedSeasonName
            this["seasonText"].SetFont(ini.hasFont(this.selectedSeasonName))

            this["weekButton"].Value := "images\" ini.hasPicture(this.selectedWeekName) "week.png"

            this["weekText"].Value := this.selectedWeekName
            ; FormatTime(DateAdd(this.dateSelector.Value, (this.selectedWDay = 1 ? -6 : -this.selectedWDay + 2), "days"), "dddd, MMMM d, yyyy") " - " FormatTime(DateAdd(this.dateSelector.Value, (this.selectedWDay = 7 ? 1 : 8 - this.selectedWDay), "days"), "dddd, MMMM d, yyyy") 
            this["weekText"].SetFont(ini.hasFont(this.selectedWeekName))

            for day in this.days {
                this[day].Value := "images\" ini.hasPicture(this.selectedWeek[day]) day "-daily.png" 
            }
        }
    }

    WIP_selectedWeek[key] {
        get {
            if key is String {

            } else if key is Number {

            } else {
                throw Error("Key must be either an integer (index) or a string (hash).", -2, key)
            }
        }
        set {
            
        }
    }

    createDaily(btn, *) => this.click_createAndUpdate(btn, this.dt := dailyTheme(btn.Name, this.selectedWeek))
    
    createWeekly(btn, *) => this.click_createAndUpdate(btn, this.wt := weeklyTheme(this.selectedWeekName))
    
    createSeasonal(btn, *) => this.click_createAndUpdate(btn, this.st := seasonalTheme(this.selectedSeasonName))

    createDeleteWindow(*) {
        MsgBox "createDeleteWindow"
    }

    click_createAndUpdate(btn, guiEntry, *) { ; TODO think of good name
        this.updateUI(btn, true)
        guiEntry.OnEvent("Close", (*) => this.updateUI.Bind(this, btn)())
    }

    updateUI(btn, isInit := false, *) {
        ; TODO find a better solution that matches any pattern that isn't
        ; Button (tho this works, i think the previous idea would be more
        ; "futureproof")
        RegExMatch(btn.Name, "[a-z]+", &buttonType) ;  "[a-zA-Z0-9]+(?=Button$)?"
        if !IsObject(buttonType) { ; no match, early return
            return
        }
        /*
    [A-Z]?[a-z]+
    seasonButton
    weekButton
        Mon
        */
        ; catch error for day buttons, but those don't have text so we don't worry about them
        try text := this[buttonType[] "Text"]
        if isInit {
            switch buttonType[] {
                case "season":
                    btn.Value := "images\" StrLower(this.selectedSeason) "-season.png"
                    text.SetFont("c000000")
                case "week":
                    btn.Value := "images\week.png"
                    text.SetFont("c000000")
                default: ; day button
                    btn.Value := "images\" StrLower(btn.Name) "-daily.png"
            }
        } else {
            switch buttonType[] {
                case "season":
                    btn.Value := "images\" (HasVal(ini.entries(), this.selectedSeasonName) ? StrLower(this.selectedSeason) : "no-entry") "-season.png"
                    text.SetFont(ini.hasFont(this.selectedSeasonName))
                case "week":
                    btn.Value := "images\" ini.hasPicture(this.selectedWeekName) "week.png"
                    text.SetFont(ini.hasFont(this.selectedWeekName)) 
                    ; ! week could change if the user changes the calendar, use
                    ; constant variable or stop user from changing calendar when
                    ; an entry or delete window is open
                default: ; day button
                    btn.Value := "images\" ini.hasPicture(this.selectedWeek[btn.Name]) StrLower(btn.Name) "-daily.png" 
            }        
        }
    }
}


class dailyTheme extends Gui {
    
    defaultQuestions := Map(
        "title", '"Where are you today?"', 
        "box1", '"What was good about your day?"', 
        "box2", '"What was bad about your day?"', 
        "box3", '"What are you thinking about?"', 
        "boxTask", '"What`'s the most important task for the day?"' 
    )

    __New(dayOfWeek, selectedWeek) {
        this.dayOfWeek := dayOfWeek
        this.selectedWeek := selectedWeek
        
        ; find date of day (e.g. mon in jan 25 - jan 31)
        for _, day in this.selectedWeek {
            if (day ~= "^" StrTitle(this.dayOfWeek) "[a-zA-Z0-9]+, ") {
                this.selectedButtonDate := day
            }
        }

        super.__New("+AlwaysOnTop +Resize", this.selectedButtonDate " | Daily Theme", this)

        ; MsgBox ini[this.selectedButtonDate]
        ; check if entry exists
        if not ini[this.selectedButtonDate] {
            this.initDailyTheme
        }

        this.addTitleField()
        this.addReflectFields()
        this.addThinkField()
        this.addTaskField()

        this.OnEvent("Close", "saveDaily")

        this.Show("Center")
    }

    initDailyTheme() {
        ini[this.selectedButtonDate] := "
            (
            title=""
            box1=""
            box2=""
            box3=""
            boxTask=""
            )"
    }

    addTitleField() {
        this.AddEdit(
            "h20 w940 vtitle",
            ini[this.selectedButtonDate, "title"] or this.defaultQuestions["title"]
        ).SetFont(ini.hasKeyFont(this.selectedButtonDate, "title"))
        this["title"].OnEvent("Focus", "removeText")
        this["title"].OnEvent("LoseFocus", "addText")
    }

    addReflectFields(*) {
        loop 2 { ; 2 reflect fields, 1 for good & 1 for bad
            boxName := "box" A_Index
            this.AddEdit(
                "h100 w940 v" boxName,
                ini[this.selectedButtonDate, boxName] or this.defaultQuestions[boxName]
            ).SetFont(ini.hasKeyFont(this.selectedButtonDate, boxName))
            this[boxName].OnEvent("Focus", "removeText")
            this[boxName].OnEvent("LoseFocus", "addText")
        }
    }

    addThinkField(*) {
        this.AddEdit(
            "h200 w940 vbox3",
            ini[this.selectedButtonDate, "box3"] or this.defaultQuestions["box3"]
        ).SetFont(ini.hasKeyFont(this.selectedButtonDate, "box3"))
        this["box3"].OnEvent("Focus", "removeText")
        this["box3"].OnEvent("LoseFocus", "addText")
    }

    addTaskField(*) {
        this.AddEdit(
            "h50 w940 vboxTask",
            ini[this.selectedButtonDate, "boxTask"] or this.defaultQuestions["boxTask"]
        ).SetFont(ini.hasKeyFont(this.selectedButtonDate, "boxTask"))
        this["boxTask"].OnEvent("Focus", "removeText")
        this["boxTask"].OnEvent("LoseFocus", "addText")
    }

    removeText(editBox, *) {
        editBox.Value := 
            editBox.Value == this.defaultQuestions[editBox.Name]
            ? ""
            : editBox.Value
        editBox.SetFont("norm c000000")
    }

    addText(editBox, *) {
        editBox.SetFont((editBox.Value ? "norm c000000" : "italic cababab"))
        editBox.Value := (editBox.Value ? editBox.Value : this.defaultQuestions[editBox.Name])
    }

    saveDaily(*) {
        dailySaveData := this.Submit("Hide")

        ini.clear(this.selectedButtonDate)
        isEmpty := true
        for guiCtrlName, value in dailySaveData.OwnProps() {
            if (value !== this.defaultQuestions[guiCtrlName] && value) {
                ini[this.selectedButtonDate, guiCtrlName] := value
                isEmpty := false
            } else {
                ; the user didn't type anything and it's just the default 
                ; question there, or it's empty
                ini[this.selectedButtonDate, guiCtrlName] := ""
            }
        }

        if isEmpty {
            ini.clear(this.selectedButtonDate)
        }
    }
}


class weeklyTheme extends Gui {
    
    days := ["mon", "tue", "wed", "thu", "fri", "sat", "sun"]
    
    __New(week) {
        this.week := week

        super.__New("+AlwaysOnTop +Resize", week " | Weekly Theme", this)

        if not ini[this.week] {
            this.initWeeklyTheme()
        }

        this.addDayFields()
        this.addTaskRows()
        this.addAddButton()
        this.addRemoveButton()
        this.loadBlankTaskRows()

        this.OnEvent("Close", "saveWeekly")

        this.showCorrectHeight()
    }

    initWeeklyTheme() {
        ini[this.week] := "
        (
            fri=Fri
            mon=Mon
            row1column1=0
            row1column2=0
            row1column3=0
            row1column4=0
            row1column5=0
            row1column6=0
            row1column7=0
            row1taskName=
            row2column1=0
            row2column2=0
            row2column3=0
            row2column4=0
            row2column5=0
            row2column6=0
            row2column7=0
            row2taskName=
            row3column1=0
            row3column2=0
            row3column3=0
            row3column4=0
            row3column5=0
            row3column6=0
            row3column7=0
            row3taskName=
            sat=Sat
            sun=Sun
            thu=Thu
            tue=Tue
            wed=Wed
        )"
    }

    addDayFields() {
        for day in this.days {
            this.AddEdit(
                "r1 w50 " (A_Index = 1 ? "xm+510" : "x+m") " v" day,
                ini[this.week, day]
            ).SetFont("s14")
        }
    }

    addTaskRows()  {
        this.taskCount := 0
        for guiCtrlName, value in ini.tasks(this.week) { ; TODO finished, refine later
            this.AddEdit(
                "w500 h50 xm v" fieldName := "row" (++this.taskCount) "taskName",
                ini[this.week, fieldName]
            ).SetFont("s14")
            
            this.taskCompletion := Map()
            loop 7 {
                bubbleName := "row" this.taskCount "column" A_Index
                this.taskCompletion.Set(bubbleName, ini[this.week, bubbleName])
                this.AddPicture(
                    "h50 w50 x+m v" bubbleName,
                    "images\" (!this.taskCompletion[bubbleName] ? "incomplete" : this.taskCompletion[bubbleName] = 0.5 ? "partially-complete" : "complete") "-task.png"
                )
                this[bubbleName].OnEvent("Click", "changeTaskCompletion")
                this[bubbleName].OnEvent("DoubleClick", "changeTaskCompletion")
            }
        }        
    }

    addAddButton() {
        this.AddButton("w500 h50 xm Default vaddButton", "+")
            .SetFont("s25 c838383 w1000")
        this["addButton"].OnEvent("Click", "addRow")
    }

    addRemoveButton() {
        this.AddButton("w410 h50 x+m vremoveButton", "X")
            .SetFont("s25 cff0000 w1000")
        this["removeButton"].OnEvent("Click", "removeRow")
    }

    loadBlankTaskRows() {
        this.taskFieldCount := this.taskCount
        loop 7 - this.taskCount {
            fieldName := "row" (++this.taskFieldCount) "taskName"

            ; create row
            this.AddEdit(
                "w500 h50 xm Hidden v" fieldName,
                ini[this.week, fieldName]
            ).SetFont("s14")
            
            loop 7 {
                bubbleName := "row" this.taskCount "column" A_Index
                ; this.taskCompletion.Set(bubbleName, ini[this.week, bubbleName])
                this.AddPicture(
                    "h50 w50 x+m Hidden v" bubbleName,
                    "images\incomplete-task.png"
                )
                this[bubbleName].OnEvent("Click", "changeTaskCompletion")
                this[bubbleName].OnEvent("DoubleClick", "changeTaskCompletion")
            }
        }
    }

    saveWeekly(*) { ; TODO
        saveData := this.Submit("Hide")

        ; create properties for each task bubble
        for guiCtrlName, completionLevel in this.taskCompletion {
            saveData.%guiCtrlName% := completionLevel
        }
        
        for key, value in weeklyEntryControls {
            controlDataToWrite .= key "=" saveData.%key% "`n"
        }
        
        for controlToDelete in deletedRowData {
            controlDataToWrite := StrReplace(controlDataToWrite, controlToDelete, "")
        }
        
        controlDataToWrite .= newRowData

        ini.clear(this.week)
        IniWrite(Trim(controlDataToWrite, "`n"), "themeSystemJournal.ini", this.week)

        deletedRowData := []
        newRowData := ""
        weeklyEntry := Map()
        for entry in StrSplit(IniRead("themeSystemJournal.ini", this.week,, ""), "`n") {
            weeklyEntry[StrSplit(entry, "=")[1]] := StrSplit(entry, "=")[2]
        }
        weeklyEntryControls := weeklyEntry.Clone()

    } ; WIP

    showCorrectHeight() {
        this["mon"].GetPos(,,,&monFieldH)
        this["row1taskName"].GetPos(,,,&taskH) ; TODO change task names' name to "row1TaskName" to better conform to camel case standards
        this["addButton"].GetPos(,,,&addBtnH)
        height := 
            ; theme, desc, add & remove btns, top and bottom margins, all
            ; visible outcomes and their margins
            monFieldH + addBtnH + (3 * this.MarginY) 
            + (this.taskCount * (taskH + this.MarginY)) 
        this.Show("Center h" height)
    }

    addRow(btn, *) {
        ; early return if at max # of rows
        if (this.taskCount == this.taskFieldCount) {
            return
        }
        fieldName := "outcome" (++this.outcomeCount)
        bubbleName := "row" this.taskCount "column" A_Index
        this[ctrlName].Visible := true
        ; adjust window height for new ctrl
        this.GetPos(,,, &height)
        this.Move(,,, height + 50 + this.MarginY)
        ; move ctrl in
        this["addButton"].GetPos(&btnX, &btnY)
        this[ctrlName].Move(btnX, btnY)
        this["addButton"].Move(, btnY + 50 + this.MarginY)
        this["removeButton"].Move(, btnY + 50 + this.MarginY)
    }

    removeRow(btn, *) {
        ; early return if no more rows are left
        if (this.outcomeCount == 0) {
            return
        }
        ctrlName := "outcome" (this.outcomeCount--)
        this[ctrlName].Visible := false
        this.GetPos(,,, &height)
        this.Move(,,, height - 50 - this.MarginY)
        this["addButton"].GetPos(&btnX, &btnY)
        this[ctrlName].Move(btnX, btnY)
        this["addButton"].Move(, btnY - 50 - this.MarginY)
        this["removeButton"].Move(, btnY - 50 - this.MarginY)

        this[ctrlName].Value := ""
        this.addText(this[ctrlName])
    }

    changeTaskCompletion(taskBubble, *) {

    }
}


class seasonalTheme extends Gui {

    defaultQuestions := Map(
        "theme", '"What`'s your theme for the year?"', 
        "description", '"What does your theme mean to you?"', 
        "outcome", '"What is one outcome you want as a part of your theme?"'
    )

    __New(season) {
        this.season := season

        super.__New("+AlwaysOnTop +Resize", season " | Seasonal Theme", this)

        if not ini[this.season] {
            this.initSeasonalTheme()
        }

        this.addThemeField()
        this.addDescField()
        this.addOutcomeFields()
        this.addAddButton()
        this.addRemoveButton()
        this.loadBlankOutcomes()

        this.OnEvent("Close", "saveSeasonal")

        this.showCorrectHeight()
        ; this.Show("Center")
    }

    initSeasonalTheme() {
        ini[this.season] := "
        (
            theme=
            description=
            outcome1=
            outcome2=
            outcome3=
        )"
    }

    addThemeField() => this.addField("20", "theme")

    addDescField() => this.addField("200", "description")

    addOutcomeFields() {
        this.outcomeCount := 0
        for guiCtrlName, value in ini.outcomes(this.season) {
            this.addField("50", guiCtrlName)
            this.outcomeCount++
        }
    }

    loadBlankOutcomes() {
        this.outcomeFieldCount := this.outcomeCount
        loop 7 - this.outcomeCount {
            outcomeCtrlName := "outcome" (++this.outcomeFieldCount)
            this.addField("50", outcomeCtrlName, true)
            this[outcomeCtrlName].Visible := false
        }
    }
    
    addField(height, ctrlName, hidden := false) {
        default := this.defaultQuestions[InStr(ctrlName, "outcome", true) ? "outcome" : ctrlName] 
        this.AddEdit(
            "xm h" height " w940 v" ctrlName (hidden ? " Hidden" : ""),
            ini[this.season, ctrlName] or default
        ).SetFont(ini.hasKeyFont(this.season, ctrlName))
        this[ctrlName].OnEvent("Focus", "removeText")
        this[ctrlName].OnEvent("LoseFocus", "addText")
    }

    addAddButton() {
        this.AddButton("w465 h50 xm Default vaddButton", "+")
            .SetFont("s25 c838383 w1000")
        this["addButton"].OnEvent("Click", "addRow")
    }

    addRemoveButton() {
        this.AddButton("w465 h50 x+m vremoveButton", "X")
            .SetFont("s25 cff0000 w1000")
        this["removeButton"].OnEvent("Click", "removeRow")
    }

    removeText(editBox, *) {
        if InStr(editBox.Name, "outcome", true)
            default := "outcome"
        else 
            default := editBox.Name
        editBox.Value := 
            editBox.Value == this.defaultQuestions[default]
            ? ""
            : editBox.Value
        editBox.SetFont("norm c000000")
    }

    addText(editBox, *) {
        if InStr(editBox.Name, "outcome", true)
            default := "outcome"
        else 
            default := editBox.Name
        editBox.SetFont(editBox.Value ? "norm c000000" : "italic cababab")
        editBox.Value := editBox.Value or this.defaultQuestions[default]
    }

    addRow(btn, *) {
        if (this.outcomeCount == this.outcomeFieldCount) {
            return
        }
        ctrlName := "outcome" (++this.outcomeCount)
        this[ctrlName].Visible := true
        ; adjust window height for new ctrl
        this.GetPos(,,, &height)
        this.Move(,,, height + 50 + this.MarginY)
        ; move ctrl in
        this["addButton"].GetPos(&btnX, &btnY)
        this[ctrlName].Move(btnX, btnY)
        this["addButton"].Move(, btnY + 50 + this.MarginY)
        this["removeButton"].Move(, btnY + 50 + this.MarginY)
    }

    removeRow(btn, *) {
        if (this.outcomeCount == 0) {
            return
        }
        ctrlName := "outcome" (this.outcomeCount--)
        this[ctrlName].Visible := false
        this.GetPos(,,, &height)
        this.Move(,,, height - 50 - this.MarginY)
        this["addButton"].GetPos(&btnX, &btnY)
        this[ctrlName].Move(btnX, btnY)
        this["addButton"].Move(, btnY - 50 - this.MarginY)
        this["removeButton"].Move(, btnY - 50 - this.MarginY)

        this[ctrlName].Value := ""
        this.addText(this[ctrlName])
    }

    showCorrectHeight() { 
        this["theme"].GetPos(,,,&themeH)
        this["description"].GetPos(,,,&descH)
        this["addButton"].GetPos(,,,&addBtnH)
        this["outcome1"].GetPos(,,,&outcomeH)
        height := 
            ; theme, desc, add & remove btns, top and bottom margins, all
            ; visible outcomes and their margins
            themeH + descH + addBtnH + (4 * this.MarginY) 
            + (this.outcomeCount * (outcomeH + this.MarginY)) 
        this.Show("Center h" height)
    }

    saveSeasonal(*) {
        saveData := this.Submit("Hide")

        ini.clear(this.season)
        isEmpty := true
        for guiCtrlName, value in saveData.OwnProps() {
            ; early return if outcome field is invisible
            RegExMatch(guiCtrlName, "(?<=outcome)[0-9]+", &matchObj)
            if IsObject(matchObj) && Integer(matchObj[]) > this.outcomeCount {
                continue
            }
            if InStr(guiCtrlName, "outcome", true)
                default := this.defaultQuestions["outcome"]
            else 
                default := this.defaultQuestions[guiCtrlName]

            if (value !== default && value) {
                ini[this.season, guiCtrlName] := value
                isEmpty := false
            } else {
                ; the user didn't type anything and it's just the default 
                ; question there
                ini[this.season, guiCtrlName] := ""
            }

            if isEmpty {
                ini.clear(this.season)
            }
        }
    }
}


class deleteThemes extends Gui {
    __New(parent) {
        this.parent := parent
    }
}


j := journalOpener()