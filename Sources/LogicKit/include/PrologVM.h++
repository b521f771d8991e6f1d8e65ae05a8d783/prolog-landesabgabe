#ifndef PROLOGVM_H
#define PROLOGVM_H

#include <string>
#include <vector>
#include <variant>
#include <filesystem>

class PlEngine;

namespace looe::LogicKit
{

class prolog_query final
{
public:
  struct Variable
  {
    char identifier;
  };

  using arg_type = std::variant<Variable, std::string>;

private:
  std::string predicateName;
  std::vector<arg_type> args;

public:
  prolog_query(const std::string &predicate,
               const std::vector<arg_type> &args = {})
      : predicateName(predicate), args(args)
  {
  }

  prolog_query(const prolog_query &) = default;

  inline int
  get_arity(void) const
  {
    return this->args.size();
  }

  inline std::string_view
  get_predicate_name(void) const
  {
    return this->predicateName;
  }

  inline const char *
  get_predicate_name_c_str(void) const
  {
    return this->predicateName.c_str();
  }

  inline const std::vector<arg_type> &
  get_parameters(void) const
  {
    return this->args;
  }
};

class prolog_result
{
public:
  using result = prolog_query::arg_type;

private:
  std::vector<result> results;

public:
  prolog_result(const std::vector<result> &r) : results(r) {}

  const std::vector<result> &
  get_results(void) const
  {
    return this->results;
  }

  size_t
  result_count(void) const
  {
    return this->results.size();
  }
};

class prolog_vm
{
  // TODO
};

extern void start_prolog_VM(const std::string &argv0,
                            const std::filesystem::path &assets);
extern bool is_initialised(void);
extern void stop_prolog_VM(void);
extern prolog_result run_predicate(const prolog_query &query);
extern prolog_result run_query(const prolog_query &query);

}

#endif