-- Temporary fix for incorrect link formatting
require("vstudio")
premake.override(premake.vstudio.vc2010, "additionalDependencies", function(oldfn, cfg, explicit)
	if cfg.system ~= premake.WINDOWS then
    	oldfn(cfg, explicit)
	else
		local links
		links = premake.vstudio.getLinks(cfg, explicit)
    	if #links > 0 then
      		links = path.translate(table.concat(links, ";"))
      		premake.vstudio.vc2010.element("AdditionalDependencies", nil, "%s;%%(AdditionalDependencies)", links)
    	end
  	end
end)

workspace "MY_PROJECT_NAME"
   configurations { "Debug", "Release" }

project "MY_PROJECT_NAME"
	kind "ConsoleApp"
	language "C++"
	architecture "x64"
	cppdialect "C++17"
	toolset "clang"
	targetdir "bin/%{cfg.buildcfg}"
	defines{"WIN32", "_CONSOLE"}

	files { 
		"src/**.h", "src/**.hpp",
		"src/**.c", "src/**.cpp"
	}

	-- DEPENDENCIES

	includedirs { "deps/include" }

	libdirs{}

	links{}

	-- add your dlls here to be copied to build folder:
	--postbuildcommands {
	--	"{COPY} pathtodll/file.dll %{cfg.targetdir}"
	--}

	buildoptions{
		"-openmp",
		"-verbose"
	}

	filter "configurations:Debug"
		defines{"_DEBUG"}
		symbols "On"

	filter "configurations:Release"
		defines {"NDEBUG"}
		optimize "On"