add_rules("mode.debug", "mode.release")

if is_plat("windows", "mingw") then
    add_cflags("/TC", {tools = {"clang_cl", "cl"}})
    add_cxxflags("/EHsc", {tools = {"clang_cl", "cl"}})
    add_defines("UNICODE", "_UNICODE")
end

set_encodings("utf-8")
set_languages("c++17")
add_requires("libnx")

target("libnxtc")
    set_kind("$(kind)")
    add_files("source/*.cpp")
    add_includedirs("include")
    add_headerfiles("include/*.h")
    add_packages("libnx")
