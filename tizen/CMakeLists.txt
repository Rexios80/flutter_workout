cmake_minimum_required(VERSION 3.19)
project(tizen)

set(CMAKE_CXX_STANDARD 14)

include_directories(inc)
include_directories(src)
include_directories(../../engine_tizen/shell/platform/common/cpp/client_wrapper/include)
include_directories(../../engine_tizen/shell/platform/common/cpp/public)
include_directories(../../../tizen-studio/platforms/tizen-4.0/wearable/rootstraps/wearable-4.0-device.core/usr/include/sensor)
include_directories(../../../tizen-studio/platforms/tizen-4.0/wearable/rootstraps/wearable-4.0-device.core/usr/include/dlog)

add_executable(tizen
        inc/health_tizen_plugin.h
        src/health_tizen_plugin.cc
        src/log.h)
