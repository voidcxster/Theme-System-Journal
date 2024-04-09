#SingleInstance Force

createWeekly(*) { ; TODO make the rowCount update whenver you add or remove a row 
    global

    ; for key, value in weeklyEntry {
    ; 	MsgBox(key " = " value)
    ; }
    weekly := Gui("+AlwaysOnTop +Resize", selectedWeekName " | Weekly Theme")

    if (weeklyEntry.Count = 0) {
        createNewWeekly
        Exit
    }

    for day in days {
        weekly.AddEdit("r1 w50 " (A_Index = 1 ? "x530" : "x+m") " v" StrLower(day), weeklyEntry.Delete(StrLower(day))).SetFont("s14")
    }

    while weeklyEntry.Count { ; exit when all the controls are created 
        rowCount := A_Index
        
        weekly.AddEdit("w500 h50 x20 vrow" A_Index "taskName", weeklyEntry.Delete("row" A_Index "taskName")).SetFont("s14")
        
        loop 7 {
            name := "row" rowCount "column" A_Index
            taskCompletion.Set(name, weeklyEntry.Delete(name))
            ; MsgBox(weeklyEntry.Delete(name))
            weekly.AddPicture("h50 w50 x+m v" name, "images\" (!taskCompletion[name] ? "incomplete" : (taskCompletion[name] = 0.5 ? "partially-complete" : "complete")) "-task.png")
            ; changeTaskCompletion(weekly[name])
            ; taskCompletion.Set(name, 0)
            weekly[name].OnEvent("Click", changeTaskCompletion)
            weekly[name].OnEvent("DoubleClick", changeTaskCompletion)
        }
    } else 
        rowCount := 0

    weekly.AddButton("w500 h50 x20 Default vaddButton", "+").SetFont("s25 c838383 w1000")
    weekly["addButton"].OnEvent("Click", addRow)

    weekly.AddButton("w410 h50 x+m vremoveButton", "X").SetFont("s25 cff0000 w1000")
    weekly["removeButton"].OnEvent("Click", removeRow)

    weekly.OnEvent("Close", closeWeekly)
    weekly.Show("Center")
}


changeTaskCompletion(taskBubble, *) {
    global 

    if !(taskCompletion[taskBubble.Name]) {
        taskBubble.Value := "images\partially-complete-task.png"
        taskCompletion[taskBubble.Name] := 0.5
    } else if (taskCompletion[taskBubble.Name] = 0.5) {
        taskBubble.Value := "images\complete-task.png"
        taskCompletion[taskBubble.Name] := 1
    } else {
        taskBubble.Value := "images\incomplete-task.png"
        taskCompletion[taskBubble.Name] := 0
    }
}


addRow(*) {
    global 

    rowCount += 1

    ; DllCall("DestroyWindow", "UInt", hControl)

    ; weekly.AddEdit("w500 h50 x20", "").SetFont("s14")

    ; loop 7 {
    ; 	name := "row" rowCount "column" A_Index
    ; 	; taskCompletion.Set(name, weeklyEntry.Delete(name))
    ; 	weekly.AddPicture("h50 w50 x+m v" name, "C:\Users\voidc\Desktop\incomplete-task.png")
    ; 	; changeTaskCompletion(weekly[name])
    ; 	taskCompletion.Set(name, 0)
    ; 	weekly[name].OnEvent("Click", changeTaskCompletion)
    ; 	weekly[name].OnEvent("DoubleClick", changeTaskCompletion)
    ; }

    ; loop 7 {
    ;     IniWrite("day" A_Index, "C:\Users\voidc\Desktop\themeSystemJournal.ini", selectedWeekName, )
    ; }

    newRowData .= "row" rowCount "taskName=`n"

    loop 7 {
        newRowData .= "row" rowCount "column" A_Index "=0`n"
    }
    
    saveWeekly
    createWeekly
}


removeRow(*) {
    global
        
    if (rowCount <= 0) {
        saveWeekly
        createWeekly
        Exit
    }

    ; IniDelete("C:\Users\voidc\Desktop\themeSystemJournal.ini", selectedWeek, "row" rowCount "taskName")

    ; loop 7 {
    ;     IniDelete("C:\Users\voidc\Desktop\themeSystemJournal.ini", selectedWeek, "row" rowCount "column" A_Index)
    ; }

    newRowData := ""

    deletedRowData.Push("row" rowCount "taskName=" weekly["row" rowCount "taskName"].Value "`n")

    loop 7 {
        deletedRowData.Push("row" rowCount "column" A_Index "=" taskCompletion["row" rowCount "column" A_Index] "`n")
    }

    rowCount -= 1
    
    saveWeekly
    createWeekly
}


saveWeekly(*) {
    global 

    saveData := weekly.Submit("Hide")
    for key, value in taskCompletion {
        saveData.%key% := value
    }
    
    controlDataToWrite := ""

    for key, value in weeklyEntryControls {
        controlDataToWrite .= key "=" saveData.%key% "`n"
    }
    
    for controlToDelete in deletedRowData {
        controlDataToWrite := StrReplace(controlDataToWrite, controlToDelete, "")
    }
    
    controlDataToWrite .= newRowData

    ; MsgBox(controlDataToWrite)
    ; MsgBox(deletedRowData)
    IniWrite(Trim(controlDataToWrite, "`n"), "themeSystemJournal.ini", selectedWeekName)

    deletedRowData := []
    newRowData := ""
    weeklyEntry := Map()
    for entry in StrSplit(IniRead("themeSystemJournal.ini", selectedWeekName,, ""), "`n") {
        weeklyEntry[StrSplit(entry, "=")[1]] := StrSplit(entry, "=")[2]
    }
    weeklyEntryControls := weeklyEntry.Clone()
}


closeWeekly(*) {
    global 

    saveWeekly
    weekly.Destroy()
}


createNewWeekly(*) {
    global 
    
    IniWrite("
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
    )", "themeSystemJournal.ini", selectedWeekName)

    entries := StrSplit(IniRead("themeSystemJournal.ini"), "`n")
    changeDate

    weeklyEntryControls := Map()
    for entry in StrSplit(IniRead("themeSystemJournal.ini", selectedWeekName,, ""), "`n") {
        weeklyEntryControls[StrSplit(entry, "=")[1]] := StrSplit(entry, "=")[2]
    }

    for day in days {
        weekly.AddEdit("r1 w50 " (A_Index = 1 ? "x530" : "x+m") " v" StrLower(day), day).SetFont("s14")
    }
 
    ; create minimum amount of rows for exercise, music, and coding 
    loop 3 { 
       
        rowCount := A_Index
        
        weekly.AddEdit("w500 h50 x20 vrow" A_Index "taskName", "").SetFont("s14")
    
        
        loop 7 {
            name := "row" rowCount "column" A_Index
            taskCompletion.Set(name, 0)
            weekly.AddPicture("h50 w50 x+m v" name, "images\incomplete-task.png")
            weekly[name].OnEvent("Click", changeTaskCompletion)
            weekly[name].OnEvent("DoubleClick", changeTaskCompletion)
        }
    }

    rowCount := 3

    weekly.AddButton("w500 h50 x20 Default vaddButton", "+").SetFont("s25 c838383 w1000")
    weekly["addButton"].OnEvent("Click", addRow)

    weekly.AddButton("w410 h50 x+m vremoveButton", "X").SetFont("s25 cff0000 w1000")
    weekly["removeButton"].OnEvent("Click", removeRow)

    weekly.OnEvent("Close", closeWeekly)
    weekly.Show("Center")
}
; taskCompletion := Map()
; days := ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"] ; "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"