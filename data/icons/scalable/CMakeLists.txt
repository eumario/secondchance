### CMakeLists automatically created with AutoVala
### Do not edit

install(FILES ${CMAKE_CURRENT_SOURCE_DIR}/sc_add.svg DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/icons/hicolor/scalable/actions/)
install(FILES ${CMAKE_CURRENT_SOURCE_DIR}/sc_add_blue.svg DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/icons/hicolor/scalable/actions/)
install(FILES ${CMAKE_CURRENT_SOURCE_DIR}/sc_apply.svg DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/icons/hicolor/scalable/actions/)
install(FILES ${CMAKE_CURRENT_SOURCE_DIR}/sc_cancel.svg DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/icons/hicolor/scalable/actions/)
install(FILES ${CMAKE_CURRENT_SOURCE_DIR}/sc_document-open.svg DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/icons/hicolor/scalable/actions/)
install(FILES ${CMAKE_CURRENT_SOURCE_DIR}/sc_ham.svg DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/icons/hicolor/scalable/actions/)
install(FILES ${CMAKE_CURRENT_SOURCE_DIR}/sc_list-remove.svg DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/icons/hicolor/scalable/actions/)
install(FILES ${CMAKE_CURRENT_SOURCE_DIR}/sc_menu_new.svg DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/icons/hicolor/scalable/actions/)
install(FILES ${CMAKE_CURRENT_SOURCE_DIR}/sc_menu_properties.svg DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/icons/hicolor/scalable/actions/)
install(FILES ${CMAKE_CURRENT_SOURCE_DIR}/sc_open.svg DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/icons/hicolor/scalable/actions/)
install(FILES ${CMAKE_CURRENT_SOURCE_DIR}/sc_start.svg DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/icons/hicolor/scalable/actions/)
if( NOT (${ICON_UPDATE} STREQUAL "OFF" ))
	find_program ( GTK_UPDATE_ICON_CACHE NAMES gtk-update-icon-cache.3.0 gtk-update-icon-cache )
	install (CODE "execute_process ( COMMAND ${GTK_UPDATE_ICON_CACHE} -f -t ${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_DATAROOTDIR}/icons/hicolor )" )
ENDIF()
