{...}: serviceConfig:
{
  CapabilityBoundingSet = [""];
  DeviceAllow = [""];
  LockPersonality = true;
  MemoryDenyWriteExecute = true;
  PrivateDevices = true;
  PrivateUsers = true;
  ProcSubset = "pid";
  ProtectClock = true;
  ProtectControlGroups = true;
  ProtectHome = true;
  ProtectHostname = true;
  ProtectKernelLogs = true;
  ProtectKernelModules = true;
  ProtectKernelTunables = true;
  ProtectProc = "invisible";
  RestrictAddressFamilies = ["AF_INET" "AF_INET6" "AF_UNIX"];
  RestrictNamespaces = true;
  RestrictRealtime = true;
  RestrictSUIDSGID = true;
  SystemCallArchitectures = "native";
  SystemCallFilter = ["@system-service" "~@privileged"];
  UMask = "0077";
}
// serviceConfig
