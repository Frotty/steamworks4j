solution "steamworks4j-arm64"
	configurations { "release" }

	buildoptions {
		"-std=c++11",
		"-Wall"
	}

	includedirs {
		"../java-wrapper/src/main/native/include/jni",
		"../java-wrapper/src/main/native/include/jni/linux",
		"../sdk/public/steam"
	}

	defines {
		"NDEBUG",
		"LINUX"
	}

	optimize "On"

	architecture ("ARM64")

	project "steamworks4j-arm64"

		kind "SharedLib"
		language "C++"

		files {
			"../java-wrapper/src/main/native/**.cpp"
		}

		includedirs {
			"../java-wrapper/src/main/native",
		}

        libdirs {
            "../sdk/redistributable_bin/linuxarm64"
        }
        links {
            "steam_api"
        }

	project "steamworks4j-server-arm64"

		kind "SharedLib"
		language "C++"

		files {
			"../server/src/main/native/**.cpp"
		}

		excludes {
			"../server/src/main/native/**EncryptedAppTicket*.cpp"
		}

		includedirs {
			"../server/src/main/native",
		}

        libdirs {
            "../sdk/redistributable_bin/linuxarm64"
        }
        links {
            "steam_api"
        }

	project "steamworks4j-encryptedappticket-arm64"

		kind "SharedLib"
		language "C++"

		files {
			"../server/src/main/native/**EncryptedAppTicket*.cpp"
		}

		includedirs {
			"../server/src/main/native",
		}

        libdirs {
            "../sdk/public/steam/lib/linuxarm64"
        }
        links {
            "sdkencryptedappticket"
        }
