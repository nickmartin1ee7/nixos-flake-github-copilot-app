{
  lib,
  appimageTools,
  fetchurl,
}:

let
  pname = "github-copilot-app";
  version = "1.1.9";

  src = fetchurl {
    url = "https://github.com/github/app/releases/download/v${version}/GitHub-Copilot-linux-x64.AppImage";
    hash = "sha256-mSHzD+bp9jwOvJ+wZCyrCL8+GdrLvjrWKsrLMBAhumQ=";
  };

  appimageContents = appimageTools.extract {
    inherit pname version src;
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -Dm444 '${appimageContents}/usr/share/applications/GitHub Copilot.desktop' \
      $out/share/applications/github-copilot.desktop
    install -Dm444 '${appimageContents}/GitHub Copilot.png' \
      $out/share/icons/hicolor/512x512/apps/github.png

    substituteInPlace $out/share/applications/github-copilot.desktop \
      --replace-fail 'Exec=github' 'Exec=${pname}'
  '';

  meta = {
    description = "Agent-native desktop experience from GitHub Copilot";
    homepage = "https://github.com/github/app";
    license = lib.licenses.unfree;
    mainProgram = pname;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
