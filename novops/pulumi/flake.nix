{
  inputs = {
    novops.url = "github:PierreBeucher/novops";
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
                        pkgs.pulumi
                        pkgs.pulumiPackages.pulumi-language-nodejs
                        pkgs.awscli2
                        pkgs.gnumake
                        pkgs.pv

                        # Docker alternative
                        pkgs.podman
                        pkgs.podman-compose


                        pkgs.vault
                        novopsPackage # Include Novops package in your shell
                    ];
                    
                    shellHook = ''
                        mkdir -p .pulumi-backend
                        export VAULT_ADDR="http://localhost:8200"
                        export VAULT_TOKEN="rootToken"
                        export PULUMI_BACKEND_URL=file:///home/pbeucher/git/devops-examples/novops/pulumi/.pulumi-backend
                        export AWS_PROFILE=crafteo-crafteo 
                    '';
                };
            };
        }
    );
}