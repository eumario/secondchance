### CMakeLists automatically created with AutoVala
### Do not edit

set (DATADIR "${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_DATAROOTDIR}")
set (PKGDATADIR "${DATADIR}/SecondChance")
set (GETTEXT_PACKAGE "SecondChance")
set (RELEASE_NAME "SecondChance")
set (CMAKE_C_FLAGS "")
set (PREFIX ${CMAKE_INSTALL_PREFIX})
set (VERSION "0.0.1")
set (TESTSRCDIR "${CMAKE_SOURCE_DIR}")
set (DOLLAR "$")

configure_file (${CMAKE_SOURCE_DIR}/src/Config.vala.cmake ${CMAKE_BINARY_DIR}/src/Config.vala)
add_definitions(-DGETTEXT_PACKAGE=\"${GETTEXT_PACKAGE}\")
set (VERSION "0.0.1")
add_definitions (${DEPS_CFLAGS})
link_libraries ( ${DEPS_LIBRARIES} )
link_directories ( ${DEPS_LIBRARY_DIRS} )
find_package (Vala REQUIRED)
include (ValaVersion)
ensure_vala_version ("0.28" MINIMUM)
include (ValaPrecompile)

set (VALA_PACKAGES ${VALA_PACKAGES} posix)
set (VALA_PACKAGES ${VALA_PACKAGES} libarchive)
set (VALA_PACKAGES ${VALA_PACKAGES} atk)
set (VALA_PACKAGES ${VALA_PACKAGES} cairo)
set (VALA_PACKAGES ${VALA_PACKAGES} gdk-3.0)
set (VALA_PACKAGES ${VALA_PACKAGES} gdk-pixbuf-2.0)
set (VALA_PACKAGES ${VALA_PACKAGES} gee-0.8)
set (VALA_PACKAGES ${VALA_PACKAGES} gio-2.0)
set (VALA_PACKAGES ${VALA_PACKAGES} gio-unix-2.0)
set (VALA_PACKAGES ${VALA_PACKAGES} glib-2.0)
set (VALA_PACKAGES ${VALA_PACKAGES} gobject-2.0)
set (VALA_PACKAGES ${VALA_PACKAGES} granite)
set (VALA_PACKAGES ${VALA_PACKAGES} gtk+-3.0)
set (VALA_PACKAGES ${VALA_PACKAGES} pango)
set (VALA_PACKAGES ${VALA_PACKAGES} pangocairo)
set (VALA_PACKAGES ${VALA_PACKAGES} x11)

set (APP_SOURCES ${APP_SOURCES} ${CMAKE_CURRENT_BINARY_DIR}/Config.vala)
set (APP_SOURCES ${APP_SOURCES} components/core/SCAri-Exceptions.vala)
set (APP_SOURCES ${APP_SOURCES} components/core/SCAri.vala)
set (APP_SOURCES ${APP_SOURCES} components/gui/MainWindow.vala)
set (APP_SOURCES ${APP_SOURCES} components/gui/NewTaskPanel.vala)
set (APP_SOURCES ${APP_SOURCES} components/gui/NoTask.vala)
set (APP_SOURCES ${APP_SOURCES} components/gui/widgets/OptionButton.vala)
set (APP_SOURCES ${APP_SOURCES} components/gui/widgets/StylizedList.vala)
set (APP_SOURCES ${APP_SOURCES} components/gui/widgets/StylizedRow.vala)
set (APP_SOURCES ${APP_SOURCES} components/gui/widgets/WizardPanel.vala)
set (APP_SOURCES ${APP_SOURCES} secondchance.vala)

vala_precompile(VALA_C secondchance
	${APP_SOURCES}
PACKAGES
	${VALA_PACKAGES}
)

add_executable(secondchance ${VALA_C})


install(TARGETS
	secondchance
RUNTIME DESTINATION
	${CMAKE_INSTALL_BINDIR}
)
if(HAVE_VALADOC)
	valadoc(secondchance
		${CMAKE_BINARY_DIR}/valadoc/secondchance
		${APP_SOURCES}
	PACKAGES
		${VALA_PACKAGES}
	CUSTOM_VAPIS
		${CUSTOM_VAPIS_LIST}
	)
	install(DIRECTORY
		${CMAKE_BINARY_DIR}/valadoc
	DESTINATION
		${CMAKE_INSTALL_DATAROOTDIR}/doc/SecondChance
	)
endif()
