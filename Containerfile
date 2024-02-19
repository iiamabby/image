ARG VERSION="${VERSION:-latest}"
FROM ghcr.io/ublue-os/silverblue-main:${VERSION}
COPY files /
COPY cosign.pub /usr/etc/pki/containers/ii.pub
RUN sed -i -e '0,/enabled=0/s//enabled=1/' /etc/yum.repos.d/fedora-updates-testing.repo && \
  rpm-ostree install \
    vim \
    gdisk \
    bootupd \
    grub2 \
    ostree-grub2 \
    grub2-efi-x64 \
    efibootmgr \
    nc \
    cloud-utils \
    strace
RUN bootupctl backend generate-update-metadata && \
  echo -e '\n\nii ALL=(ALL) NOPASSWD:ALL\n\n' >> /etc/sudoers
RUN flatpak remote-add --installation=image --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo && \
  flatpak install --installation=image -y org.mozilla.firefox net.sonic_pi.SonicPi edu.mit.Scratch
RUN rm -fr /tmp/* /var/* \
    && ostree container commit
