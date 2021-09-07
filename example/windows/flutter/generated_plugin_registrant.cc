//
//  Generated file. Do not edit.
//

#include "generated_plugin_registrant.h"

#include <agent_dart/agent_dart_plugin.h>
#include <url_launcher_windows/url_launcher_windows.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  AgentDartPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("AgentDartPlugin"));
  UrlLauncherWindowsRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("UrlLauncherWindows"));
}
