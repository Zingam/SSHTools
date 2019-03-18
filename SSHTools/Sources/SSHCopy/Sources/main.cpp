#include <ConfiParse/ConfiParse>

#include <iostream>

int
main(int argc, char* argv[])
{
  std::cout << "Using:"
            << "\n";
  std::cout << "  library: " << ConfiParse::GetName() << "\n";
  std::cout << "  version: " << ConfiParse::GetVersion() << "\n";
}
