// Third party libraries
#include <libssh/libssh.h>
#include <QDebug>
#include <QtWidgets>
// C++ Standard Libraries
#include <chrono>
#include <filesystem>
#include <iostream>
// C Standard Libraries
#include <cstring>
#include <ctime>

int
main(int argc, char* argv[])
{
  ssh_session sshSession = ssh_new();
  if (nullptr != sshSession) {
    ssh_options_set(sshSession, ssh_options_e::SSH_OPTIONS_HOST, "localhost");
    auto logProtocol = SSH_LOG_PROTOCOL;
    ssh_options_set(
      sshSession, ssh_options_e::SSH_OPTIONS_LOG_VERBOSITY, &logProtocol);
    auto portNumber = 22;
    ssh_options_set(sshSession, ssh_options_e::SSH_OPTIONS_PORT, &portNumber);

    auto sshResult = ssh_connect(sshSession);

    if (SSH_OK != sshResult) {
      auto error = ssh_get_error(sshSession);
      auto errorCode = ssh_get_error_code(sshSession);
      std::cout << "ssh: Could not connect session... \n";
      std::cout << "     Error:      " << error << "\n";
      std::cout << "     Error code: " << error << "\n";
    }
  }

  for (auto& directoryEntry :
       std::filesystem::directory_iterator(std::filesystem::current_path())) {
    if (directoryEntry.is_directory()) {
      continue;
    }

    auto GetFileWriteTime = [](const std::filesystem::path& filename) {
#if defined(_WIN32)
      {
        struct _stat64 fileInfo;
        if (_wstati64(filename.wstring().c_str(), &fileInfo) != 0) {
          throw std::runtime_error("Failed to get last write time.");
        }
        return fileInfo.st_mtime;
      }
#else
      {
        auto fsTime = std::filesystem::last_write_time(filename);
        return decltype(fsTime)::clock::to_time_t(fsTime);
      }
#endif
    };

    auto ftime = GetFileWriteTime(directoryEntry);
    char timeBuffer[26];
    struct tm localTimeBuffer;
    localtime_s(&localTimeBuffer, &ftime);
    asctime_s(timeBuffer, sizeof(timeBuffer), &localTimeBuffer);

    std::cout << "Filename   : " << directoryEntry.path().filename() << "\n";
    std::cout << "Filename   : " << directoryEntry.path().parent_path() << "\n";
    std::cout << "      size : " << directoryEntry.file_size() << "\n";
    std::cout << "  modified : " << timeBuffer << '\n';
  }

  if (nullptr != sshSession) {
    ssh_disconnect(sshSession);
  }

  QApplication app(argc, argv);

  QWidget window;
  window.resize(320, 240);
  window.show();
  window.setWindowTitle(QWidget::tr("SSHCopy"));

  return app.exec();
}
