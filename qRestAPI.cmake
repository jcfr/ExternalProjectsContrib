#
# qRestAPI
#

set(proj qRestAPI)

set(${proj}_enabling_variable qRestAPI_LIBRARIES)
set(${${proj}_enabling_variable}_LIBRARY_DIRS qRestAPI_LIBRARY_DIRS)
set(${${proj}_enabling_variable}_INCLUDE_DIRS qRestAPI_INCLUDE_DIRS)
set(${${proj}_enabling_variable}_FIND_PACKAGE_CMD qRestAPI)

set(${proj}_DEPENDENCIES "")

ExternalProject_Include_Dependencies(${proj}
  PROJECT_VAR proj
  DEPENDS_VAR ${proj}_DEPENDENCIES
  EP_ARGS_VAR ${proj}_EXTERNAL_PROJECT_ARGS
  USE_SYSTEM_VAR ${CMAKE_PROJECT_NAME}_USE_SYSTEM_${proj}
  )

if(${CMAKE_PROJECT_NAME}_USE_SYSTEM_${proj})
  message(FATAL_ERROR "Enabling ${CMAKE_PROJECT_NAME}_USE_SYSTEM_${proj} is not supported !")
endif()

# Sanity checks
if(DEFINED qRestAPI_DIR AND NOT EXISTS ${qRestAPI_DIR})
  message(FATAL_ERROR "qRestAPI_DIR variable is defined but corresponds to non-existing directory")
endif()

if(NOT DEFINED qRestAPI_DIR)

  set(revision_tag "5a81c92f91c3")
  if(${proj}_REVISION_TAG)
    set(revision_tag ${${proj}_REVISION_TAG})
  endif()

  set(location_args )
  if(${proj}_URL)
    set(location_args URL ${${proj}_URL})
  elseif(${proj}_GIT_REPOSITORY)
    set(location_args GIT_REPOSITORY ${${proj}_GIT_REPOSITORY}
                      GIT_TAG ${revision_tag})
  else()
    set(location_args GIT_REPOSITORY "${git_protocol}://github.com/commontk/qRestAPI.git"
                      GIT_TAG ${revision_tag})
    #set(location_args URL ....tar.gz)
  endif()

  set(ep_project_include_arg)
  #if(CTEST_USE_LAUNCHERS)
  #  set(ep_project_include_arg
  #    "-DCMAKE_PROJECT_qRestAPI_INCLUDE:FILEPATH=${CMAKE_ROOT}/Modules/CTestUseLaunchers.cmake")
  #endif()

  ExternalProject_Add(${proj}
    ${${proj}_EXTERNAL_PROJECT_ARGS}
    SOURCE_DIR ${CMAKE_BINARY_DIR}/${proj}
    BINARY_DIR ${proj}-build
    PREFIX ${proj}${ep_suffix}
    ${location_args}
    UPDATE_COMMAND ""
    INSTALL_COMMAND ""
    CMAKE_GENERATOR ${gen}
    CMAKE_CACHE_ARGS
      ${ep_common_cache_args}
      ${ep_project_include_arg}
      -DQT_QMAKE_EXECUTABLE:FILEPATH=${QT_QMAKE_EXECUTABLE}
    DEPENDS
      ${${proj}_DEPENDENCIES}
    )
  set(qRestAPI_DIR ${CMAKE_CURRENT_BINARY_DIR}/${proj}-build)

else()
  ExternalProject_Add_Empty(${proj} DEPENDS ${${proj}_DEPENDENCIES})
endif()

mark_as_superbuild(
  VARS qRestAPI_DIR:PATH
  LABELS "FIND_PACKAGE"
  )

