include (ExternalProject)

if(NOT TARGET glog)

  message("creating target glog")

  set(GLOG_INCLUDE_DIRS ${CMAKE_CURRENT_BINARY_DIR}/googlelog/src/googlelog ${CMAKE_CURRENT_BINARY_DIR}/googlelog/src/googlelog/src)
  set(GLOG_URL "https://github.com/google/glog")
  set(GLOG_TAG "v0.3.5")

  file(MAKE_DIRECTORY ${GLOG_INCLUDE_DIRS})

  if(WIN32)
    if(${CMAKE_GENERATOR} MATCHES "Visual Studio.*")
      set(GLOG_STATIC_LIBRARIES
        ${CMAKE_CURRENT_BINARY_DIR}/googlelog/src/googlelog/Release/glog.lib)
    else()
      set(GLOG_STATIC_LIBRARIES
        ${CMAKE_CURRENT_BINARY_DIR}/googlelog/src/googlelog/glog.lib)
    endif()
  else()
    set(GLOG_STATIC_LIBRARIES
      ${CMAKE_CURRENT_BINARY_DIR}/googlelog/src/googlelog/libglog.a)
  endif()

  ExternalProject_Add(googlelog
    PREFIX googlelog
    # DEPENDS gflags
    GIT_REPOSITORY ${GLOG_URL}
    GIT_TAG ${GLOG_TAG}
    INSTALL_COMMAND ""
    BUILD_IN_SOURCE 1
    CMAKE_ARGS -DBUILD_SHARED_LIBS=OFF
               -DBUILD_TESTING=OFF
  )

  message(${GLOG_STATIC_LIBRARIES})

  # create the glog target
  add_library(glog UNKNOWN IMPORTED)
  set_target_properties(glog PROPERTIES INTERFACE_INCLUDE_DIRECTORIES "${GLOG_INCLUDE_DIRS}")
  set_target_properties(glog PROPERTIES IMPORTED_LOCATION "${GLOG_STATIC_LIBRARIES}")

  add_dependencies(glog googlelog)

endif()
