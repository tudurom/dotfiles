config.load_autoconfig(False)
c.url.default_page = c.url.start_pages = "https://kagi.com/"
c.url.searchengines = {"DEFAULT": "https://kagi.com/search?q={}"}
c.fonts.default_family = "Berkeley Mono"
c.content.prefers_reduced_motion = True
config.bind(",p", "spawn --userscript 1pass", mode="normal")
config.bind(",d", "config-cycle colors.webpage.darkmode.enabled")
config.bind(",y", "spawn flatpak run org.kde.haruna -- {url}")
config.bind(",Y", "hint links spawn flatpak run org.kde.haruna -- {hint-url}")
# c.qt.args=["enable-features=AcceleratedVideoDecodeLinuxGL"]
# c.qt.environ = {"QTWEBENGINE_FORCE_USE_GBM": "0"}
c.qt.args = [
    "ignore-gpu-blocklist",
    "disable-gpu-memory-buffer-video-frames=false",
    "enable-features="+",".join([
                                "VaapiIgnoreDriverChecks",
                                "VaapiVideoDecoder",
                                "AcceleratedVideoDecoder",
                                "AcceleratedVideoDecodeLinuxGL",
                                "AcceleratedVideoEncoder",
                                "Vulkan",
                                "DefaultANGLEVulkan",
                                "VulkanFromANGLE",
                                "FluentOverlayScrollbar",
                                "MiddleClickAutoscroll"
                            ]),
]

