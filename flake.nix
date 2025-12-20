{
  description = "Home Manager configuration";

  outputs = { self }: {
    templates = {
      minimal = {
        path = ./nix/minimal;
        description = "Minimal configuration";
      };

      default = self.templates.minimal;
    };
  };
}
