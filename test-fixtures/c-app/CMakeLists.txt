cmake_minimum_required(VERSION 3.20)
project(hello-c VERSION 1.0.0 LANGUAGES C)

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)

add_library(greet src/greet.c)
target_include_directories(greet PUBLIC
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
  $<INSTALL_INTERFACE:include>)
target_compile_options(greet PRIVATE -Wall -Wextra -Werror)

add_executable(hello src/main.c)
target_link_libraries(hello PRIVATE greet)
target_compile_options(hello PRIVATE -Wall -Wextra -Werror)

include(CTest)
if(BUILD_TESTING)
  add_executable(test_greet tests/test_greet.c)
  target_link_libraries(test_greet PRIVATE greet)
  add_test(NAME test_greet COMMAND test_greet)
endif()

include(GNUInstallDirs)
install(TARGETS hello greet
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR})
install(FILES include/greet.h DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})
