#pragma once

#include <SSHTools/Base_Macros>

#include <filesystem>

NAMESPACE_BEGIN(Common)

enum class SystemPath
{
  Desktop,
  Documents,
  LocalAppData,
  Profile,
  RoamingAppData,
  SavedGames,
};

std::filesystem::path const
GetSystemPathname(SystemPath systemPath);

NAMESPACE_END(Common)
