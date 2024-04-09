#SingleInstance Force

createDaily(dayButton, *) {
    global

    for day in days {
        if (dayButton.Name = day)
                selectedButtonDate := selectedWeek[8 - A_Index]  
    }

    dailyEntry := Map()
    for entry in StrSplit(IniRead("themeSystemJournal.ini", selectedButtonDate,, ""), "`"`n", "`"") {
        dailyEntry[StrSplit(entry, "=")[1]] := StrSplit(entry, "=", "`"")[2]
    }

    daily := Gui("+AlwaysOnTop +Resize", selectedButtonDate " | Daily Theme")

    if (dailyEntry.Count = 0) {
        createNewDaily
        Exit
    }

    ; // MsgBox(dailyEntry["title"])
    daily.AddEdit("h20 w940 vtitle", (dailyEntry["title"] !== "" ? dailyEntry["title"] : defaultQuestions["title"])).SetFont((dailyEntry["title"] !== "" ? "norm c000000" : "italic cababab s11"))
    daily["title"].OnEvent("Focus", removeText)
    daily["title"].OnEvent("LoseFocus", addText)

    ; daily.AddText()
    daily.AddEdit("h100 w940 vbox1", (dailyEntry["box1"] !== "" ? dailyEntry["box1"] : defaultQuestions["box1"])).SetFont((dailyEntry["box1"] !== "" ? "norm c000000" : "italic cababab s11"))
    daily["box1"].OnEvent("Focus", removeText)
    daily["box1"].OnEvent("LoseFocus", addText)

    daily.AddEdit("h100 w940 vbox2", (dailyEntry["box2"] !== "" ? dailyEntry["box2"] : defaultQuestions["box2"])).SetFont((dailyEntry["box2"] !== "" ? "norm c000000" : "italic cababab s11"))
    daily["box2"].OnEvent("Focus", removeText)
    daily["box2"].OnEvent("LoseFocus", addText)

    daily.AddEdit("h200 w940 vbox3", (dailyEntry["box3"] !== "" ? dailyEntry["box3"] : defaultQuestions["box3"])).SetFont((dailyEntry["box3"] !== "" ? "norm c000000" : "italic cababab s11"))
    daily["box3"].OnEvent("Focus", removeText)
    daily["box3"].OnEvent("LoseFocus", addText)

    daily.AddEdit("h50 w940 vboxTask", (dailyEntry["boxTask"] !== "" ? dailyEntry["boxTask"] : defaultQuestions["boxTask"])).SetFont((dailyEntry["boxTask"] !== "" ? "norm c000000" : "italic cababab s11"))
    daily["boxTask"].OnEvent("Focus", removeText)
    daily["boxTask"].OnEvent("LoseFocus", addText)

    daily.OnEvent("Close", saveDaily)
    daily.Show("Center")
}

removeText(box, *) {
    box.Value := (box.Value == defaultQuestions[box.Name] ? "" : box.Value)
    box.SetFont("norm c000000")
}

addText(box, *) {
    box.SetFont((box.Value == "" ? "italic cababab" : "norm c000000"))
    box.Value := (box.Value == "" ? defaultQuestions[box.Name] : box.Value)
}


saveDaily(*) { ; // TODO change to work with daily theme
    global 

    dailySaveData := daily.Submit("Hide")
    
    controlDataToWrite := ""

    for key, value in dailyEntry {
        if (dailySaveData.%key% !== defaultQuestions[key]) 
            controlDataToWrite .= key "=`"" dailySaveData.%key% "`"`n"
        else ; the user didn't type anything and it's just the default question there
            controlDataToWrite .= key "=`n"

    }

    ; MsgBox(controlDataToWrite, InStr(controlDataToWrite, deletedRowData))
    ; MsgBox(deletedRowData)
    IniWrite(Trim(controlDataToWrite, "`n"), "themeSystemJournal.ini", selectedButtonDate)

    dailyEntry := Map()
    for entry in StrSplit(IniRead("themeSystemJournal.ini", selectedButtonDate,, ""), "`"`n", "`"") {
        dailyEntry[StrSplit(entry, "=")[1]] := StrSplit(entry, "=", "`"")[2]
    }    
}


createNewDaily(*) {
    global 

    IniWrite("
    (
    title=""
    box1=""
    box2=""
    box3=""
    boxTask=""
    )","themeSystemJournal.ini", selectedButtonDate) ; create a new section for the entry

    entries := StrSplit(IniRead("themeSystemJournal.ini"), "`n")
    changeDate

    ; create the gui and the controls
    daily.AddEdit("h20 w940 vtitle", defaultQuestions["title"]).SetFont("italic cababab")
    daily["title"].OnEvent("Focus", removeText)
    daily["title"].OnEvent("LoseFocus", addText)

    daily.AddEdit("h100 w940 vbox1", defaultQuestions["box1"]).SetFont("italic cababab")
    daily["box1"].OnEvent("Focus", removeText)
    daily["box1"].OnEvent("LoseFocus", addText)

    daily.AddEdit("h100 w940 vbox2", defaultQuestions["box2"]).SetFont("italic cababab")
    daily["box2"].OnEvent("Focus", removeText)
    daily["box2"].OnEvent("LoseFocus", addText)

    daily.AddEdit("h200 w940 vbox3", defaultQuestions["box3"]).SetFont("italic cababab")
    daily["box3"].OnEvent("Focus", removeText)
    daily["box3"].OnEvent("LoseFocus", addText)

    daily.AddEdit("h50 w940 vboxTask", defaultQuestions["boxTask"]).SetFont("italic cababab")
    daily["boxTask"].OnEvent("Focus", removeText)
    daily["boxTask"].OnEvent("LoseFocus", addText)

    daily.Show("Center")
}