include (ExternalProject)

if(NOT TARGET gflags)

  find_package(Threads)

  set(GFLAGS_INCLUDE_DIRS ${CMAKE_CURRENT_BINARY_DIR}/gflags/src/gflags/include)
  set(GFLAGS_URL https://github.com/gflags/gflags.git)
  set(GFLAGS_TAG v2.1.2)

  if(WIN32)
    if(${CMAKE_GENERATOR} MATCHES "Visual Studio.*")
      set(GFLAGS_STATIC_LIBRARIES
        ${CMAKE_CURRENT_BINARY_DIR}/gflags/src/gflags/Release/gflags.lib
    else()
      set(GFLAGS_STATIC_LIBRARIES
        ${CMAKE_CURRENT_BINARY_DIR}/gflags/src/gflags/gflags.lib
    endif()
  else()
    set(GFLAGS_STATIC_LIBRARIES
      ${CMAKE_CURRENT_BINARY_DIR}/gflags/src/gflags/libgflags.a
  endif()

  ExternalProject_Add(gflags
    PREFIX gflags
    GIT_REPOSITORY ${GFLAGS_URL}
    GIT_TAG ${GFLAGS_TAG}
    INSTALL_COMMAND ""
    CMAKE_ARGS -DBUILD_SHARED_LIBS=OFF
               -DBUILD_STATIC_LIBS=ON
               -DBUILD_TESTING=OFF
               -DBUILD_NC_TESTS=OFF
               -BUILD_CONFIG_TESTS=OFF
  )

  # create the gflags target
  add_library(gflags UNKNOWN IMPORTED)
  set_target_properties(gflags PROPERTIES INTERFACE_INCLUDE_DIRECTORIES "${GFLAGS_INCLUDE_DIRS}")
  set_target_properties(gflags PROPERTIES IMPORTED_LOCATION "${GFLAGS_STATIC_LIBRARIES} ${CMAKE_THREAD_LIBS_INIT}")  

endif()
