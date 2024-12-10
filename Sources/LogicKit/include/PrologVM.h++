#ifndef PROLOGVM_H
#define PROLOGVM_H

#include <algorithm>
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
  
  using ArgType = std::variant<Variable, std::string>;

private:
  std::string predicateName;
  std::vector<ArgType> args;

public:
  PrologQuery(const std::string &predicate
            , const std::vector<ArgType> &args = {})
    : predicateName(predicate)
    , args(args)
    { }

  PrologQuery(const PrologQuery&) = default;

  inline int getArity(void) const {
    return this->args.size();
  }

  inline std::string_view getPredicateName(void) const {
    return this->predicateName;
  }

  inline const char* getPredicateNameAsCString(void) const {
    return this->predicateName.c_str();
  }

  inline const std::vector<ArgType>& getParemeters(void) const {
    return this->args;
  }

  //static PrologQuery fromFlatbuffer() {
  //  
  //}
  //
  //std::string toFlatbuffer() {
  //  
  //}
};

class PrologResult {
public:
  using Result = bool;

private:
  std::vector<Result> results;

public:
  PrologResult(const std::vector<Result>& r)
  : results(r)
  { }
  
  

  const std::vector<Result>& getResults(void) const {
    return this->results;
  }

  size_t resultCount(void) const {
    return this->results.size();
  }
};

extern void startPrologVM(const std::string &argv0);
extern std::string runQuery(const std::string &);
extern std::vector<PrologQuery::ArgType> runQuery (const PrologQuery &);
extern bool isInitialised(void);
extern void stopPrologVm(void);

}

#endif