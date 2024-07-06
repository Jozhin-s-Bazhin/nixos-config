{ username, ... }:

{
  networking.networkmanager.enable = true;  # I assume you have ethernet on a desktop
  users.users.${username}.extraGroups = [ "networkmanager" ];
}
