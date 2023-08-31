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
                    ];
                    
                    shellHook = ''
                        source ./entrypoint.sh
                    '';
                };
            };
        }
    );
}