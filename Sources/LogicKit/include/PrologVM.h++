#ifndef PROLOGVM_H
#define PROLOGVM_H

#include <string>
#include <vector>
#include <memory>
#include <variant>

class PlEngine;

namespace looe::LogicKitC
{

class PrologQuery final {
public:
  struct Variable {
    char identifier;
  };

private:
  std::string predicateName;
  std::vector<std::variant<Variable, std::string>> args;

public:
  PrologQuery(const std::string &predicate
            , const std::vector<std::variant<Variable, std::string>> &args)
    : predicateName(predicate)
    , args(args)
    { }

  inline int getArity(void) const {
    return this->args.size();
  }

  inline std::string_view getPredicateName(void) const {
    return this->predicateName;
  }

  inline const char* getPredicateNameAsCString(void) const {
    return this->predicateName.c_str();
  }

  inline const auto& getParemeters(void) const {
    return this->args;
  }
};

extern void startPrologVM(const std::string &argv0);
extern std::string runQuery(const std::string &);
std::string runQuery (const PrologQuery &);
extern bool isInitialised(void);
extern void stopPrologVm(void);

}

#endif