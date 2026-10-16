{pkgs, ...}: {
  # Additional hardware services for the AMD ThinkPad T14 Gen 1 (Renoir).
  # Generated CPU and storage settings live in hosts/nnn/hardware-configuration.nix.

  # Mesa's Radeon driver provides VA-API; keep vainfo available for inspection.
  environment.systemPackages = [pkgs.libva-utils];

  # Firmware updates via LVFS: `fwupdmgr refresh && fwupdmgr update` pulls
  # BIOS/EC/Thunderbolt updates. ThinkPads are well supported upstream.
  services.fwupd.enable = true;

  # Thunderbolt / USB4 device authorization (docks, eGPUs, TB SSDs).
  # `boltctl` lists and authorizes devices.
  services.hardware.bolt.enable = true;

  # Compressed RAM swap. Faster than the disk swap partition and saves NVMe
  # wear; with 32 GB RAM the default (50% of RAM) is plenty of headroom.
  # (Note: too small to hibernate 32 GB — that still needs a disk swap ≥ RAM.)
  zramSwap.enable = true;

  # Fingerprint reader (enroll with `fprintd-enroll`). Wires fingerprint auth
  # into PAM for login/sudo via the libfprint stack.
  services.fprintd.enable = true;
}
