# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      ./keybase.nix
    ];


  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.consoleUseXkbConfig = true;
  # i18n = {
  #   consoleFont = "Lat2-Terminus16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # Set your time zone.
  time.timeZone = "Europe/Madrid";

  # Allow non free packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    firefox
    keepassxc
    tdesktop
    steam
    keybase
    keybase-gui
    google-chrome
    gitAndTools.hub
    hyper
    albert
    simplescreenrecorder

    # KDE
    spectacle
    kate

    # Tools
    ipfs
    docker-compose
    yarn
    nodejs-11_x
    python

    # CLI
    zsh
    fd # alternative to find
    exa
    tmux
    ripgrep
    xclip
    wget
    vim
    git
    neovim

    gnumake
    gcc8
    binutils

    # Linux tools
    pciutils # lspci etc.
    lshw # hardware information tool

    # dropbox - we don't need this in the environment. systemd unit pulls it in
    dropbox-cli
  ];

  # Touchpad scroll on Firefox
  environment.variables.MOZ_USE_XINPUT2 = "1";

  # Enables 256 colors in Konsole
  environment.variables.TERM = "konsole-256color";

  # Steam
  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio.support32Bit = true;

  programs.ssh.startAgent = true;
  programs.ssh.agentTimeout = "24h";

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  networking.firewall = {
    allowedTCPPorts = [
      17500 # dropbox
    ];
    allowedUDPPorts = [
      17500 # dropbox
    ];
  };


  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "fr";
  services.xserver.xkbVariant = "bepo";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable touchpad support.
  services.xserver.libinput.enable = true;
  services.xserver.libinput.naturalScrolling = true;

  # Enable the KDE Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  # services.xserver.desktopManager.lxqt.enable = true;
  # services.xserver.desktopManager.mate.enable = true;

  virtualisation.docker.enable = true;

  # Dropbox
  systemd.user.services.dropbox = {
    description = "Dropbox";
    wantedBy = [ "graphical-session.target" ];
    environment = {
      QT_PLUGIN_PATH = "/run/current-system/sw/" + pkgs.qt5.qtbase.qtPluginPrefix;
      QML2_IMPORT_PATH = "/run/current-system/sw/" + pkgs.qt5.qtbase.qtQmlPrefix;
    };
    serviceConfig = {
      ExecStart = "${pkgs.dropbox.out}/bin/dropbox";
      ExecReload = "${pkgs.coreutils.out}/bin/kill -HUP $MAINPID";
      KillMode = "control-group"; # upstream recommends process
      Restart = "on-failure";
      PrivateTmp = true;
      ProtectSystem = "full";
      Nice = 10;
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.pierre = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ]; # wheel = enable ‘sudo’ for the user.
    shell = pkgs.zsh;
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?

}
