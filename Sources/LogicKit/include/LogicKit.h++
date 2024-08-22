#ifndef LOGIC_KIT_H
#define LOGIC_KIT_H

#include <string>
#include <vector>

#include <SWI-Prolog.h>
#include <SWI-cpp2.h>

namespace looe::LegalXML::LogicKit
{

class PrologVM final
{
private:
  std::string argv0;
  PlEngine engine;

public:
  PrologVM(const std::string &argv0);
  bool isInitialised(void);
  ~PrologVM(void);
};

}

#endif