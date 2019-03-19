#include "CommonSystemPaths.hpp"

#include "Platforms/CommonSystemPaths_Implementation"

NAMESPACE_BEGIN(Common)

std::filesystem::path const
GetSystemPathname(SystemPath systemPath)
{
  return GetSystemPathname_Implementation(systemPath);
}

NAMESPACE_END(Common)
