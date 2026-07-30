let
  achuie-svalbard = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICPvDDEW8oP7z/1C8RRh9UI0SlSwodbktUQwXuEMcF8n achuie@svalbard";
  achuie-sprocket = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPE/idtQ9eNHQJ2p7YiiHrDPGJxQnwXB2/grHhZoIRcx achuie@sprocket";
  users = [ achuie-svalbard achuie-sprocket ];

  svalbard = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDUq7jGIU/5Xr/CnDyEB+L+1xU30SQ+IPejv+t277kMS root@svalbard";
  buoy = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKiRktAoS5i7GBd5L5RxtTj6v514Yuc5NYPioNyijBfz root@buoy";
  systems = [ svalbard buoy ];
in
{
  "porkbun_api.age".publicKeys = systems ++ [ achuie-svalbard achuie-sprocket ];
  "headscale_acl.age".publicKeys = [ buoy achuie-svalbard achuie-sprocket ];
  "svalbard_tailscale_key.age".publicKeys = [ svalbard achuie-svalbard achuie-sprocket ];
}
