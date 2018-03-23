include (ExternalProject)

find_package(Threads REQUIRED)

# -----------------------------------------------------------------------------
#  gtest and gmock
# -----------------------------------------------------------------------------

ExternalProject_Add(googletest
  PREFIX googletest
  GIT_REPOSITORY https://github.com/google/googletest.git
  UPDATE_COMMAND ""
  INSTALL_COMMAND ""
  LOG_DOWNLOAD ON
  LOG_CONFIGURE ON
  LOG_BUILD ON
)

ExternalProject_Get_Property(googletest source_dir)
message(${source_dir})
set(GTEST_INCLUDE_DIRS ${source_dir}/googletest/include)
set(GMOCK_INCLUDE_DIRS ${source_dir}/googlemock/include)

# The cloning of the above repo doesn't happen until make, however if the dir doesn't
# exist, INTERFACE_INCLUDE_DIRECTORIES will throw an error.
# To make it work, we just create the directory now during config.
file(MAKE_DIRECTORY ${GTEST_INCLUDE_DIRS})
file(MAKE_DIRECTORY ${GMOCK_INCLUDE_DIRS})

ExternalProject_Get_Property(googletest binary_dir)

# TARGET: gtest
# unix only
set(GTEST_STATIC_LIBRARIES ${binary_dir}/googlemock/gtest/${CMAKE_FIND_LIBRARY_PREFIXES}gtest.a)

add_library(gtest UNKNOWN IMPORTED)
set_target_properties(gtest PROPERTIES INTERFACE_INCLUDE_DIRECTORIES "${GTEST_INCLUDE_DIRS}")
set_target_properties(gtest PROPERTIES IMPORTED_LOCATION "${GTEST_STATIC_LIBRARIES}")
add_dependencies(gtest googletest)

# TARGET: gtest_main
# unix only
set(GTEST_MAIN_STATIC_LIBRARIES ${binary_dir}/googlemock/gtest/${CMAKE_FIND_LIBRARY_PREFIXES}gtest_main.a)

add_library(gtest_main UNKNOWN IMPORTED)
set_target_properties(gtest_main PROPERTIES INTERFACE_INCLUDE_DIRECTORIES "${GTEST_INCLUDE_DIRS}")
set_target_properties(gtest_main PROPERTIES IMPORTED_LOCATION "${GTEST_MAIN_STATIC_LIBRARIES}")
add_dependencies(gtest_main googletest)

# TARGET: gmock
# unix only
set(GMOCK_STATIC_LIBRARIES ${binary_dir}/googlemock/${CMAKE_FIND_LIBRARY_PREFIXES}gmock.a)

add_library(gmock UNKNOWN IMPORTED)
set_target_properties(gmock PROPERTIES INTERFACE_INCLUDE_DIRECTORIES "${GMOCK_INCLUDE_DIRS}")
set_target_properties(gmock PROPERTIES IMPORTED_LOCATION "${GMOCK_STATIC_LIBRARIES}")
add_dependencies(gmock googletest)

# TARGET: gmock_main
# unix only
set(GMOCK_MAIN_STATIC_LIBRARIES ${binary_dir}/googlemock/${CMAKE_FIND_LIBRARY_PREFIXES}gmock_main.a)

add_library(gmock_main UNKNOWN IMPORTED)
set_target_properties(gmock_main PROPERTIES INTERFACE_INCLUDE_DIRECTORIES "${GMOCK_INCLUDE_DIRS}")
set_target_properties(gmock_main PROPERTIES IMPORTED_LOCATION "${GMOCK_MAIN_STATIC_LIBRARIES}")
add_dependencies(gmock_main googletest)
