{
  description = "LucasNT nixos modules";
  inputs = { };

  outputs = { self }:
  {
    nixosModules = {
      baseSystem = import ./nixosModules/baseSystem;
      docker = import ./nixosModules/docker.nix;
      hardenedOpenssh = import ./nixosModules/openssh.nix;
      qmk = import ./nixosModules/qmk.nix;
      gui = import ./nixosModules/graphical-interface.nix;
    };
  };
}
