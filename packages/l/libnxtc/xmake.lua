package("libnxtc")
    set_homepage("https://github.com/DarkMatterCore/libnxtc")
    set_description("Provides an easy way for libnx-based homebrew applications for the Nintendo Switch to populate a title cache and store it on the console's SD card. ")
    set_license("ISC")

    set_urls("https://github.com/DarkMatterCore/libnxtc/archive/refs/tags/v$(version).tar.gz")
    --insert version
    add_versions("0.0.2", "e3e9bfe51c6ca25d5baccbd85a058d598f6a4609ccd10c70ae374b3d191fde8e")

    add_deps("libnx")

    on_install(function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)
