This small guide is a collection of steps found here and there on the internet in order to replicate my archlinuxarm setup on the raspberry pi4

Thanks tavark for this [repo](https://github.com/Tavark/archlinux-arm-on-raspberry-pi4) because this guide is heavily inspired by it.

# Installation (thanks [alarmwiki](https://archlinuxarm.org/platforms/armv8/broadcom/raspberry-pi-4))

Replace sdX in the following instructions with the device name for the SD card as it appears on your computer.

Start fdisk to partition the SD card:

    fdisk /dev/sdX

At the fdisk prompt, delete old partitions and create a new one:
 
-Type o. This will clear out any partitions on the drive.
-Type p to list partitions. There should be no partitions left.
-Type n, then p for primary, 1 for the first partition on the drive, press ENTER to accept the default first sector, then type +200M for the last sector.
-Type t, then c to set the first partition to type W95 FAT32 (LBA).
-Type n, then p for primary, 2 for the second partition on the drive, and then press ENTER twice to accept the default first and last sector.
-Write the partition table and exit by typing w.

Create and mount the FAT filesystem:

    mkfs.vfat /dev/sdX1
    mkdir boot
    mount /dev/sdX1 boot

Create and mount the ext4 filesystem:

    mkfs.ext4 /dev/sdX2
    mkdir root
    mount /dev/sdX2 root

Download and extract the root filesystem (as root, not via sudo):

    wget http://os.archlinuxarm.org/os/ArchLinuxARM-rpi-aarch64-latest.tar.gz
    bsdtar -xpf ArchLinuxARM-rpi-aarch64-latest.tar.gz -C root
    sync

Download dtb for Raspberry PI to make USB work

    wget https://github.com/raspberrypi/firmware/raw/master/boot/bcm2711-rpi-4-b.dtb
    cp bcm2711-rpi-4-b.dtb root/boot/bcm2711-rpi-4-b.dtb

Before unmounting the partitions, update /etc/fstab for the different SD block device compared to the Raspberry Pi 3:

    sed -i 's/mmcblk0/mmcblk1/g' root/etc/fstab

Move boot files to the first partition:

    mv root/boot/* boot

Unmount the two partitions:

    umount boot root

Insert the SD card into the Raspberry Pi, connect ethernet, and apply 5V 3A power.
Use the serial console or SSH to the IP address given to the board by your router.
Login as the default user alarm with the password alarm.
The default root password is root.
Initialize the pacman keyring and populate the Arch Linux ARM package signing keys:

    pacman-key --init
    pacman-key --populate archlinuxarm

# Configuration

### System update

    sudo pacman -Syyu

### Image backup

I think that this is a good time to backup your SD card in order to prevent you from doing the long and boring installation that we did before

To do so you ca use the `dd` command 

    # dd if=/dev/sdX conv=sync,noerror bs=64k status=progress | gzip > ~/alarm_pi4_postinstall_bk_${now}.img.gz

and restore it with the raspberry pi imager whenever you want a fresh archlinux install

### Users and host configuration

Edit the `/etc/pacman.conf` config file and uncomment the `Color` line in order to have a more clear view when you install new packages

Localization

Edit /etc/locale.gen and uncomment en_US.UTF-8 UTF-8 and other needed locales. Generate the locales by running:

    # locale-gen

Create the locale.conf file, and set the LANG variable accordingly:

    /etc/locale.conf
    ---
    LANG=en_US.UTF-8

If you set the console keyboard layout, make the changes persistent in vconsole.conf:

    /etc/vconsole.conf
    ---
    KEYMAP=it

Configure hostname

    sudo hostnamectl set-hostname <new_hostname>

Configure timezone

    ln -s /usr/share/zoneinfo/Europe/Rome /etc/localtime

Thanks [voidwiki](https://wiki.voidlinux.org/Post_Installation#User_Account) 

    useradd -m -G wheel,users,audio,video,input,network <username> -p <password>

Check if you're able to login via your new user. You should also change the password for alarm and root.

-(Optional) allow login via ssh with your private key. Therefore from another computer:

    ssh-copy-id -i ~/.ssh/<your_public_key> <username>@<raspberrypi>

Install base base-devel and other useful packages

    # pacman -S base base-devel vim neofetch git bash-completion keychain

In order to administrate you pc as superuser, after you installed the sudo package, you need to uncomment the following line in the `/etc/sudoers` file `%wheel ALL=(ALL) ALL` using the command `visudo`

## Network

Inorder to be able to access wireless networks, download the *networkmanager* package

    # pacman -S networkmanager

create the rule in order to be able to manage connections (your user must be in the *network* group)

    /etc/polkit-1/localauthority/50-local.d/org.freedesktop.NetworkManager.pkla
    ---
    polkit.addRule(function(action, subject) {
      if (action.id.indexOf("org.freedesktop.NetworkManager.") == 0 && subject.isInGroup("network")) {
        return polkit.Result.YES;
      }
    });

and enable/start the service

    # systemctl enable networkmanager.service
    # systemctl start networkmanager.service

now after a restart you should be able to use nmtui to activate a wireless connection.

## Aur

Install yay

    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si

-install de (lxde + i3)

In this configuration we're going to use a tiling window manager like i3, in order to make things easyer with the raspberry pi and everithing, we're going to use it coupled with lxde!

Let's intall everithing we need

    # pacman -S lxde-common lxsession i3-gaps i3status alacritty lxdm ttf-dejavu ttf-font-awesome

now you need to enable the display manager service

    # systemctl enable lxdm.service

in this file you can find the global configurations for the autostart `/etc/xdg/lxsession/LXDE/autostart`
here you can edit the default desktop configurations `/etc/xdg/lxsession/LXDE/desktop.conf` since we're setting up an i3 desktop, we're going to set it in this line

    window_manager=i3

if you want you can also install a more complete font pack like `nerd-fonts-complete` from the aur

    $ yay nerd-fonts-complete

## Vnc

Install the `tigervnc` package.

For a quick start, see the steps below. Users are encouraged to read vncserver(8) for the complete list of configuration options.

Create a password using `vncpasswd` which will store the hashed password in `~/.vnc/passwd`.
Edit `/etc/tigervnc/vncserver.users` to define user mappings. Each user defined in this file will have a corresponding port on which its session will run. The number in the file corresponds to a TCP port. By default, :1 is TCP port 5901 (5900+1). If another parallel server is needed, a second instance can then run on the next highest, free port, i.e 5902 (5900+2).
Create `~/.vnc/config` and at a minimum, define the type of session desired with a line like `session=foo` where foo corresponds to whichever desktop environment is to run. One can see which desktop environments are available on the system by seeing their corresponding .desktop files within `/usr/share/xsessions/`. For example:

    ~/.vnc/config
    ---
    session=lxqt
    geometry=1920x1080
    localhost
    alwaysshared


To start the vnc server just run `vncserver :1` where 1 is the display defined for your user.

## Personalization

Now it is time to make your de usable and beautiful!
install the provided dotfiles using the install script (it is going to create a symlink to the folder where you have downloaded them, not a copy)

Then if you want the dynamic color palette generator you need to download [pywal](https://github.com/dylanaraps/pywal)
Download the dependencies with:

    # pacman -S python-pip imagemagik

add the installation folder to the bashrc if it is not already there in order to be able to execute wal:

    ~/.bashrc
    ---
    export PATH="${PATH}:${HOME}/.local/bin/"

after that you should generate your first color palette with:

    $ wal -i <path_to_your_image>

considering that the color scheme is not enabled by default after every boot you should edit your lxde autostart config under `~/.config/lxsession/LXDE/autostart` and add the following

    @wal -R

if you installed the compositor you can also start it from the same file, I use picom.

    @picom

-edit /boot/config.txt

enjoy.

