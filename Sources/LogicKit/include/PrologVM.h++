#ifndef PROLOGVM_H
#define PROLOGVM_H

#include <string>
#include <vector>

#include <SWI-Prolog.h>
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"
// this is brain-damaged, TODO: fix it upstream
#include <SWI-cpp2.h>
#pragma GCC diagnostic pop

namespace looe::LogicKit
{

class PrologVM final
{
private:
  std::vector<std::string> args;
  std::vector<char *> cArgs;
  PlEngine engine;

public:
  PrologVM(const std::string &argv0);
  PrologVM(const PrologVM&);
  bool isInitialised(void);
  ~PrologVM(void);
};

}

#endif