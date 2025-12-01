{
  lib,
  siteLib,
  ...
}: {
  time =
    {
      timeZone = "Asia/Tokyo";
    }
    // lib.optionalAttrs siteLib.isLinux {
      hardwareClockInLocalTime = false;
    };
}
