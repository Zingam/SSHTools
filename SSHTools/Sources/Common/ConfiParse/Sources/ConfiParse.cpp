#include "ConfiParse.hpp"

NAMESPACE_BEGIN(ConfiParse)

Document
Parse(std::filesystem::path const& filepath)
{
  return Document();
}

Document
Parse(std::string_view const& source)
{
  return Document();
}

void
Parser::Load(std::filesystem::path const& filepath)
{}

void
Parser::Load(std::string_view const& memorySource)
{}

std::string
Parser::GetNextLine()
{
  return std::string();
}

NAMESPACE_END(ConfiParse)
