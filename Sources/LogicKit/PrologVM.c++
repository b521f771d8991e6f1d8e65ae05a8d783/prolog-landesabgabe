#include <vector>
#include <string>
#include <iostream>

#include <algorithm>

#include <boost/numeric/conversion/cast.hpp>
#include <boost/filesystem.hpp>

#include <PrologVM.h++>
#include <LogicKit.h++>

namespace looe::LogicKit
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
    : args(std::vector<std::string>{ argv0, std::string("--home=")
                                              + swiplHomeRunPath }),
      cArgs(map(
        this->args, +[](std::string &i) -> char * { return &i[0]; })),
      engine(boost::numeric_cast<int>(this->cArgs.size()), this->cArgs.data())
{
  assert(PL_is_initialised(nullptr, nullptr));
}

PrologVM::PrologVM(const PrologVM& pvm)
: args(pvm.args)
, cArgs(pvm.cArgs)
, engine(boost::numeric_cast<int>(this->cArgs.size()), this->cArgs.data())
{}

bool
PrologVM::isInitialised(void)
{
  return PL_is_initialised(nullptr, nullptr);
}

PrologVM::~PrologVM(void)
{
  if(PL_is_initialised(nullptr, nullptr))
    {
      std::cerr << "shutting down SWI Prolog" << std::endl;
      PL_halt(0);
    }
}

}