#SingleInstance Force

taskCompletion := 0

daily := Gui("+AlwaysOnTop", "Daily Theme")
daily.AddEdit("w100 h50", "theme")
loop 7 {
	daily.AddPicture("h50 w50 x+m v", "C:\Users\voidc\Desktop\incomplete-task.png")
	taskBubble := daily.AddPicture("h50 w50 x+m vR1C" A_Index, "C:\Users\voidc\Desktop\incomplete-task.png")
	daily["vR1C" A_Index].OnEvent("Click", changeTaskCompletion)
}
taskBubble := daily.AddPicture("h50 w50 x+m", "C:\Users\voidc\Desktop\incomplete-task.png")
taskBubble.OnEvent("Click", changeTaskCompletion)
taskBubble.OnEvent("DoubleClick", changeTaskCompletion)
daily.Show("Center")

changeTaskCompletion(*) {
	global 
	if !(taskCompletion) {
		taskBubble.Value := "C:\Users\voidc\Desktop\partially-complete-task.png"
		taskCompletion := 0.5
	} else if (taskCompletion = 0.5) {
		taskBubble.Value := "C:\Users\voidc\Desktop\complete-task.png"
		taskCompletion := 1
	} else {
		taskBubble.Value := "C:\Users\voidc\Desktop\incomplete-task.png"
		taskCompletion := 0
	}
}