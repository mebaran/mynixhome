{
  pkgs,
  lib,
}: let
  pgserviceparser = pkgs.python3Packages.buildPythonPackage {
    pname = "pgserviceparser";
    version = "2.5.0";
    format = "wheel";
    src = pkgs.fetchurl {
      url = "https://files.pythonhosted.org/packages/24/ed/e21fa2abdc139c4f8b2b2d57ba02e93309455a6b85ab1be0bb3db449b407/pgserviceparser-2.5.0-py3-none-any.whl";
      sha256 = "899ef9d82ea8a5980a777af93d10145b701954d8d43480c2eb2c901d0c469f71";
    };
    pythonImportsCheck = ["pgserviceparser"];
  };
  python = pkgs.python3.withPackages (_: [pgserviceparser]);
in
  pkgs.writeScriptBin "pgservicedburi" (lib.replaceStrings
    ["#!/usr/bin/env python3"]
    ["#!${python}/bin/python3"]
    (builtins.readFile ../scripts/pgservicedburi.py))
