{
  description = "NodeJS app with Terraform and MySQL";

  inputs = {
    novops.url = "github:novadiscovery/novops";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, novops, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
        let 
            pkgs = nixpkgs.legacyPackages.${system};
            novopsPackage = novops.packages.${system}.novops; 
        in {
            devShells = {
                default = pkgs.mkShell {
                    packages = [ 
                        pkgs.bashInteractive # entrypoint uses bash
                        pkgs.nodejs_20
                        pkgs.nodePackages.npm
                        pkgs.terraform
                        pkgs.mysql80
                        pkgs.awscli2

                        # Docker alternative
                        pkgs.podman
                        pkgs.podman-compose

                        pkgs.vault
                        novopsPackage # Include Novops package in your shell
                    ];
                    
                    shellHook = ''
                        source ./entrypoint.sh
                    '';
                };
            };
        }
    );
}