I installed manjaro headless using raspberry pi imager, it hallows you to configure painlessly your installation, letting you focus on the important things

after connectiong to the device via ssh compete the setup and install the essential packages for this configuration

	# pacman -Syyu base base-devel vim wget git bash-completion keychain lxde-common lxsession i3-gaps i3status alacritty rxvt-unicode lightdm lightdm-gtk-greeter ttf-dejavu ttf-font-awesome xorg feh bat conky ranger rofi xclip neofetch

## Display Manager

after installing these packages first of all enable the display manager

	# systemctl enable lightdm.service

I had quite a bit of problems making lightdm work on the raspberry pi trough the composite video output. I was missing some necessary packages like `xorg`, `xorg-server-xephyr` and `accountsservice` lol.
You also need to uncomment the `greeter-session=` line in the following file `/etc/lightdm/lightdm.conf` under the `[Seat:*]` session and define the greeter that you've downloaded, in my case `lightdm-gtk-greeter`

If you want your user to autologin at every startup you need to put him in the autologin group with `# gpasswd -a <username> autologin` and edit again the `lightdm.conf` file and uncomment the `autologin-user=` line writing your username

## Aur

Install yay

    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si


## Desktop Environment

-install de (lxde + i3)

In this configuration we're going to use a tiling window manager like i3, in order to make things easyer with the raspberry pi and everithing, we're going to use it coupled with lxde!

in this file you can find the global configurations for the autostart `/etc/xdg/lxsession/LXDE/autostart` if you want use plain i3 just comment everithing and you'll be fine 
here you can edit the default desktop configurations `/etc/xdg/lxsession/LXDE/desktop.conf` since we're setting up an i3 desktop, we're going to set it as the default window manager

    window_manager=i3

if you want you can also install a more complete font pack like `nerd-fonts-complete` from the aur

    $ yay nerd-fonts-complete
