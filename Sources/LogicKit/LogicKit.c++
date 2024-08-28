#include <sys/syslog.h>
#include <syslog.h>

#include <assert.h>

#include <mutex>
#include <algorithm>
#include <vector>
#include <string>

#include <boost/numeric/conversion/cast.hpp>

#include <SWI-Prolog.h>
#include <SWI-cpp2.h>

#include <SWIPrologHome.h>
#include "LogicKit.h++"

namespace looe::LegalXML::LogicKit
{

template <typename T, typename A>
std::vector<T>
map(std::vector<A> &container, T (*const f)(A &))
{
  std::vector<T> output;
  output.reserve(container.size());
  std::transform(container.begin(), container.end(), std::back_inserter(output),
                 f);
  return output;
}

PrologVM::PrologVM(const std::string &argv0)
    : args({ argv0, "--home=/usr/lib64/swipl-9.2.6" }),
      cArgs(map(
        this->args, +[](std::string &i) -> char * { return &i[0]; })),
      engine(boost::numeric_cast<int>(this->cArgs.size()), this->cArgs.data())
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