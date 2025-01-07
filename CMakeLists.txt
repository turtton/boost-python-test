cmake_minimum_required(VERSION 3.09)
project(boost_python)

set(CMAKE_CXX_STANDARD 20)

add_library(boost_python module.cpp)

## Boost
# 環境変数でBoost_ROOTが設定されている場合はそれを使うように
if (DEFINED ENV{Boost_ROOT})
    cmake_policy(SET CMP0074 NEW)
endif ()
find_package(Boost REQUIRED COMPONENTS python)
if(Boost_FOUND)
    include_directories(${Boost_INCLUDE_DIRS})
    target_link_libraries(${PROJECT_NAME} ${Boost_LIBRARIES})
endif()
find_package(Python3 REQUIRED COMPONENTS Development)
if(Python3_FOUND)
    include_directories(${Python3_INCLUDE_DIRS})
    target_link_libraries(${PROJECT_NAME} ${Python3_LIBRARIES})
endif()
