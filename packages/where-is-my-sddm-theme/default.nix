{ where-is-my-sddm-theme }:

where-is-my-sddm-theme.override {
  themeConfig.General = {
    cursorColor = "#ffffff";
    backgroundMode = "aspect";
    passwordInputWidth = 0.9;
    background = "${builtins.fetchurl
      {
        url =
          "https://media.githubusercontent.com/media/achuie/achuie.github.io/master/images/portfolio/Shrine_Across_a_Pond.jpg";
        sha256 = "01765s6d5mkawah6cgidwizi9b2qjy9s8bsx5nb5p6194qln4ldp";
      }}";
  };
}
