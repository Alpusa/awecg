//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <desktop_window/desktop_window_plugin.h>
#include <permission_handler_windows/permission_handler_windows_plugin.h>
#include <quick_blue_windows/quick_blue_windows_plugin.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  DesktopWindowPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("DesktopWindowPlugin"));
  PermissionHandlerWindowsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("PermissionHandlerWindowsPlugin"));
  QuickBlueWindowsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("QuickBlueWindowsPlugin"));
}
