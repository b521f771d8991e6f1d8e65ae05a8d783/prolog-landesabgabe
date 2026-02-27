cmake_minimum_required(VERSION 3.28)
project(prolog-landesabgabe)

# Packaging

# add you binaries here
install(FILES "target/$ENV{TARGET}/$ENV{VARIANT}/backend" DESTINATION bin RENAME backend)
install(FILES ".cmake/Sources/MacUI/MacUI" DESTINATION bin RENAME test-app)

get_filename_component(CPACK_PACKAGE_NAME ${CMAKE_CURRENT_SOURCE_DIR} NAME)
set(CPACK_PACKAGE_VERSION "0.0.1")
set(CPACK_PACKAGE_DESCRIPTION "bla")
set(CPACK_PACKAGE_VENDOR "bla")
set(CPACK_PACKAGE_CONTACT "bla")
set(CPACK_PACKAGE_LICENSE "bla")
set(CPACK_PACKAGE_EXECUTABLES "backend")

if(UNIX AND APPLE)
    set(CPACK_GENERATOR "TGZ;STGZ")
elseif(LINUX)
    set(CPACK_GENERATOR "DEB;RPM;TGZ;STGZ")
else()
    set(CPACK_GENERATOR "TGZ;STGZ")
endif()

include(CPack)