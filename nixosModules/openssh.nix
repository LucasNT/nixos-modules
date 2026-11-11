{ config, lib, pkgs, username, ... }:
{
  config = {
      services.openssh = {
      enable = true;
      ports = lib.mkDefault [ 22 ];
      settings = {
        AllowGroups = [ "ssh_users" ];
        PermitRootLogin = "no";
        KexAlgorithms =  [
        	"mlkem768x25519-sha256"
        	"sntrup761x25519-sha512"
        	"sntrup761x25519-sha512@openssh.com"
        	"ssh-mldsa44-ed25519@openssh.com"
        ];
      };
    };
  };
}
