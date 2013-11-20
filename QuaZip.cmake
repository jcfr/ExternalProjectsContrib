#
# QuaZip
#

ctk_include_once()

set(QuaZip_enabling_variable QUAZIP_LIBRARIES)

set(proj QuaZip)
set(proj_DEPENDENCIES)

set(${QuaZip_enabling_variable}_LIBRARY_DIRS QUAZIP_LIBRARY_DIRS)
set(${QuaZip_enabling_variable}_INCLUDE_DIRS QUAZIP_INCLUDE_DIRS)
set(${QuaZip_enabling_variable}_FIND_PACKAGE_CMD QuaZip)

set(QuaZip_DEPENDENCIES "")

ctkMacroCheckExternalProjectDependency(QuaZip)
set(proj QuaZip)

if(${CMAKE_PROJECT_NAME}_USE_SYSTEM_${proj})
  message(FATAL_ERROR "Enabling ${CMAKE_PROJECT_NAME}_USE_SYSTEM_${proj} is not supported !")
endif()

# Sanity checks
if(DEFINED QuaZip_DIR AND NOT EXISTS ${QuaZip_DIR})
  message(FATAL_ERROR "QuaZip_DIR variable is defined but corresponds to non-existing directory")
endif()

if(NOT DEFINED QuaZip_DIR)

  set(revision_tag "0.5-patched")
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
    set(location_args GIT_REPOSITORY "${git_protocol}://github.com/saschazelzer/QuaZip.git"
                      GIT_TAG ${revision_tag})
    #set(location_args URL http://heanet.dl.sourceforge.net/project/quazip/quazip/0.5/quazip-0.5.tar.gz)
  endif()

  set(ep_project_include_arg)
  #if(CTEST_USE_LAUNCHERS)
  #  set(ep_project_include_arg
  #    "-DCMAKE_PROJECT_QuaZip_INCLUDE:FILEPATH=${CMAKE_ROOT}/Modules/CTestUseLaunchers.cmake")
  #endif()

  ExternalProject_Add(${proj}
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
      ${proj_DEPENDENCIES}
    )
  set(QuaZip_DIR ${CMAKE_CURRENT_BINARY_DIR}/${proj}-build)

  # Since the link directories associated with QuaZip is used, it makes sense to
  # update CTK_EXTERNAL_LIBRARY_DIRS with its associated library output directory
  list(APPEND CTK_EXTERNAL_LIBRARY_DIRS ${QuaZip_DIR})

else()
  ctkMacroEmptyExternalproject(${proj} "${proj_DEPENDENCIES}")
endif()

list(APPEND CTK_SUPERBUILD_EP_VARS QuaZip_DIR:PATH)

