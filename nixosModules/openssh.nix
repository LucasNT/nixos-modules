{ config, lib, pkgs, username, ... }:
{
  config = {
    services.openssh = {
      enable = true;
      ports = lib.mkDefault [ 22 ];
      hostKeys = [
        {
          bits = 4096;
          path = "/etc/ssh/ssh_host_rsa_key";
          type = "rsa";
        }
        {
          path = "/etc/ssh/ssh_host_ed25519_key";
          type = "ed25519";
        }
        {
          path = "/etc/ssh/ssh_host_mldsa44-ed25519_key";
          type = "mldsa44-ed25519";
        }
      ];
      settings = {
        AllowGroups = [ "ssh_users" ];
        PermitRootLogin = "no";
        AuthenticationMethods= "publickey";
        KexAlgorithms =  [
        	"mlkem768x25519-sha256"
        	"sntrup761x25519-sha512"
        	"sntrup761x25519-sha512@openssh.com"
        ];
      };
    };
  };
}
