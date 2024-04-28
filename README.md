# NixOS + Razer Nari

This flake contains a NixOS module that adds PipeWire profiles and udev rules allowing a Razer Nari headset to be recognized properly.

This does not work on other operating systems. This is not compatible with home-manager.

This only works with PipeWire + WirePlumber. This is the default audio stack on NixOS.

# Usage

Add this repo to your system flake inputs and then import its default NixOS module.

```nix
{
  inputs = {
    nari.url = "github:sodiboo/nixos-razer-nari";
  };

  outputs = { nixpkgs, nari, ... }: {
    nixosConfigurations.my-system = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        nari.nixosModules.default
      ];
    };
  }
}
```

There are no other outputs. There are no additional options.

This flake is fairly small. You should be able to read and fully understand the `flake.nix` in this repo.
