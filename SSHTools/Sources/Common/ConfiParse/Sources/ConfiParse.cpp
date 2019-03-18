#include "ConfiParse.hpp"

static std::string name{ "ConfiParse" };
static std::string version{ "0.1.0" };

namespace ConfiParse {

std::string const&
GetName()
{
  return name;
}

std::string const&
GetVersion()
{
  return version;
}

}
