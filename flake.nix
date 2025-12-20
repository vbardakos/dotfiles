{
  description = "Vasilis's cross-OS dotfiles via Nix + Home Manager (parametrized, with wrapper app)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Optional: nix-darwin for macOS system-level config (you can wire this later)
    darwin.url = "github:nix-darwin/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, darwin, ... }:
    let
      # Helper: import pkgs for a given system
      pkgsFor = system: import nixpkgs { inherit system; };

      # A function that returns a Home Manager activation package
      mkHome = { system, username, homeDir }:
        home-manager.lib.homeManagerConfiguration {
          inherit system;
          pkgs = pkgsFor system;
          # Pass the dotfiles root path down, so modules can reference it.
          extraSpecialArgs = {
            dotfilesRoot = ./dotfiles;
            inherit inputs;
          };
          modules = [
            ./modules/common/home.nix
            {
              home.username = username;
              home.homeDirectory = homeDir;
            }
          ];
        };

    in
    {
      # Pure, parameterized entry-point that we can build:
      #   nix build .#homeConfigurationsDynamic --argstr system x86_64-linux --argstr username vasilis --argstr homeDir /home/vasilis
      homeConfigurationsDynamic = { system, username, homeDir }:
        mkHome { inherit system username homeDir; };

      # Friendly wrapper app so you can run: nix run .#apply -- --username vasilis --home /home/vasilis [--system x86_64-linux]
      apps.x86_64-linux.apply =
        let
          pkgs = pkgsFor "x86_64-linux";
        in
        {
          type = "app";
          program = pkgs.writeShellApplication
            {
              name = "apply";
              runtimeInputs = [ pkgs.coreutils pkgs.nix ];
              text = ''
                set -euo pipefail
                usage() {
                  echo "Usage: nix run .#apply -- --username <name> --home <dir> [--system <triple>]"
                }
                USERNAME=""
                HOME_DIR=""
                DEFAULT_SYSTEM="${pkgs.stdenv.hostPlatform.system}"
                SYSTEM="$DEFAULT_SYSTEM"
                while [ $# -gt 0 ]; do
                  case "$1" in
                    --username) USERNAME="$2"; shift 2;;
                    --home)     HOME_DIR="$2"; shift 2;;
                    --system)   SYSTEM="$2";   shift 2;;
                    -h|--help)  usage; exit 0;;
                    *) echo "Unknown arg: $1"; usage; exit 2;;
                  esac
                done
                if [ -z "$USERNAME" ] || [ -z "$HOME_DIR" ]; then
                  echo "Error: --username and --home are required."; usage; exit 2
                fi
                echo "[apply] system=$SYSTEM user=$USERNAME home=$HOME_DIR"
                nix build .#homeConfigurationsDynamic \
                  --argstr system "$SYSTEM" \
                  --argstr username "$USERNAME" \
                  --argstr homeDir "$HOME_DIR"
                echo "[apply] activating..."
                ./result/activate
                echo "[apply] done."
              '';
            } + "/bin/apply";
        };

      apps.aarch64-darwin.apply =
        let
          pkgs = pkgsFor "aarch64-darwin";
        in
        {
          type = "app";
          program = pkgs.writeShellApplication
            {
              name = "apply";
              runtimeInputs = [ pkgs.coreutils pkgs.nix ];
              text = ''
                set -euo pipefail
                usage() {
                  echo "Usage: nix run .#apply -- --username <name> --home <dir> [--system <triple>]"
                  # echo "  Example (macOS): nix run .#apply -- --username ${USER} --home ${HOME} --system ${pkgs.stdenv.hostPlatform.system}"
                }
                USERNAME=""
                HOME_DIR=""
                DEFAULT_SYSTEM="${pkgs.stdenv.hostPlatform.system}"
                SYSTEM="$DEFAULT_SYSTEM"
                while [ $# -gt 0 ]; do
                  case "$1" in
                    --username) USERNAME="$2"; shift 2;;
                    --home)     HOME_DIR="$2"; shift 2;;
                    --system)   SYSTEM="$2";   shift 2;;
                    -h|--help)  usage; exit 0;;
                    *) echo "Unknown arg: $1"; usage; exit 2;;
                  esac
                done
                if [ -z "$USERNAME" ] || [ -z "$HOME_DIR" ]; then
                  echo "Error: --username and --home are required."; usage; exit 2
                fi
                echo "[apply] system=$SYSTEM user=$USERNAME home=$HOME_DIR"
                nix build .#homeConfigurationsDynamic \
                  --argstr system "$SYSTEM" \
                  --argstr username "$USERNAME" \
                  --argstr homeDir "$HOME_DIR"
                echo "[apply] activating..."
                ./result/activate
                echo "[apply] done."
              '';
            } + "/bin/apply";
        };

      # (Optional) later you can add darwinConfigurations / nixosConfigurations here
      # using `darwin.lib.darwinSystem` or `nixpkgs.lib.nixosSystem`.  see docs.
    };
}
