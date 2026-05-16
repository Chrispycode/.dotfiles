# invalid or corrupted database (PGP signature)

sudo rm -R /var/lib/pacman/sync

sudo -E pacman -Syu

# Bluetooth one time fix

sudo modprobe -r btusb && sudo modprobe btusb && sudo systemctl restart bluetooth

File: /etc/modules-load.d/modules.conf

# wifi fix

sudo modprobe -r mt7921e && sudo modprobe mt7921e

# List of modules to load at boot

i2c-dev # openrgb
i2c-piix4 # openrgb
btusb # bluetoth long term fix


# run electron in wayland mode

Exec=/usr/bin/flatpak run --branch=stable --arch=x86_64 --command=cider-wrapper --socket=wayland sh.cider.Cider --enable-features=WaylandWindowDecorations --ozone-platform-hint=auto

# gnome debugging

gsettings set org.gtk.Settings.Debug enable-inspector-keybinding true
GTK_DEBUG=interactive appname

# steam

steam -dev

##  Drive mount 

LABEL=Files /mnt/Files ext4 defaults,rw,users,exec,suid,dev 0 2
LABEL=SPEEDY /mnt/SPEEDY auto defaults,rw,users,exec,suid,dev 0 2

## launch options

mangohud %command%

### debug game launch

PROTON_LOG=1 %command%

# ghostty not building on cachy os 

sudo objcopy -R .sframe /usr/lib/crt1.o
sudo objcopy -R .sframe /usr/lib/crti.o
sudo objcopy -R .sframe /usr/lib/crtn.o


# hibernate wifi bug

sudo modprobe -r mt7921e && sudo modprobe mt7921e

# neovim build

sudo pacman -S base-devel cmake ninja curl
make CMAKE_BUILD_TYPE=Release && sudo make install

# ghostty build
sudo pacman -S gtk4 gtk4-layer-shell libadwaita gettext
zig build -p $HOME/.local -Doptimize=ReleaseFast

# fix sddm using US layout
localectl set-x11-keymap de
