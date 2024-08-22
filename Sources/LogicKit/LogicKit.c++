#include <sys/syslog.h>
#include <syslog.h>

#include <cassert>
#include <cstddef>

#include <sstream>
#include <vector>
#include <string>
#include <ostream>

#include <SWI-Prolog.h>
#include <SWI-cpp2.h>

#include "LogicKit.h++"

namespace looe::LegalXML::LogicKit
{

std::string
to_string(const std::vector<std::string> &vec)
{
  std::stringstream ss;
  ss << '{';
  for(size_t i = 0; i < vec.size(); ++i)
    {
      ss << vec[i];
      if(i < vec.size() - 1)
        {
          ss << ", ";
        }
    }
  ss << '}';
  return ss.str();
}

PrologVM::PrologVM(const std::string &argv0)
    : argv0(argv0), engine(&this->argv0[0])
{
  assert(PL_is_initialised(nullptr, nullptr));
}

bool
PrologVM::isInitialised(void)
{
  return PL_is_initialised(nullptr, nullptr);
}

PrologVM::~PrologVM(void)
{
  if(PL_is_initialised(nullptr, nullptr))
    {
      syslog(LOG_DEBUG, "shutting down SWI Prolog");
      PL_halt(0);
    }
}

}