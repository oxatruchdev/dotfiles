{
  description = "Pro nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";


    # Homebrew config
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    # Optional: Declarative tap management
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
  };


  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew, homebrew-core, homebrew-cask, homebrew-bundle, ... }:
    let
      configuration = { pkgs, config, ... }: {
        nixpkgs.config.allowUnfree = true;

        # List packages installed in system profile. To search by name, run:
        # $ nix-env -qaP | grep wget
        environment.systemPackages =
          [
            pkgs.alacritty


            #Communication
            pkgs.discord
            pkgs.mkalias
            pkgs.git
            pkgs.neovim
            pkgs.tmux

            ## Utilities
            pkgs.ripgrep
            pkgs.fzf
            # pkgs.teams

	    # Configuration
	    pkgs.chezmoi
            pkgs.oh-my-zsh
            pkgs.zsh-powerlevel10k

            #Languages
            pkgs.go
            pkgs.typescript
            pkgs.nodejs_23
            pkgs.nodejs_22
            pkgs.nodejs_20
            pkgs.nodejs_18
            pkgs.cargo
            pkgs.rustc
          ];

        fonts.packages = with pkgs; [
          nerd-fonts.meslo-lg
          nerd-fonts.jetbrains-mono
        ];

        nix.enable = false;

        # Necessary for using flakes on this system.
        nix.settings.experimental-features = "nix-command flakes";

        system.activationScripts.applications.text =
          let
            env = pkgs.buildEnv {
              name = "system-applications";
              paths = config.environment.systemPackages;
              pathsToLink = "/Applications";
            };
          in
          pkgs.lib.mkForce ''
            					# Set up applications.
            					echo "setting up /Applications..." >&2
            					rm -rf /Applications/Nix\ Apps
            					mkdir -p /Applications/Nix\ Apps
            					find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
            					while read -r src; do
            						app_name=$(basename "$src")
            						echo "copying $src" >&2
            						${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
            					done
            							'';

        # Enable alternative shell support in nix-darwin.
        # programs.fish.enable = true;
      programs.zsh = {
        # Enable Zsh and Powerlevel10k
          enable = true;
          promptInit = ''
            source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
          '';
        };
        # Set Git commit hash for darwin-version.
        system.configurationRevision = self.rev or self.dirtyRev or null;

        # Used for backwards compatibility, please read the changelog before changing.
        # $ darwin-rebuild changelog
        system.stateVersion = 6;

        # The platform the configuration will be used on.
        nixpkgs.hostPlatform = "aarch64-darwin";

      };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#simple
      darwinConfigurations."pro" = nix-darwin.lib.darwinSystem {
        modules = [
          configuration

          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              # Install Homebrew under the default prefix
              enable = true;

              # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
              enableRosetta = true;

              # User owning the Homebrew prefix
              user = "oscar";

              # Optional: Declarative tap management
              taps = {
                "homebrew/homebrew-core" = homebrew-core;
                "homebrew/homebrew-cask" = homebrew-cask;
                "homebrew/homebrew-bundle" = homebrew-bundle;
              };

              # Optional: Enable fully-declarative tap management
              #
              # With mutableTaps disabled, taps can no longer be added imperatively with `brew tap`.
              mutableTaps = false;
            };
          }
        ];
      };
      formatter.aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.nixpkgs-fmt;
    };

}
