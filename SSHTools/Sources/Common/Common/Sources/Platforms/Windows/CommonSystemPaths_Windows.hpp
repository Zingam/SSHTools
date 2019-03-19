#pragma once

#include <SSHTools/Common>

NAMESPACE_BEGIN(Common::Platforms::Windows)

std::filesystem::path const
GetSystemPathname_Windows(SystemPath systemPath);

#if !defined(GetSystemPathname_Implementation)
#  define GetSystemPathname_Implementation                                               \
    Common::Platforms::Windows::GetSystemPathname_Windows
#else
#  Error GetSystemPathname_Impl is already defined...
#endif // !defined(GetSystemPathname_Implementation)

NAMESPACE_END(Common::Platforms::Windows)
