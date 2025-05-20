# NiX1-Control-Panel

A simple repackaging of the [X1 Control Panel linux version](https://support.swiftpoint.com/portal/en/community/topic/x1-control-panel-experimental-linux-version-18-7-2023) made [by Swiftpoint](https://www.swiftpoint.de).

### Usage:

Add the flake to your inputs:
```nix
x1-control-panel = {
  url = "github:Blu3SoulsIT/NiX1-Control-Panel";
  # Make it follow your nixpkgs if you want.
  #inputs.nixpkgs.follows = "<unstable>";
};
```

Add this to your configuration:
```nix
environment.systemPackages = [ # or 'home.packages = [' if you're using home manager.
  inputs.x1-control-panel.packages.<system>.default
];
```

Finally add the udev rules:
```nix
services.udev.packages = [ inputs.x1-control-panel.packages.<system>.default ];
```
