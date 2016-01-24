from Tkinter import *
import os, fileinput

root = Tk()

root.geometry("500x300")

def save_quit():
    thisFile = "canned_responses.lua"
    base = os.path.splitext(thisFile)[0]
    os.rename(thisFile, base + ".txt")
    
# Script to edit the lines in the code http://stackoverflow.com/questions/4719438/editing-specific-line-in-text-file-in-python
    with open('canned_responses.txt', 'r') as file:
# Put the lines in an array
        data = file.readlines()

# Edits the lines
    data[71] = 'waveInGestureString = "' + wavein_text.get(1.0, 'end-1c') + '"\n'
    data[72] = 'waveOutGestureString = "' + waveout_text.get(1.0, 'end-1c') + '"\n'
    data[73] = 'fistGestureString = "' + fist_text.get(1.0, 'end-1c') + '"\n'
    data[74] = 'openHandGestureString = "' + spread_text.get(1.0, 'end-1c') + '"\n'

# and write everything back
    with open('canned_responses.txt', 'w') as file:
        file.writelines( data )
    
    thisFile = "canned_responses.txt"
    base = os.path.splitext(thisFile)[0]
    os.rename(thisFile, base + ".lua")

    root.destroy()
    return

btn1 = Button(root,text="Save and Quit", command=save_quit)
btn1.pack(side="bottom")

lbl1 = Label(root, text="Enter canned responses below")
lbl1.pack()

wavein_text = Text(root, height=1,width=30)
wavein_text.pack(side="top")
wavein_text.insert(END, "Enter Wave In Text Here")

waveout_text = Text(root, height=1,width=30)
waveout_text.pack(side="top")
waveout_text.insert(END, "Enter Wave Out Text Here")

fist_text = Text(root, height=1,width=30)
fist_text.pack(side="top")
fist_text.insert(END, "Enter Make Fist Text Here")

spread_text = Text(root, height=1,width=30)
spread_text.pack(side="top")
spread_text.insert(END, "Enter Spread Fingers Text Here")

mainloop()
