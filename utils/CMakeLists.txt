    project (Utils C)

#----------------------- minimum version of cmake to use ------------

# if you want to switch to 2.6 min, please look at the escaped definitions
# later in this file (the add_definitions in 2.6 don't need to be escaped),
# and remove the CMP0005 policy.
# the CMP0003 could also be removed for cmake 2.6
cmake_minimum_required (VERSION 2.4)
if(COMMAND cmake_policy)
    cmake_policy(SET CMP0005 OLD)
    cmake_policy(SET CMP0003 NEW)
endif(COMMAND cmake_policy)

#----------------------- detect system ------------------------------

if (CMAKE_CROSSCOMPILING)
    if (OSCAM_SYSTEM_NAME MATCHES "Tuxbox")
        set (OSCamOperatingSystem "Tuxbox")
    elseif (OSCAM_SYSTEM_NAME MATCHES "TripleDragon")
        set (OSCamOperatingSystem "TripleDragon")
    elseif (OSCAM_SYSTEM_NAME MATCHES "Coolstream")
        set (OSCamOperatingSystem "NeutrinoHD")
    elseif (OSCAM_SYSTEM_NAME MATCHES "NSLU2")
        set (OSCamOperatingSystem "SlugOS")
    elseif (OSCAM_SYSTEM_NAME MATCHES "WRT350NV2")
        set (OSCamOperatingSystem "OpenWRT")
        set (CS_OS_HW "wrt350nv2")
    elseif (OSCAM_SYSTEM_NAME MATCHES "Dockstar")
        set (OSCamOperatingSystem "OpenWRT")
        set (CS_OS_HW "dockstar")
    elseif (OSCAM_SYSTEM_NAME MATCHES "Fonera2")
        set (OSCamOperatingSystem "Fonera2")
    elseif (OSCAM_SYSTEM_NAME MATCHES "agv2+w")
        set (OSCamOperatingSystem "agv2+w")
    elseif (OSCAM_SYSTEM_NAME MATCHES "WRT54G")
        set (OSCamOperatingSystem "WRT54G")
    elseif (OSCAM_SYSTEM_NAME MATCHES "Amino")
        set (OSCamOperatingSystem "Amino")
    elseif (OSCAM_SYSTEM_NAME MATCHES "Padre")
        set (OSCamOperatingSystem "Padre")
    else (OSCAM_SYSTEM_NAME MATCHES "Tuxbox")
        message (STATUS "Unknown cross system name: <${CMAKE_SYSTEM_NAME}>")
        set (OSCamOperatingSystem "Unknown")
    endif (OSCAM_SYSTEM_NAME MATCHES "Tuxbox")
else (CMAKE_CROSSCOMPILING)
    if (${CMAKE_SYSTEM_NAME} MATCHES "Linux")
        set (OSCamOperatingSystem "Linux")
    elseif (${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
        set (OSCamOperatingSystem "Mac OS X")
        SET( CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS} -g" )
        SET( CMAKE_C_FLAGS_DEBUG "${CMAKE_CFLAGS} -g" )
    elseif (${CYGWIN})
        set (OSCamOperatingSystem "Windows/Cygwin")
        set (CMAKE_SYSTEM_PROCESSOR "i386")
    elseif (OSCamOperatingSystem MATCHES "Padre")
        add_definitions ("-DPADRE -DSPARC")
        set (DEFAULT_CS_CONFDIR "/etc/oscam")
    else (${CMAKE_SYSTEM_NAME} MATCHES "Linux")
        message (STATUS "Unknown system name: <${CMAKE_SYSTEM_NAME}>")
        set (OSCamOperatingSystem "Unknown")
    endif (${CMAKE_SYSTEM_NAME} MATCHES "Linux")
endif (CMAKE_CROSSCOMPILING)

#----------------------- some paths ------------------------------

set (OPTIONAL_LINK_DIR "" CACHE STRING "Some optional link directories")
set (OPTIONAL_INCLUDE_DIR "" CACHE STRING "Some optional include directories")

include_directories (
    ${OPTIONAL_INCLUDE_DIR}
    )

link_directories (${OPTIONAL_LINK_DIR})

#----------------------- global options ------------------------------

if (OSCamOperatingSystem MATCHES "Linux")
    set (DEFAULT_CS_CONFDIR "/usr/local/etc")
elseif (OSCamOperatingSystem MATCHES "Mac OS X")
    add_definitions ("-DWITH_PCSC -DCS_NOSHM")
    set (DEFAULT_CS_CONFDIR "/usr/local/etc")
elseif (OSCamOperatingSystem MATCHES "Tuxbox")
    set (DEFAULT_CS_CONFDIR "/var/tuxbox/config")
elseif (OSCamOperatingSystem MATCHES "TripleDragon")
    add_definitions ("-DSTB04SCI")
    set (DEFAULT_CS_CONFDIR "/var/tuxbox/config")
elseif (OSCamOperatingSystem MATCHES "NeutrinoHD")
    add_definitions ("-DWITH_COOLAPI=1")
    set (DEFAULT_CS_CONFDIR "/var/tuxbox/config")
elseif (OSCamOperatingSystem MATCHES "SlugOS")
    set (DEFAULT_CS_CONFDIR "/var/etc")
elseif (OSCamOperatingSystem MATCHES "OpenWRT")
    if (CS_OS_HW MATCHES "wrt350nv2")
        add_definitions ("-DWRT350NV2")
        set (DEFAULT_CS_CONFDIR "/etc/oscam")
    elseif (CS_OS_HW MATCHES "dockstar")
        add_definitions ("-DDOCKSTAR")
        set (DEFAULT_CS_CONFDIR "/usr/oscam")
    endif (CS_OS_HW MATCHES "wrt350nv2")
elseif (OSCamOperatingSystem MATCHES "Fonera2")
    set (DEFAULT_CS_CONFDIR "/var/etc")
elseif (OSCamOperatingSystem MATCHES "agv2+w")
    set (DEFAULT_CS_CONFDIR "/etc")
elseif (OSCamOperatingSystem MATCHES "WRT54G")
    set (DEFAULT_CS_CONFDIR "/jffs/etc/config/oscam")
elseif (OSCamOperatingSystem MATCHES "Amino")
    set (DEFAULT_CS_CONFDIR "/usr/local/etc")
elseif (OSCamOperatingSystem MATCHES "Windows/Cygwin")
    add_definitions ("-static")
    set (DEFAULT_CS_CONFDIR ".")
endif (OSCamOperatingSystem MATCHES "Linux")

execute_process(COMMAND ${CMAKE_C_COMPILER} -dumpmachine OUTPUT_VARIABLE CS_TARGET)
add_definitions ("-D'CS_TARGET=\"${CS_TARGET}\"'")

#----------------------- subdirectories ------------------------------

include (CheckIncludeFile)

if (NOT OSCamOperatingSystem MATCHES "Mac OS X")
   if (LIBRTDIR)
        check_include_file ("${LIBRTDIR}/include/time.h" HAVE_LIBRT_STATIC)
        if (HAVE_LIBRT_STATIC)
            if (EXISTS ${LIBRTDIR}/lib/librt.a)
                message(STATUS "  static librt found : ${LIBRTDIR}/lib/librt.a (needed by libusb).")
                add_definitions ("-I${LIBRTDIR}/include/")
                add_library(utils_imp_librt STATIC IMPORTED)
                set_property(TARGET utils_imp_librt PROPERTY IMPORTED_LOCATION ${LIBRTDIR}/lib/librt.a)
            else (EXISTS ${LIBRTDIR}/lib/librt.a)
                message(STATUS " ${LIBRTDIR}/lib/librt.a not found (needed by libusb). No smartreader support)")
                set (HAVE_LIBRT_STATIC False)
            endif (EXISTS ${LIBRTDIR}/lib/librt.a)
        else (HAVE_LIBRT_STATIC)
            message(STATUS "  no librt found (needed by libusb). No smartreader support")
        endif (HAVE_LIBRT_STATIC)
    else (LIBRTDIR)
        check_include_file ("time.h" HAVE_LIBRT)
        if (HAVE_LIBRT)
            message(STATUS "  librt found (needed by libusb).")
        else (HAVE_LIBRT)
            message(STATUS "  no librt found (needed by libusb. No smartreader support")
        endif (HAVE_LIBRT)
    endif (LIBRTDIR)
else (NOT OSCamOperatingSystem MATCHES "Mac OS X")
    set (HAVE_LIBRT True)
endif (NOT OSCamOperatingSystem MATCHES "Mac OS X")

check_include_file ("pthread.h" HAVE_PTHREAD)
if (HAVE_PTHREAD)
    message(STATUS "Utils: pthread found. Adding pthread support ")
    add_definitions ("-DHAVE_PTHREAD_H")
elseif (HAVE_PTHREAD)
    message(STATUS "Utils: no pthread found. No smartreader ")
    set (HAVE_LIBRT False)
    set (HAVE_LIBRT_STATIC False)
endif (HAVE_PTHREAD)


if( HAVE_LIBRT OR HAVE_LIBRT_STATIC)
    if (LIBUSBDIR)
        check_include_file ("${LIBUSBDIR}/include/libusb-1.0/libusb.h" HAVE_LIBUSB)
        if (HAVE_LIBUSB AND HAVE_PTHREAD)
            if (EXISTS ${LIBUSBDIR}/lib/libusb-1.0.a)
                message(STATUS "Utils: static libusb 1.0 found (${LIBUSBDIR}/lib/libusb-1.0.a). Adding smartreader support ")
                add_definitions ("-DWITH_LIBUSB")
                add_definitions ("-I${LIBUSBDIR}/include/")
                add_library(utils_imp_libusb STATIC IMPORTED)
                set_property(TARGET utils_imp_libusb PROPERTY IMPORTED_LOCATION ${LIBUSBDIR}/lib/libusb-1.0.a)
            else (EXISTS ${LIBUSBDIR}/lib/libusb-1.0.a)
                message(STATUS "Utils:  static libusb 1.0 not found (${LIBUSBDIR}/lib/libusb-1.0.a). No smartreader support ")
                set (HAVE_LIBUSB False)
                set (HAVE_LIBRT False)
                set (HAVE_LIBRT_STATIC False)
            endif (EXISTS ${LIBUSBDIR}/lib/libusb-1.0.a)
        else (HAVE_LIBUSB AND HAVE_PTHREAD)
            message(STATUS "Utils: no libusb 1.0 found. No smartreader support")
        endif (HAVE_LIBUSB AND HAVE_PTHREAD)
    else (LIBUSBDIR)
        check_include_file ("libusb-1.0/libusb.h" HAVE_LIBUSB)
        if (HAVE_LIBUSB AND HAVE_PTHREAD)
            if (EXISTS /usr/local/lib/libusb-1.0.a)
                message(STATUS "Utils: static libusb 1.0 found : /usr/local/lib/libusb-1.0.a . Adding smartreader support ")
                add_definitions ("-DWITH_LIBUSB")
                add_definitions ("-I/usr/local/include")
                add_library(utils_imp_libusb STATIC IMPORTED)
                set_property(TARGET utils_imp_libusb PROPERTY IMPORTED_LOCATION /usr/local/lib/libusb-1.0.a)
            elseif (EXISTS /usr/lib/libusb-1.0.a)
                message(STATUS "Utils: static libusb 1.0 found : /usr/lib/libusb-1.0.a . Adding smartreader support ")
                add_definitions ("-DWITH_LIBUSB")
                add_library(utils_imp_libusb STATIC IMPORTED)
                set_property(TARGET utils_imp_libusb PROPERTY IMPORTED_LOCATION /usr/lib/libusb-1.0.a)
            else (EXISTS /usr/local/lib/libusb-1.0.a)
                message(STATUS "Utils: static libusb 1.0 not found (not in /usr/local/lib/ or /usr/lib/) . No smartreader support ")
                set (HAVE_LIBUSB False)
                set (HAVE_LIBRT False)
                set (HAVE_LIBRT_STATIC False)
            endif (EXISTS /usr/local/lib/libusb-1.0.a)
        else (HAVE_LIBUSB AND HAVE_PTHREAD)
            message(STATUS "  no libusb 1.0 found. No smartreader support")
        endif (HAVE_LIBUSB AND HAVE_PTHREAD)
    endif (LIBUSBDIR)
endif( HAVE_LIBRT OR HAVE_LIBRT_STATIC)


if( HAVE_LIBRT OR HAVE_LIBRT_STATIC)
#---- are we building ?
if (HAVE_LIBUSB)

#----------------------- file groups ------------------------------

file (GLOB exe_srcs "list_smargo.c")
file (GLOB exe_hdrs "*.h")
file (GLOB all_srcs ${exe_srcs})

#----------------------- the executable ------------------------------

set (util_name "list_smargo")
add_executable (${util_name} ${exe_srcs} ${exe_hdrs})

if(HAVE_LIBRT AND HAVE_LIBUSB)
    target_link_libraries (${util_name} imp_libusb)
    if (NOT OSCamOperatingSystem MATCHES "Mac OS X")
        target_link_libraries (${util_name} rt)
    endif (NOT OSCamOperatingSystem MATCHES "Mac OS X")
    if (OSCamOperatingSystem MATCHES "Windows/Cygwin")
	target_link_libraries (${util_name} SetupAPI)
	target_link_libraries (${util_name} Ole32)
	target_link_libraries (${util_name} shell32)
    endif (OSCamOperatingSystem MATCHES "Windows/Cygwin")
endif(HAVE_LIBRT AND HAVE_LIBUSB)

if (HAVE_LIBRT_STATIC AND HAVE_LIBUSB)
    target_link_libraries (${util_name} imp_libusb)
    if (NOT OSCamOperatingSystem MATCHES "Mac OS X")
    target_link_libraries (${util_name} imp_librt)
    endif (NOT OSCamOperatingSystem MATCHES "Mac OS X")
    if (OSCamOperatingSystem MATCHES "Windows/Cygwin")
	target_link_libraries (${util_name} SetupAPI)
	target_link_libraries (${util_name} Ole32)
	target_link_libraries (${util_name} shell32)
    endif (OSCamOperatingSystem MATCHES "Windows/Cygwin")
endif (HAVE_LIBRT_STATIC AND HAVE_LIBUSB)

if (HAVE_PTHREAD)
    target_link_libraries (${util_name} pthread)
endif (HAVE_PTHREAD)

#----------------------- specific options ------------------------------

if (OSCamOperatingSystem MATCHES "Linux")
elseif (OSCamOperatingSystem MATCHES "Mac OS X")
        FIND_LIBRARY (IOKit_LIBRARY IOKit)
   	    target_link_libraries ( ${util_name} ${IOKit_LIBRARY})
        FIND_LIBRARY (CoreFoundation_LIBRARY CoreFoundation)
   	    target_link_libraries ( ${util_name} ${CoreFoundation_LIBRARY})
elseif (OSCamOperatingSystem MATCHES "Tuxbox")
    target_link_libraries ( ${util_name} dl)
elseif (OSCamOperatingSystem MATCHES "TripleDragon")
    target_link_libraries ( ${util_name} dl)
elseif (OSCamOperatingSystem MATCHES "SlugOS")
elseif (OSCamOperatingSystem MATCHES "OpenWRT")
elseif (OSCamOperatingSystem MATCHES "Fonera2")
elseif (OSCamOperatingSystem MATCHES "agv2+w")
elseif (OSCamOperatingSystem MATCHES "WRT54G")
elseif (OSCamOperatingSystem MATCHES "Amino")
elseif (OSCamOperatingSystem MATCHES "Windows/cygwin")
elseif (OSCamOperatingSystem MATCHES "NeutrinoHD")
    target_link_libraries ( ${util_name} rt nxp )
endif (OSCamOperatingSystem MATCHES "Linux")

#----------------------- global compile and link options ------------------------------

# some optimisations
if (OSCamOperatingSystem MATCHES "Mac OS X")
add_definitions ("-Wall -Wextra")
endif (OSCamOperatingSystem MATCHES "Mac OS X")

# we don't want the '-rdynamic' in the link command
set (CMAKE_SHARED_LIBRARY_LINK_C_FLAGS "")

# we want to strip
if (OSCamOperatingSystem MATCHES "Mac OS X")
  if (NOT CMAKE_BUILD_TYPE STREQUAL Debug)
    set (CMAKE_EXE_LINKER_FLAGS "-s -isysroot /Developer/SDKs/MacOSX10.6.sdk")
  else (NOT CMAKE_BUILD_TYPE STREQUAL Debug)
    message (STATUS "  building with debug")
    set (CMAKE_EXE_LINKER_FLAGS "-ggdb -isysroot /Developer/SDKs/MacOSX10.6.sdk")
  endif (NOT CMAKE_BUILD_TYPE STREQUAL Debug)
else (OSCamOperatingSystem MATCHES "Mac OS X")
set (CMAKE_EXE_LINKER_FLAGS "-s")
endif (OSCamOperatingSystem MATCHES "Mac OS X")

#----------------------- we can use CPack to build pacakges --------------------------

# compute my filename
set (CPACK_PACKAGE_FILE_NAME  "${PROJECT_NAME}-${CS_TARGET}")


# wich archive we want to generate
set (CPACK_GENERATOR "TGZ")

# what to put in the archive
set (CPACK_STRIP_FILES TRUE)
set (CPACK_COMPONENTS_ALL bin)# config doc)

# ok, we can now use CPack
include (CPack)

#----------------------- printout resume -----------------------------

message (STATUS "Utils: operating system: ${OSCamOperatingSystem}")
message (STATUS "Utils: target system: ${CS_TARGET}")
message (STATUS "Utils: use system static libusb")
message (STATUS "")
endif (HAVE_LIBUSB)
endif( HAVE_LIBRT OR HAVE_LIBRT_STATIC)
