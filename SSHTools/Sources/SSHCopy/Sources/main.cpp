#include <SSHTools/Common>

#include <ConfiParse/ConfiParse>

#include <libssh/libssh.h>

#include <iostream>

int
main(int argc, char* argv[])
{
  ConfiParse::Parser();
  std::cout << "Profile folder location:\n";
  std::cout << "  " << Common::GetSystemPathname(Common::SystemPath::Profile)
            << "\n";
}
