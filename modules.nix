{ lib, name }:
modules:
let
  hasModule = moduleName: builtins.elem moduleName modules;
in
  [ ./modules/common.nix ] ++
  lib.optional (hasModule "server") ./modules/server.nix ++
  lib.optional (hasModule "desktop") ./modules/pc.nix ++
  lib.optional (hasModule "amdgpu") ./modules/amdgpu.nix ++
  lib.optional (hasModule "desktop") ./modules/desktop ++
  lib.optional (hasModule "virtualisation") ./modules/virtualisation ++
  lib.optional (hasModule "qemu") ./modules/virtualisation/qemu.nix ++
  lib.optional (hasModule "docker") ./modules/virtualisation/docker.nix ++
  lib.optional (hasModule "waydroid") ./modules/virtualisation/waydroid.nix ++
  lib.optionals (hasModule "laptop") [
    ./modules/pc.nix
    ./modules/laptop.nix
  ] ++
  lib.optionals (hasModule "gaming") [
    ./modules/desktop
    ./modules/gaming.nix
  ] ++
  lib.optionals (hasModule "development") [
    ./modules/desktop
    ./modules/development.nix
  ] ++
  lib.optionals (hasModule "cad") [
    ./modules/desktop
    ./modules/cad
  ] ++
  lib.optionals (hasModule "office") [
    ./modules/desktop
    ./modules/office.nix
  ] ++
  lib.optionals (hasModule "movies") [
    ./modules/desktop
    ./modules/movies.nix
  ] ++
  [ ./hardware/${name}.nix ] ++
  [ ./hosts/${name}.nix ]
