{ config, lib, pkgs, ... }:
let cfg = config.LucasNT.system;
in {
  options.LucasNT.system = {
    enableWpaSupplicant = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable wpa_supplicant";
    };

    enableBluetooth = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable bluetooth hardware";
    };

    username = lib.mkOption {
      type = lib.types.str;
      description = "Username of the user of the machine";
    };

    extraEnvironmentPackage = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      description = "List of extra packages for system environment";
    };

    bootKernelParams = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Kernel Parameters";
    };

    extraUserGroups = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "List of extra groups to add user";
    };

    defaultUserPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = with pkgs; [ yadm tmux ];
      description = "List of default packages to install in user";
    };

    extraUserPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      description = "List of extra packages to install in  the user";
    };

    userAuthrorizedKeys = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "List of public keys authorized for the user";
    };

  };

  config = {
    boot = {
      kernelParams = [ ] ++ cfg.bootKernelParams;
      loader = {
        limine.enable = true;
        efi.canTouchEfiVariables = true;
      };
      supportedFilesystems = [ "nfs" ];
      tmp.cleanOnBoot = true;
    };

    console = {
      font = "sun12x22";
      keyMap = "br-abnt2";
    };

    environment.systemPackages = with pkgs;
      [ vim wget curl tmux ] ++ cfg.extraEnvironmentPackage;

    i18n.defaultLocale = lib.mkDefault "pt_BR.UTF-8";

    hardware.bluetooth = lib.mkIf cfg.enableBluetooth {
      enable = true;
      powerOnBoot = false;
    };


    networking.wireless = lib.mkIf cfg.enableWpaSupplicant {
      enable = true;
      allowAuxiliaryImperativeNetworks = true;
      userControlled = true;
    };

    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
      persistent = true;
    };

    programs.git.enable = true;

    security = {
      polkit.enable = true;
      rtkit.enable = true;
    };

    time.timeZone = lib.mkDefault "America/Sao_Paulo";

    users.groups.wifi_controller = lib.mkIf cfg.enableWpaSupplicant (lib.mkDefault { });

    users.users."${cfg.username}" = {
      isNormalUser = true;
      extraGroups = lib.mkMerge [
        [ "wheel" ]
        cfg.extraUserGroups
        (lib.lists.optionals cfg.enableWpaSupplicant [ "wpa_supplicant" ])
      ];
      packages = lib.mkMerge [
        cfg.defaultUserPackages
        cfg.extraUserPackages
        [ pkgs.helix ]
      ];
      openssh.authorizedKeys.keys = cfg.userAuthrorizedKeys;
    };
  };
}
