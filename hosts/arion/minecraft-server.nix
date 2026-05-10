{ config, pkgs, lib, ... }:

{
  services.minecraft-server = {
    enable = true;
    openFirewall = true;
    package = pkgs.papermc;
    eula = true;
    # flags from: https://docs.papermc.io/paper/aikars-flags/
    jvmOpts = builtins.concatStringsSep " " [
      "-Xmx12g"
      "-Xms4g"
      "-XX:+UseG1GC"
      "-XX:+ParallelRefProcEnabled"
      "-XX:MaxGCPauseMillis=200"
      "-XX:+UnlockExperimentalVMOptions"
      "-XX:+DisableExplicitGC"
      "-XX:+AlwaysPreTouch"
      "-XX:G1NewSizePercent=30"
      "-XX:G1MaxNewSizePercent=40"
      "-XX:G1HeapRegionSize=8M"
      "-XX:G1ReservePercent=20"
      "-XX:G1HeapWastePercent=5"
      "-XX:G1MixedGCCountTarget=4"
      "-XX:InitiatingHeapOccupancyPercent=15"
      "-XX:G1MixedGCLiveThresholdPercent=90"
      "-XX:G1RSetUpdatingPauseTimePercent=5"
      "-XX:SurvivorRatio=32"
      "-XX:+PerfDisableSharedMem"
      "-XX:MaxTenuringThreshold=1"
      "-Dusing.aikars.flags=https://mcflags.emc.gs"
      "-Daikars.new.flags=true"
      ];
    };
}

# notes
# To be able to easily work with the server (at /var/lib/minecraft) after setup,
# sudo chmod 2750 /var/lib/minecraft && sudo chmod -R g+rwX /var/lib/minecraft

