{ stdenv, lib, fetchurl, pkgs }:

let
 cc = stdenv.cc;
 # from nixpkgs
 archiveVersion = version:
    let
      fragments = lib.splitVersion version;
      major = lib.head fragments;
      minor = lib.concatMapStrings (lib.fixedWidthNumber 2) (lib.tail fragments);
    in
    major + minor + "00";
in
stdenv.mkDerivation rec {
  pname = "sqlite-dev";
  version = "3.45.3";

  src = with lib; let
    relYear = "2024";
    finalvstr = archiveVersion version;
  in fetchurl {
    url = "https://www.sqlite.org/${relYear}/sqlite-autoconf-${finalvstr}.tar.gz";
    sha256 = "sha256-soCcpTEkwZxg9Cv2J3NurgEa/cwgW7SCcKXumjgZFTE=";
  };

  buildInputs = [ cc ];

  makeFlags = [
    "CC_FOR_BUILD=${cc}"
    "CC=${cc}"
    "CFLAGS=-DSQLITE_ENABLE_COLUMN_METADATA=1 -DSQLITE_ENABLE_FTS3=1 -DSQLITE_ENABLE_FTS4=1 -DSQLITE_ENABLE_FTS5=1 -DSQLITE_ENABLE_JSON1=1 -DSQLITE_ENABLE_RTREE=1 -DSQLITE_ENABLE_SESSION=1 -DSQLITE_ENABLE_UNLOCK_NOTIFY=1 -DSQLITE_HAVE_ISNAN -DSQLITE_SOUNDEX -DSQLITE_THREADSAFE=1 -DSQLITE_USE_URI=1 -O2 -DNDEBUG"
    "LDFLAGS=-static"
  ];

  configureFlags = [
    "--disable-shared"
    "--enable-static"
  ];

  buildPhase = ''
    make
  '';

  installPhase = ''
    make install
  '';

  # remove binary & man, leave only .a & .h
  preFixup = ''
    rm -r $out/bin $out/share
  '';

  meta = {
    description = "SQLite is a software library that provides a relational database management system.";
    homepage = https://www.sqlite.org/;
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
  };
}
