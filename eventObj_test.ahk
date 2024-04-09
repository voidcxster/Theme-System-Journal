class gEventObj {
    gTestMethod(guiCtrl, *) {
        global 

        btn.Visible := true
        gTest.GetPos(,,,&gTestHeight)
        gTest.Move(,,,gTestHeight + btnHeight + gTest.marginY)
        btn1.Move(40,0)
    }
}
gTest := Gui(, "Test", gEventObj())
btn1 := gTest.AddButton("h20", "this is how we live our lives")
btn1.OnEvent("Click", "gTestMethod")
btn := gTest.AddButton("xm", "test")
btn.Visible := false
btn.GetPos(,,,&btnHeight)
gTest.Show("h" 2 * gTest.MarginY + btnHeight)