import Tkinter as tk
import Xlib.display as display

def mousepos(screenroot=display.Display().screen().root):
    pointer = screenroot.query_pointer()
    data = pointer._data
    return data["root_x"], data["root_y"]

def update():
    strl.set("mouse at {0}".format(mousepos()))
    root.after(100, update)

root = tk.Tk()
strl = tk.StringVar()
lab = tk.Label(root,textvariable=strl)
lab.pack()
root.after(100, update)
root.title("Mouseposition")
root.mainloop()

