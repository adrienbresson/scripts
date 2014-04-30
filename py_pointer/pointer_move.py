#!/usr/bin/python
##import sys
##import time
###from Quartz.CoreGraphics import * # imports all of the top-level symbols in the module
##
##def mouseEvent(type, posx, posy):
##    theEvent = CGEventCreateMouseEvent(None, type, (posx,posy), kCGMouseButtonLeft)
##    CGEventPost(kCGHIDEventTap, theEvent)
##def mousemove(posx,posy):
##    mouseEvent(kCGEventMouseMoved, posx,posy);
##def mouseclickdn(posx,posy):
##    mouseEvent(kCGEventLeftMouseDown, posx,posy);
##def mouseclickup(posx,posy):
##    mouseEvent(kCGEventLeftMouseUp, posx,posy);
##def mousedrag(posx,posy):
##    mouseEvent(kCGEventLeftMouseDragged, posx,posy);
##
##ourEvent = CGEventCreate(None);
##currentpos=CGEventGetLocation(ourEvent); # Save current mouse position
###mouseclickdn(60, 100);
###mousedrag(60, 300);
###mouseclickup(60, 300);
##mousemove(500, 600);
##time.sleep(2);
##mousemove(int(currentpos.x),int(currentpos.y)); # Restore mouse position

from Xlib import X, display
d = display.Display()
s = d.screen()
root = s.root
root.warp_pointer(500, 600)
d.sync()

