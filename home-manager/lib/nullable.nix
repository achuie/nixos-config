{ config, lib, ... }:

let
  nullMarker = "___IGNORED_NULLABLE_PACKAGE___";

  fakePkg = orig:
    builtins.trace
    "\n  nullable skipped ${orig}\n"
    {
    __nullable = nullMarker;
    __toString = _: "";
    pname = orig.pname or orig.name or "fake";
    version = "0.0.0";
    outPath = "/dev/null";
    type = "derivation";
    name = "fake-${orig.pname or orig.name or "pkg"}";
    orig = orig;
  };

  wrap = drv:
    if cfg.enable then
      fakePkg drv
    else drv;

  cfg = config.nullable;
in {
  options.nullable = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Nullify packages and string coercion in modules that opt-in.";
    };

    wrap = lib.mkOption {
      type = lib.types.functionTo lib.types.anything;
      readOnly = true;
      description = "Wrap a derivation to suppress build and string coercion if nullable is enabled.";
    };
  };

  config.nullable.wrap = wrap;
}
