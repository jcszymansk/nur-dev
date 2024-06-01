{ pkgs, cjson }:

cjson.overrideAttrs (oldAttrs: {
  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=Off"
  ];

})
