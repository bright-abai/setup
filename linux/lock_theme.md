/etc/dconf/db/local.d/02-theme                             
```
[org/cinnamon/desktop/interface]
gtk-theme='Mint-Y-Orange'
icon-theme='Mint-Y-Sand'
```

1. Update your lock file
Add panel locks to your lock file (e.g., /etc/dconf/db/local.d/locks/00-panel-locks or add to your existing locks file):
```
# Panel settings
/org/cinnamon/panels-enabled
/org/cinnamon/panels-autohide
/org/cinnamon/panels-height
/org/cinnamon/panel-zone-icon-sizes
/org/cinnamon/panel-zone-symbolic-icon-sizes
/org/cinnamon/enabled-applets
```
2. Create/update your panel settings file
Create a settings file (e.g., /etc/dconf/db/local.d/00-panel):
```
[org/cinnamon]
panels-enabled=['1:0:bottom']
panels-autohide=['1:false']
panels-height=['1:40']

# Icon sizes for each panel zone [left, center, right]
panel-zone-icon-sizes='[{"panelId": 1, "left": 0, "center": 0, "right": 24}]'
panel-zone-symbolic-icon-sizes='[{"panelId": 1, "left": 28, "center": 28, "right": 16}]'

# Lock the applets on the panel (this is the default layout)
enabled-applets=['panel1:left:0:menu@cinnamon.org:0', 'panel1:left:1:show-desktop@cinnamon.org:1', 'panel1:left:2:grouped-window-list@cinnamon.org:2', 'panel1:right:0:systray@cinnamon.org:3', 'panel1:right:1:xapp-status@cinnamon.org:4', 'panel1:right:2:notifications@cinnamon.org:5', 'panel1:right:3:printers@cinnamon.org:6', 'panel1:right:4:removable-drives@cinnamon.org:7', 'panel1:right:5:keyboard@cinnamon.org:8', 'panel1:right:6:favorites@cinnamon.org:9', 'panel1:right:7:network@cinnamon.org:10', 'panel1:right:8:sound@cinnamon.org:11', 'panel1:right:9:power@cinnamon.org:12', 'panel1:right:10:calendar@cinnamon.org:13']
```

panels-enabled - Which panels are enabled (format: 'panelId:monitorIndex:position')

Position: top, bottom, left, right


panels-autohide - Auto-hide behavior ('panelId:true/false')
panels-height - Panel height in pixels ('panelId:height')
enabled-applets - Which applets are on the panel and their positions
