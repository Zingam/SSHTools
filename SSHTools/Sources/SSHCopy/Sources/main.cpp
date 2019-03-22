#include <SSHTools/Common>

#include <ConfiParse/ConfiParse>

#include <libssh/libssh.h>

#include <QApplication>
#include <QWidget>

#include <iostream>

int
main(int argc, char* argv[])
{
  ConfiParse::Parser();
  std::cout << "Profile folder location:\n";
  std::cout << "  " << Common::GetSystemPathname(Common::SystemPath::Profile)
            << "\n";

  ssh_session my_ssh_session = ssh_new();
  if (my_ssh_session == NULL)
    exit(-1);
  
  QApplication app(argc, argv);

  QWidget window;
  window.resize(320, 240);
  window.show();
  window.setWindowTitle(QWidget::tr("SSHCopy"));

  return app.exec();
}
