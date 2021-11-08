These are my config files for my raspberry pi car computer.

The configuration is really straight forward.

just download all the dependencies with:

```sudo apt install i3 i3status rofi conky feh```

optionally you can also download pywal in order to setup the dynamic system color scheme.

Assuming that you're running Raspbian desktop you need to edit some files.

In order to set i3 as your window manager edit the file ```/etc/xdg/lxsession/LXDE-pi/desktop.conf``` and setting the following property as shown ```window_manager\=i3```

After that we need to comment every row in ```/etc/xdg/lxsession/LXDE-pi/autostart``` because in my setup I don't need to manage the lxpanel or screensaver.

Then the last thing to do is edit the autostart configuration in your user's config folder ```.config/lxsession/LXDE-pi/autostart``` in order to start the compositor and reload the last pywal theme
```@wal\ -R
@xcompmgr\ \&```
