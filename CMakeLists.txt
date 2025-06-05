cmake_minimum_required(VERSION 3.0)
project(prolog-landesabgabe)

# Packaging

# add you binaries here
set(EXTERNAL_BINARY_PATH "target/$ENV{VARIANT}/backend")
install(FILES ${EXTERNAL_BINARY_PATH} DESTINATION bin)

set(CPACK_PACKAGE_NAME "prolog-landesabgabe")
set(CPACK_PACKAGE_VERSION "0.0.1")
set(CPACK_PACKAGE_DESCRIPTION "bla")
set(CPACK_PACKAGE_VENDOR "bla")
set(CPACK_PACKAGE_CONTACT "bla")
set(CPACK_PACKAGE_LICENSE "bla")
set(CPACK_PACKAGE_EXECUTABLES "backend")
set(CPACK_GENERATOR "DEB;RPM;TGZ;STGZ")

include(CPack)