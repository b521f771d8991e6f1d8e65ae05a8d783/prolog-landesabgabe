#include <iostream>
#include <string>
#include <utility>
#include <vector>
#include <variant>

#include <algorithm>

#include <boost/numeric/conversion/cast.hpp>

#include <LogicKit.h++>
#include <PrologVM.h++>

#include <SWI-Prolog.h>
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"
// this is brain-damaged, TODO: fix it upstream
#include <SWI-cpp2.h>
#pragma GCC diagnostic pop

namespace looe::LogicKit
{

std::vector<std::string> args;
std::vector<char *> cArgs;
std::unique_ptr<PlEngine> engine;

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

void
start_prolog_VM(const std::string &argv0)
{
  if(!is_initialised())
    {
      init_prolog_home();

      args = std::vector<std::string>(
        { argv0, std::string("--home=") + swiplHomeRunPath });

      cArgs = std::vector<char *>(map<char *>(
        args, +[](std::string &i) -> char * { return &i[0]; }));

      engine = std::make_unique<PlEngine>(
        boost::numeric_cast<int>(cArgs.size()), cArgs.data());

      if(!PL_is_initialised(nullptr, nullptr))
        {
          std::cerr << "PrologVM should be initialised but isn't?" << std::endl;
        }
    }
}

bool
is_initialised(void)
{
  return PL_is_initialised(nullptr, nullptr);
}

predicate_t
construct_predicate_from_query(const prolog_query &query, term_t a0)
{
  const predicate_t p
    = PL_predicate(query.get_predicate_name_cstr(), query.get_arity(), NULL);

  for(size_t counter = 0; counter < query.get_parameters().size(); counter++)
    {
      const prolog_query::arg_type &currentParemeter
        = query.get_parameters().at(counter);

      if(std::holds_alternative<std::string>(currentParemeter))
        {
          const char *const currentParameterText
            = std::get<std::string>(currentParemeter).c_str();
          PL_put_atom_chars(a0 + counter, currentParameterText);
        }
    }

  return p;
}

std::vector<prolog_query::arg_type>
run_query(const prolog_query &query)
{
  const term_t a0 = PL_new_term_refs(query.get_arity());
  const predicate_t p = construct_predicate_from_query(query, a0);
  const qid_t qid = PL_open_query(NULL, PL_Q_PASS_EXCEPTION, p, a0);

  std::vector<prolog_query::arg_type> arguments;

  while(PL_next_solution(qid) != FALSE)
    {
      // we found a solution, save it in the PrologQuery
    }

  PL_close_query(qid);

  return arguments;
}

void
stop_prolog_VM(void)
{
  if(PL_is_initialised(nullptr, nullptr))
    {
      std::cerr << "shutting down SWI Prolog" << std::endl;
      PL_halt(0);
    }
}

} // namespace looe::LogicKit