if(VigraFindBoostIncluded)
    return()
endif()

function(vigra_find_boost)
  # Parse the options.
  set(options REQUIRED)
  set(multiValueArgs COMPONENTS)
  cmake_parse_arguments(VFB "${options}" "" "${multiValueArgs}" ${ARGN})

  # If Python is required among the components, we will look for the Python interpreter
  # and libs first.
  list(FIND VFB_COMPONENTS "python" IDX)
  if(NOT IDX EQUAL -1)
    set(NEED_BOOST_PYTHON TRUE)
  endif()
  if(NEED_BOOST_PYTHON)
    message(STATUS "Boost Python was requested, locating the Python interpreter and libraries.")
    if(VFB_REQUIRED)
      find_package(PythonInterp REQUIRED)
      find_package(PythonLibs REQUIRED)
    else()
      find_package(PythonInterp)
      find_package(PythonLibs)
    endif()
  endif()

  # Main call.
  if(VFB_REQUIRED)
    find_package(Boost REQUIRED COMPONENTS ${VFB_COMPONENTS})
  else()
    find_package(Boost COMPONENTS ${VFB_COMPONENTS})
  endif()

  if(Boost_FOUND)
    message(STATUS "The Boost package was found.")
  endif()

  # If no components are specified, the standard FindBoost module will not provide the interface target referring
  # to the Boost include dirs. I'd consider this a bug, but we can work around it by constructing the target here.
  # If in the future the Boost::boost target will be provided by FindBoost in any case, this code will just not
  # execute.
  if(NOT TARGET Boost::boost AND Boost_FOUND)
    message(STATUS "The Boost::boost target was not provided by the standard FindBoost module, defining it now.")
    add_library(Boost::boost INTERFACE IMPORTED)
    if(Boost_INCLUDE_DIRS)
      set_target_properties(Boost::boost PROPERTIES INTERFACE_INCLUDE_DIRECTORIES "${Boost_INCLUDE_DIRS}")
    endif()
  endif()

  # If we need Boost Python, and the Boost Python library and the Python library were found, we setup
  # the Boost::python target so that anything linking to it includes automatically the Python.h path
  # and links to the Python libs.
  if(NEED_BOOST_PYTHON AND TARGET Boost::python AND PYTHONLIBS_FOUND)
    set_property(TARGET Boost::python APPEND PROPERTY INTERFACE_INCLUDE_DIRECTORIES ${PYTHON_INCLUDE_DIRS})
    set_property(TARGET Boost::python APPEND PROPERTY INTERFACE_LINK_LIBRARIES ${PYTHON_LIBRARIES})
  endif()

endfunction()

# Mark as included.
set(VigraFindBoostIncluded YES)
