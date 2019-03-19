#include <SSHTools/Common>
#include <ConfiParse/ConfiParse>

#include <iostream>


int
main(int argc, char* argv[])
{
  std::cout << "Using:\n";
  std::cout << "  library: " << ConfiParse::GetName() << "\n";
  std::cout << "  version: " << ConfiParse::GetVersion() << "\n";
  std::cout << "Profile folder location:\n";
  std::cout << "  " << Common::GetSystemPathname(Common::SystemPath::Profile)
            << "\n";
}
