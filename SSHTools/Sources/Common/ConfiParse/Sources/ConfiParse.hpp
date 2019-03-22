#pragma once

#include <SSHTools/Base_Macros>
#include <filesystem>

NAMESPACE_BEGIN(ConfiParse)

class Document
{};

Document
Parse(std::filesystem::path const& filepath);

Document
Parse(std::string_view const& source);


  class Parser
{
public:
  void Load(std::filesystem::path const& filepath);
  void Load(std::string_view const& source);

public:
  std::string GetNextLine();
};

NAMESPACE_END(ConfiParse)
