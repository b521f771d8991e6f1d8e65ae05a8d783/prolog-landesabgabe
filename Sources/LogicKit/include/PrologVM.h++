#ifndef PROLOGVM_H
#define PROLOGVM_H

#include <string>
#include <vector>
#include <memory>

class PlEngine;

namespace looe::LogicKit
{

class PrologVM final
{
private:
  std::vector<std::string> args;
  std::vector<char *> cArgs;
  std::unique_ptr<PlEngine> engine;

public:
  PrologVM(const std::string &argv0);
  PrologVM(const PrologVM&);
  bool isInitialised(void);
  ~PrologVM(void);
};

}

#endif