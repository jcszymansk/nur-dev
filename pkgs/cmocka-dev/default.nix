{ pkgs, stdenv, cmocka }:

let
  mylib = import ../../lib/default.nix { inherit pkgs; };
in
cmocka.overrideAttrs (oldAttrs: {
  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=OFF"
    "-DUNIT_TESTING=OFF"
  ];

  setupHook = mylib.mkStaticSetupHook [ "cmocka" ];
})
