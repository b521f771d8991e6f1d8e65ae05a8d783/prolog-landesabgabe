# If the package is widly available in repos, use find_package,
# else or git submodules

# in system repos:
find_package(Boost REQUIRED COMPONENTS numeric_conversion)
find_package(GTest REQUIRED)
find_package(LibArchive REQUIRED)