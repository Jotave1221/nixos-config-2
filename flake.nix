{
  description = "Nixos flake";

  # De onde vêm os pacotes. Pode trocar por "nixos-unstable" se quiser versões mais novas
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
  };

  outputs = { self, nixpkgs, ... }: {
    nixosConfigurations = {
      # Esse nome tem que ser igual ao seu networking.hostName
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
        ];
      };
    };
  };
}