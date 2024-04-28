{
  inputs.nari.url = "github:mrquantumoff/razer-nari-pipewire-profile";
  inputs.nari.flake = false;

  outputs = {nari, ...}: {
    nixosModules.default = {
      pkgs,
      lib,
      ...
    }: let
      # Note that we're not using an overlay for all packages.
      # Nobody other than wireplumber cares about these rules.
      # But, if we do a global overlay, it causes a mass rebuild
      # of all packages using pipewire, including e.g. all of GNOME
      nari-pkgs = pkgs.extend (final: prev: {
        nari-udev = pkgs.concatTextFile rec {
          name = "91-pulseaudio-razer-nari.rules";
          files = ["${nari}/${name}"];
          destination = "/lib/udev/rules.d/${name}";
        };

        # There is no easy way to extend the alsa profiles in pipewire on nixos.
        # So, the only real option is to override the package ourselves.
        pipewire = prev.pipewire.overrideAttrs ({postInstall ? "", ...}: {
          postInstall =
            ''
              cp ${nari}/razer-nari-{input,output-{game,chat}}.conf $out/share/alsa-card-profile/mixer/paths/
              cp ${nari}/razer-nari-usb-audio.conf $out/share/alsa-card-profile/mixer/profile-sets/
            ''
            + postInstall;
        });
      });
    in {
      config.services = {
        udev.packages = [nari-pkgs.nari-udev];

        pipewire.alsa.enable = lib.mkDefault true;
        # But, wireplumber is the session manager! pipewire doesn't care.
        # So, this wireplumber package is distinct in its dependency on pipewire.
        pipewire.wireplumber.package = nari-pkgs.wireplumber;
      };
    };
  };
}
