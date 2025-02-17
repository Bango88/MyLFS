# GRUB Phase 4
mkdir -p /usr/share/fonts/unifont
gunzip -c ../$(basename $PKG_UNIFONT) > /usr/share/fonts/unifont/unifont.pcf

unset {C,CPP,CXX,LD}FLAGS

./configure --prefix=/usr        \
            --sysconfdir=/etc    \
            --disable-efiemu     \
            --with-platform=efi  \
            --target=x86_64      \
            --disable-werror     
#           --enable-grub-mkfont (uncomment if using FreeType)

unset TARGET_CC

make

make install

mv /etc/bash_completion.d/grub /usr/share/bash-completion/completions

GRUB_OUTPUT=$(grub-install --bootloader-id=LFS --recheck)
if [ -n "$(echo $GRUB_OUTPUT | grep "No error reported")" ]
then
    echo "An error occured while installing GRUB:"
    echo $GRUB_OUTPUT
    exit -1
fi

