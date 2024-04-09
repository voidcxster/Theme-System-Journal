class parent {
    __New() {
        this.c := this.child.__New()
    }
    class child extends parent {
        __New() {
            MsgBox "success"
        }
    }
}

test := parent()