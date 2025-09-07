local function getVersion(version)
    local versions ={
        ["2024.04.23-alpha"] = "archive/ae9b053ce527faaef5356d1acfd4f7a392604451.tar.gz",
        ["2024.07.03"] = "archive/5abaa17b01709656a8a03ce5f041094e2dfb32ad.tar.gz",
        ["2024.07.06"] = "archive/009fe776a29510202d73d576708c41ec9d5b461b.tar.gz",
        ["2025.03.28"] = "archive/3ecf2de10226392ecb071c470bea9758a24cd6b1.tar.gz",
        ["2025.09.07"] = "archive/1553db83c5bcb586991818380f7aad21e0d22bb1.tar.gz",
    }
    return versions[tostring(version)]
end

package("borealis")
    set_homepage("https://github.com/xfangfang/borealis")
    set_description("Hardware accelerated, Nintendo Switch inspired UI library for PC, Android, iOS, PSV, PS4 and Nintendo Switch")
    set_license("Apache-2.0")

    set_urls("https://github.com/xfangfang/borealis/$(version)", {
        version = getVersion
    })
    add_versions("2024.04.23-alpha", "f1dde726c122af4a40941ce8e0b27655eda9b0bc6e80d4e9034f5c7978b3e288")
    add_versions("2024.07.03", "16a8e6c7369fc2a002a81bd70ee517cfd3b2e7dc221d8d7ba7f67519ca7697d8")
    add_versions("2024.07.06", "c82fae079082d64e92f45d158dc27b44f69ea5c93527f0bf51adc756fd73d389")
    add_versions("2025.03.28", "21f9197ca646f7067bcb56f6c28e684ed6b0f9cc049cbd4d1a2ded0af8c1296e")
    add_versions("2025.09.07", "f544ade519d51d3c7207485225bf526ef91e04bc4988da8a28ef489a455b55ba")

    add_configs("window", {description = "use window lib", default = "glfw", type = "string"})
    add_configs("driver", {description = "use driver lib", default = "opengl", type = "string"})
    add_configs("winrt", {description = "use winrt api", default = false, type = "boolean"})
    add_deps(
        "nanovg",
        "yoga =2.0.1",
        "nlohmann_json",
        "fmt",
        "tweeny",
        "stb",
        "tinyxml2"
    )
    add_includedirs("include")
    if is_plat("windows") then
        add_includedirs("include/compat")
        add_syslinks("wlanapi", "iphlpapi", "ws2_32")
    elseif is_plat("cross") then 
        add_deps("libnx", "glm")
    end
    
    on_load(function (package)
        local window = package:config("window")
        local driver = package:config("driver")
        local winrt = package:config("winrt")
        if window == "glfw" then
            package:add("deps", "glfw")
        elseif window == "sdl" then
            package:add("deps", "sdl2")
        elseif window == "nanovg" then
            if is_plat("cross") then
                package:add("deps", "deko3d")
            end
        end
        if driver == "opengl" then
            --package:add("deps", "glad =0.1.36")
        elseif driver == "d3d11" then
            package:add("syslinks", "d3d11")
        end
        if winrt then
            package:add("syslinks", "windowsapp")
        end
    end)
    on_install(function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {}
        configs["window"] = package:config("window")
        configs["driver"] = package:config("driver")
        configs["winrt"] = package:config("winrt") and "y" or "n"
        import("package.tools.xmake").install(package, configs)
        os.cp("library/include/*", package:installdir("include").."/")
        os.rm(package:installdir("include/borealis/extern"))
        os.cp("library/include/borealis/extern/libretro-common", package:installdir("include").."/")
    end)

    on_test(function (package)
        assert(package:check_cxxsnippets({test = [[
            #include <borealis.hpp>

            static void test() {
                volatile void* i = (void*)&brls::Application::init;
                if (i) {};
            }
        ]]}, {
            configs = {languages = "c++20", defines = { "BRLS_RESOURCES=\".\"" }},
        }))
    end)
