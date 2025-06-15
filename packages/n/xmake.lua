package("nxtc")
    set_homepage("https://github.com/DarkMatterCore/libnxtc")
    set_description("Provides an easy way for libnx-based homebrew applications for the Nintendo Switch to populate a title cache and store it on the console's SD card. ")
    set_license("ISC")

    set_urls("https://github.com/DarkMatterCore/libnxtc/releases/download/v0.0.2/libnxtc_$(version).tar.bz2")
    -- insert version
    add_versions("0.0.2-main-6b7f517", "d47a0b7195c409e79806e27df5087600278ffaf89470238c04292645cfc27587")

    add_deps("libnx")

    on_install(function (package)
        os.cp("include", package:installdir())
        os.cp("lib/libnxtc.a", package:installdir("lib"))
    end)
