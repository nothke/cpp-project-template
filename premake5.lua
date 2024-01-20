NAME = (io.popen"cd":read'*l'):match("[^/\\]*$") -- current folder name

workspace (NAME)
   configurations { "Debug", "Release" }

project (NAME)
	kind "ConsoleApp"
	language "C++"
	architecture "x64"
	cppdialect "C++latest"
	--toolset "clang"
	targetdir "bin/%{cfg.buildcfg}"
	defines{"WIN32", "_CONSOLE"}

	-- if using modules:
	buildstlmodules "On"

	files { 
		"src/**.h", "src/**.hpp",
		"src/**.c", "src/**.cpp"
	}

	buildoptions{
		--"-openmp",
		--"-verbose"
	}

	-- DEPENDENCIES

	includedirs { "deps/include" }

	libdirs{}

	links{}

	-- add your dlls here to be copied to build folder:
	--postbuildcommands {
	--	"{COPY} pathtodll/file.dll %{cfg.targetdir}"
	--}

	filter "configurations:Debug"
		defines{"_DEBUG"}
		symbols "On"

	filter "configurations:Release"
		defines {"NDEBUG"}
		optimize "On"