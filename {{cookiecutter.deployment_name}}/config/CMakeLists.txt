register_fprime_config(
    CONFIGURATION_OVERRIDES
        "${CMAKE_CURRENT_LIST_DIR}/AcConstants.fpp"
        "${CMAKE_CURRENT_LIST_DIR}/ActiveLoggerImplCfg.hpp"
        "${CMAKE_CURRENT_LIST_DIR}/BufferManagerComponentImplCfg.hpp"
        "${CMAKE_CURRENT_LIST_DIR}/CommandDispatcherImplCfg.hpp"
        "${CMAKE_CURRENT_LIST_DIR}/FpConfig.h"
        "${CMAKE_CURRENT_LIST_DIR}/StaticMemoryConfig.hpp"
        "${CMAKE_CURRENT_LIST_DIR}/TlmChanImplCfg.hpp"
{%- if cookiecutter.file_system_type == "SD_Card" %}
    CHOOSES_IMPLEMENTATIONS
        Os_File_Arduino_SD
{%- elif cookiecutter.file_system_type == "MicroFS" %}
    CHOOSES_IMPLEMENTATIONS
        Os_File_Baremetal_MicroFs
{%- endif %}
    INTERFACE
)
