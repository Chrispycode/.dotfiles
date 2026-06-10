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

## keyboard

sudo nvim /etc/environment

Add the following line (replace de with your layout code, e.g., fr, se, sv):

```shell
XKB_DEFAULT_LAYOUT=de
```

To use multiple layouts with a toggle shortcut, add:

```shell
XKB_DEFAULT_LAYOUT=de,us
XKB_DEFAULT_OPTIONS=grp:rctrl_rshift_toggle
```

# ghostty 

## not building on cachy os 

sudo objcopy -R .sframe /usr/lib/crt1.o
sudo objcopy -R .sframe /usr/lib/crti.o
sudo objcopy -R .sframe /usr/lib/crtn.o

## dead keys 

add this to the service above exec in ~/.local/share/systemd/user/app-com.mitchellh.ghostty.service

```shell
Environment=GTK_IM_MODULE=simple
```

# hibernate wifi bug

sudo modprobe -r mt7921e && sudo modprobe mt7921e

# switch NM backend

sudo systemctl disable --now wpa_supplicant.service
sudo systemctl mask wpa_supplicant.service
sudo tee /etc/NetworkManager/conf.d/wifi-backend.conf >/dev/null <<'EOF'
[device]
wifi.backend=iwd
EOF
sudo systemctl restart NetworkManager

# neovim build

sudo pacman -S base-devel cmake ninja curl
sudo make CMAKE_BUILD_TYPE=Release && sudo make install

# ghostty build
sudo pacman -S gtk4 gtk4-layer-shell libadwaita gettext
zig build -p $HOME/.local -Doptimize=ReleaseFast

# fix sddm using US layout
localectl set-x11-keymap de
