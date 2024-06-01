{ pkgs, stdenv, cmocka }:

cmocka.overrideAttrs (oldAttrs: {
  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=OFF"
    "-DUNIT_TESTING=OFF"
  ];

})
