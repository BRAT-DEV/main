#
# try to find GTK (and glib) and GTKGLArea
#
# GTK_LIBRARIES     - Files to link against to use GTK
# GTK_VERSION_2     - Use this Version
# GTK_VERSION_1     - Use this Version
# GTK_FOUND         - If false, don't try to use GTK
MACRO(DBG_MSG _MSG)
#  MESSAGE(STATUS
#    "${CMAKE_CURRENT_LIST_FILE}(${CMAKE_CURRENT_LIST_LINE}): ${_MSG}")
ENDMACRO(DBG_MSG)

OPTION(GTK_VERSION_1    "Use GTK version 1.x"   OFF)
OPTION(GTK_VERSION_2    "Use GTK version 2.x"   ON)

# Exclusion between the two version

IF(GTK_VERSION_2)
  SET(GTK_VERSION_1 OFF)
ENDIF(GTK_VERSION_2)

IF(NOT WIN32)

  #Find new pkg-config
  FIND_PACKAGE(PkgConfig)
  SET(CMAKE_PKG_CONFIG ${PKG_CONFIG_EXECUTABLE})
  
  #FIND_PROGRAM(CMAKE_PKG_CONFIG pkg-config ../gtk2/bin ../../gtk2/bin)
  

  #if PKG is found
  IF(CMAKE_PKG_CONFIG)
    PKG_CHECK_MODULES(GTK gtk)
    
    #SET(CMAKE_GTK1_CXX_FLAGS "`${CMAKE_PKG_CONFIG} --cflags gtk`")
    #SET(GTK1_LIBRARIES "`${CMAKE_PKG_CONFIG} --libs gtk`")
    
    SET(CMAKE_GTK1_CXX_FLAGS "${GTK_CFLAGS}")
    SET(GTK1_LIBRARIES "${GTK_LDFLAGS}")

    PKG_CHECK_MODULES(GTK2 gtk+-2.0)

    #SET(CMAKE_GTK2_CXX_FLAGS "`${CMAKE_PKG_CONFIG} --cflags gtk+-2.0`")
    #SET(GTK2_LIBRARIES "`${CMAKE_PKG_CONFIG} --libs gtk+-2.0`")

    DBG_MSG("GTK2_CFLAGS=${GTK2_CFLAGS}")
    SET(CMAKE_GTK2_CXX_FLAGS "${GTK2_CFLAGS}")
    SET(GTK2_LIBRARIES "${GTK2_LDFLAGS}")
    
  ELSE(CMAKE_PKG_CONFIG)
    #we were not able to find to, lets try with:
    #old gtk-config
    FIND_PROGRAM(CMAKE_GTK_CONFIG gtk-config ../gtk/bin ../../gtk/bin)

    SET(CMAKE_GTK1_CXX_FLAGS "`${CMAKE_GTK_CONFIG} --cflags`")
    SET(GTK1_LIBRARIES "`${CMAKE_GTK_CONFIG} --libs`")

    MESSAGE(FATAL_ERROR "GTK2.x was not found but GTK1.x was, please set GTK_VERSION_1
    to ON")
  ENDIF(CMAKE_PKG_CONFIG)
  
ENDIF(NOT WIN32)  

MARK_AS_ADVANCED(
  CMAKE_GTK_CXX_FLAGS
  CMAKE_GTK2_CXX_FLAGS
)


IF(GTK1_LIBRARIES OR GTK2_LIBRARIES)

  IF(GTK_VERSION_2)
    #looking for GTK2.x
    IF(CMAKE_GTK2_CXX_FLAGS)
      SET(GTK_FOUND 1)
      SET (GTK_LIBRARIES "${GTK2_LIBRARIES}")
      SET(CMAKE_GTK_CXX_FLAGS "${CMAKE_GTK2_CXX_FLAGS}")
    ENDIF(CMAKE_GTK2_CXX_FLAGS)
  ELSE(GTK_VERSION_2)
    #looking for GTK1.x
    IF(CMAKE_GTK1_CXX_FLAGS)
      SET(GTK_FOUND 1)
      SET (GTK_LIBRARIES "${GTK1_LIBRARIES}")
      SET(CMAKE_GTK_CXX_FLAGS "${CMAKE_GTK1_CXX_FLAGS}")
    ENDIF(CMAKE_GTK1_CXX_FLAGS)
  ENDIF(GTK_VERSION_2)
ENDIF(GTK1_LIBRARIES OR GTK2_LIBRARIES)

STRING(REGEX REPLACE ";" " " CMAKE_GTK_CXX_FLAGS "${CMAKE_GTK_CXX_FLAGS}")
STRING(REGEX REPLACE ";" " " GTK_LIBRARIES "${GTK_LIBRARIES}")

DBG_MSG("CMAKE_GTK_CXX_FLAGS=${CMAKE_GTK_CXX_FLAGS}")
DBG_MSG("GTK_LIBRARIES=${GTK_LIBRARIES}")
