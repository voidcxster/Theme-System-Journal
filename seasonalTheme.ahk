#SingleInstance Force

createSeasonal(*) {
    global

    seasonal := Gui("+AlwaysOnTop +Resize", selectedSeason " " selectedYear " | Seasonal Theme")

    if (seasonalEntry.Count = 0) {
        createNewSeasonal
        Exit
    }
        
    seasonal.AddEdit("h20 w940 vtheme", (seasonalEntry["theme"] !== "" ? seasonalEntry["theme"] : defaultQuestions["theme"])).SetFont((seasonalEntry["theme"] !== "" ? "norm c000000" : "italic cababab s11"))
    seasonal["theme"].OnEvent("Focus", removeSeasonalText)
    seasonal["theme"].OnEvent("LoseFocus", addSeasonalText)
    
    seasonal.AddEdit("h200 w940 vdescription", (seasonalEntry["description"] !== "" ? seasonalEntry["description"] : defaultQuestions["description"])).SetFont((seasonalEntry["description"] !== "" ? "norm c000000" : "italic cababab s11"))
    seasonal["description"].OnEvent("Focus", removeSeasonalText)
    seasonal["description"].OnEvent("LoseFocus", addSeasonalText)

    while True {
        seasonalRowCount := A_Index

        try 
            seasonal.AddEdit("h50 w940 voutcome" A_Index, (seasonalEntry["outcome" A_Index] !== "" ? seasonalEntry["outcome" A_Index] : defaultQuestions["outcome"])).SetFont((seasonalEntry["outcome" A_Index] !== "" ? "norm c000000" : "italic cababab s11"))
        catch {
            break
        }
        seasonal["outcome" A_Index].OnEvent("Focus", removeSeasonalText)
        seasonal["outcome" A_Index].OnEvent("LoseFocus", addSeasonalText)
    }
    
    ; seasonal.AddEdit("h50 w940 voutcome1", (seasonalEntry["outcome1"] !== "" ? seasonalEntry["outcome1"] : defaultQuestions["outcome"])).SetFont("italic cababab s11")
    ; seasonal["outcome1"].OnEvent("Focus", removeSeasonalText)
    ; seasonal["outcome1"].OnEvent("LoseFocus", addSeasonalText)
    
    ; seasonal.AddEdit("h50 w940 voutcome2", (seasonalEntry["outcome2"] !== "" ? seasonalEntry["outcome2"] : defaultQuestions["outcome"])).SetFont("italic cababab s11")
    ; seasonal["outcome2"].OnEvent("Focus", removeSeasonalText)
    ; seasonal["outcome2"].OnEvent("LoseFocus", addSeasonalText)
    
    ; seasonal.AddEdit("h50 w940 voutcome3", (seasonalEntry["outcome3"] !== "" ? seasonalEntry["outcome3"] : defaultQuestions["outcome"])).SetFont("italic cababab s11")
    ; seasonal["outcome3"].OnEvent("Focus", removeSeasonalText)
    ; seasonal["outcome3"].OnEvent("LoseFocus", addSeasonalText)
    
    ; seasonal.AddEdit("h50 w940 voutcome4", (seasonalEntry["outcome4"] !== "" ? seasonalEntry["outcome4"] : defaultQuestions["outcome"])).SetFont("italic cababab s11")
    ; seasonal["outcome4"].OnEvent("Focus", removeSeasonalText)
    ; seasonal["outcome4"].OnEvent("LoseFocus", addSeasonalText)

    seasonal.AddButton("w465 h50 xm Default vaddButton", "+").SetFont("s25 c838383 w1000")
    seasonal["addButton"].OnEvent("Click", addSeasonalRow)

    seasonal.AddButton("w465 h50 x+m vremoveButton", "X").SetFont("s25 cff0000 w1000")
    seasonal["removeButton"].OnEvent("Click", removeSeasonalRow)

    seasonal.OnEvent("Close", closeSeasonal)
    seasonal.Show("Center")
}


createNewSeasonal(*) {
    global 

    IniWrite("
    (
        theme=
        description=
        outcome1=
        outcome2=
        outcome3=
    )", "themeSystemJournal.ini", selectedSeason " " selectedYear)

    entries := StrSplit(IniRead("themeSystemJournal.ini"), "`n")
    changeDate

    ; create the gui and the controls
    seasonal.AddEdit("h20 w940 vtheme", defaultQuestions["theme"]).SetFont("italic cababab s11")
    seasonal["theme"].OnEvent("Focus", removeSeasonalText)
    seasonal["theme"].OnEvent("LoseFocus", addSeasonalText)
    
    seasonal.AddEdit("h200 w940 vdescription", defaultQuestions["description"]).SetFont("italic cababab s11")
    seasonal["description"].OnEvent("Focus", removeSeasonalText)
    seasonal["description"].OnEvent("LoseFocus", addSeasonalText)
    
    seasonal.AddEdit("h50 w940 voutcome1", defaultQuestions["outcome"]).SetFont("italic cababab s11")
    seasonal["outcome1"].OnEvent("Focus", removeSeasonalText)
    seasonal["outcome1"].OnEvent("LoseFocus", addSeasonalText)
    
    seasonal.AddEdit("h50 w940 voutcome2", defaultQuestions["outcome"]).SetFont("italic cababab s11")
    seasonal["outcome2"].OnEvent("Focus", removeSeasonalText)
    seasonal["outcome2"].OnEvent("LoseFocus", addSeasonalText)
    
    seasonal.AddEdit("h50 w940 voutcome3", defaultQuestions["outcome"]).SetFont("italic cababab s11")
    seasonal["outcome3"].OnEvent("Focus", removeSeasonalText)
    seasonal["outcome3"].OnEvent("LoseFocus", addSeasonalText)
    
    seasonal.AddEdit("h50 w940 voutcome4", defaultQuestions["outcome"]).SetFont("italic cababab s11")
    seasonal["outcome4"].OnEvent("Focus", removeSeasonalText)
    seasonal["outcome4"].OnEvent("LoseFocus", addSeasonalText)

    seasonal.AddButton("w470 h50 xm Default vaddButton", "+").SetFont("s25 c838383 w1000")
    seasonal["addButton"].OnEvent("Click", addSeasonalRow)

    seasonal.AddButton("w470 h50 x+m vremoveButton", "X").SetFont("s25 cff0000 w1000")
    seasonal["removeButton"].OnEvent("Click", removeSeasonalRow)

    seasonalRowCount := 4
    seasonal.OnEvent("Close", closeSeasonal)
    seasonal.Show("Center")
}


removeSeasonalText(box, *) {
    box.Value := (box.Value == defaultQuestions[RegExReplace(box.Name, "[0-9]+", "")] ? "" : box.Value)
    box.SetFont("norm c000000")
}


addSeasonalText(box, *) {
    box.SetFont((box.Value == "" ? "italic cababab" : "norm c000000"))
    box.Value := (box.Value == "" ? defaultQuestions[RegExReplace(box.Name, "[0-9]+", "")] : box.Value)
}

addSeasonalRow(*) {
    global 

    seasonalControlDataToWrite := "outcome" seasonalRowCount "=`"`"`n" 
    
    seasonalRowCount += 1
    
    saveSeasonal
    createSeasonal
}


removeSeasonalRow(*) {
    global 

    seasonalRowCount -= 1

    seasonalDeletedRowData := "outcome" seasonalRowCount "=`"" (seasonal["outcome" seasonalRowCount].Value !== defaultQuestions["outcome"] ? seasonal["outcome" seasonalRowCount].Value : "") "`"`n"

    saveSeasonal
    createSeasonal
}


saveSeasonal(*) {
    global 

    seasonalSaveData := seasonal.Submit("Hide")

    for key, value in seasonalEntry {
        if (seasonalSaveData.%key% !== defaultQuestions[RegExReplace(key, "[0-9]+", "")])
            seasonalControlDataToWrite .= key "=`"" seasonalSaveData.%key% "`"`n"   
        else
            seasonalControlDataToWrite .= key "=`"`"`n"
    }

    try seasonalControlDataToWrite := StrReplace(seasonalControlDataToWrite, seasonalDeletedRowData, "")

    IniWrite(Trim(seasonalControlDataToWrite, "`n"), "themeSystemJournal.ini", selectedSeason " " selectedYear)

    seasonalEntry := Map()
     for entry in StrSplit(IniRead("themeSystemJournal.ini", selectedSeason " " selectedYear,, ""), "`"`n", "`"") {
        seasonalEntry[StrSplit(entry, "=")[1]] := StrSplit(entry, "=", "`"")[2]
    }
}


closeSeasonal(*) {
    global

    seasonalControlDataToWrite := ""

    saveSeasonal
    seasonal.Destroy()
}