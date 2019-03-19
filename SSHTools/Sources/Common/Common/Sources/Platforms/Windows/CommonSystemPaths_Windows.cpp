#include "CommonSystemPaths_Windows.hpp"

#include <Shlobj.h>
#include <Windows.h>

#include <sstream>

NAMESPACE_BEGIN(Common::Platforms::Windows)

std::filesystem::path const
GetSystemPathname_Windows(SystemPath systemPath)
{
  KNOWNFOLDERID knownFolderId;

  switch (systemPath) {
    case SystemPath::Desktop: {
      knownFolderId = FOLDERID_Desktop;
      break;
    }
    case SystemPath::Documents: {
      knownFolderId = FOLDERID_Documents;
      break;
    }
    case SystemPath::Profile: {
      knownFolderId = FOLDERID_Profile;
      break;
    }
    case SystemPath::SavedGames: {
      knownFolderId = FOLDERID_SavedGames;
      break;
    }
    case SystemPath::LocalAppData: {
      knownFolderId = FOLDERID_LocalAppData;
      break;
    }
    case SystemPath::RoamingAppData: {
      knownFolderId = FOLDERID_RoamingAppData;
      break;
    }
    default: {
      knownFolderId = FOLDERID_Profile;
    }
  }

  PWSTR knownFolderPath;

  auto result = SHGetKnownFolderPath(
    knownFolderId, KF_FLAG_DEFAULT, nullptr, &knownFolderPath);

  std::wstringstream ss;
  ss << knownFolderPath;

  CoTaskMemFree(knownFolderPath);

  return std::filesystem::path{ ss.str() };
}

NAMESPACE_END(Common::Platforms::Windows)
