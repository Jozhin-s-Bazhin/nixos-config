{ ... }:

{
  users.users.roman = {
    isNormalUser = true;
    description = "Roman Bezroutchko";
    extraGroups = [ "networkmanager" "wheel" "audio" "fuse" ];
  };
}