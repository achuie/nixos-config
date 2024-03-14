{ where-is-my-sddm-theme }:

(where-is-my-sddm-theme.overrideAttrs (finalAttrs: prevAttrs: {
  patches = prevAttrs.patches or [ ] ++ [ ./longInputBox.patch ];
})).override {
  themeConfig.General = {
    cursorColor = "#ffffff";
    backgroundMode = "aspect";
    background = "${builtins.fetchurl
      {
        url =
          "https://media.githubusercontent.com/media/achuie/achuie.github.io/master/images/portfolio/Shrine_Across_a_Pond.jpg";
        sha256 = "01765s6d5mkawah6cgidwizi9b2qjy9s8bsx5nb5p6194qln4ldp";
      }}";
  };
}
