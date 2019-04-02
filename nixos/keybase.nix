# From https://gist.github.com/taktoa/3133a4d9b1614fad1f4841f145441406
# ====================================================================
#
# Add this file to your /etc/nixos/configuration.nix `imports = [ ... ];` attribute.
#
# After running `nixos-rebuild switch`, `systemctl --user start keybase-gui.service`
# can be used to start the Keybase GUI.
#
# Not sure if it's just my tiling window manager, but there is a bit of wonkiness
# with the tray icon. Other than that it works perfectly (as of 2017/11/22).

{ pkgs, ... }:

{
  services.kbfs = {
    enable = true;
    mountPoint = "%t/kbfs";
    extraFlags = [ "-label %u" ];
  };

  systemd.user.services = {
    keybase.serviceConfig.Slice = "keybase.slice";

    kbfs = {
      environment = { KEYBASE_RUN_MODE = "prod"; };
      serviceConfig.Slice = "keybase.slice";
    };

    keybase-gui = {
      description = "Keybase GUI";
      requires = [ "keybase.service" "kbfs.service" ];
      after    = [ "keybase.service" "kbfs.service" ];
      serviceConfig = {
        ExecStart  = "${pkgs.keybase-gui}/share/keybase/Keybase";
        PrivateTmp = true;
        Slice      = "keybase.slice";
      };
    };
  };
}
