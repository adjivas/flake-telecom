{ stdenv, lib, fetchFromGitHub, kernel, kmod}:


stdenv.mkDerivation rec {
  pname = "gtp5g";
  version = "1.0"; # Adjust version as necessary

  src = fetchFromGitHub {
    owner = "free5gc";
    repo = "gtp5g";
    rev = "v0.9.1";
    sha256 = "n4YhgySVjceRRHxoaGd4Z+Rf2MgD6+upZTcS6xMLLJ0=";
  };

 # patches = [ ./nix.patch ];

  hardeningDisable = [ "pic" "format" ];
  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = [
    "KVERSION=${kernel.modDirVersion}"
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "INSTALL_MOD_PATH=$(out)"
  ];
  installPhase = ''
    runHook preInstall

    install *.ko -Dm444 -t $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/gtp5g

    runHook postInstall
  '';

  meta = with lib; {
    description = "GTPv5 Kernel Module";
    license = licenses.gpl3; # or whatever license applies
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}

