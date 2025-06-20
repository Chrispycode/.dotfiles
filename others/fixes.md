# fixes

## invalid or corrupted database (PGP signature)

sudo rm -R /var/lib/pacman/sync

sudo -E pacman -Syu

# Bluetooth one time fix

sudo modprobe -r btusb && sudo modprobe btusb && sudo systemctl restart bluetooth

File: /etc/modules-load.d/modules.conf

# List of modules to load at boot

i2c-dev # openrgb
i2c-piix4 # openrgb
btusb # bluetoth long term fix

# patriot viper open rgb

sudo vim /etc/default/grub
Add to GRUB_CMDLINE_LINUX="acpi_enforce_resources=lax"
sudo update-grub
restart

# run electron in wayland mode

Exec=/usr/bin/flatpak run --branch=stable --arch=x86_64 --command=cider-wrapper --socket=wayland sh.cider.Cider --enable-features=WaylandWindowDecorations --ozone-platform-hint=auto

# gnome debugging

gsettings set org.gtk.Settings.Debug enable-inspector-keybinding true
GTK_DEBUG=interactive appname

# steam

steam -dev

## launch options

mangohud %command%

### debug game launch

PROTON_LOG=1 %command%
