#include <iostream>
#include <nlohmann/json_fwd.hpp>
#include <string>
#include <utility>
#include <vector>
#include <variant>

#include <algorithm>

#include <boost/filesystem.hpp>
#include <boost/numeric/conversion/cast.hpp>

#include <LogicKit.h++>
#include <PrologVM.h++>

#include <nlohmann/json.hpp>
#include <tl/expected.hpp>

#include <SWI-Prolog.h>
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"
// this is brain-damaged, TODO: fix it upstream
#include <SWI-cpp2.h>
#pragma GCC diagnostic pop

namespace looe::LogicKitC
{

std::vector<std::string> args;
std::vector<char *> cArgs;
std::unique_ptr<PlEngine> engine;

template <typename T, typename A>
std::vector<T>
map (std::vector<A> &container, T (*const f) (A &))
{
  std::vector<T> output;
  output.reserve (container.size ());
  std::transform (container.begin (), container.end (),
                  std::back_inserter (output), f);
  return output;
}

void
startPrologVM (const std::string &argv0)
{
  if(!isInitialised()) {
    initPrologHome();

    args = std::vector<std::string> (
        { argv0, std::string ("--home=") + swiplHomeRunPath });

    cArgs = std::vector<char *> (
        map<char *> (args, +[] (std::string &i) -> char * { return &i[0]; }));

    engine = std::make_unique<PlEngine> (
        boost::numeric_cast<int> (cArgs.size ()), cArgs.data ());

    if(!PL_is_initialised (nullptr, nullptr)) {
      std::cerr << "PrologVM should be initialised but isn't?" << std::endl;
    }
  }
}

bool
isInitialised (void)
{
  return PL_is_initialised (nullptr, nullptr);
}

tl::expected<std::pair<std::string, std::vector<std::string>>, std::string>
parseQuery(const std::string &query) {
  if(not isInitialised() or query == "") {
    return tl::unexpected("");
  }

  const auto request = nlohmann::json::parse(query);

  if(not request.is_object()) {
    return tl::unexpected("request malformed: not a JSON object");
  }

  if(not request.contains("predicate")) {
    return tl::unexpected("request malformed: JSON does not contain 'predicate'");
  }

  const auto arguments = request["arguments"];

  if(not request.contains("arguments")) {
    return tl::unexpected("request malformed: JSON does not contain 'args'");
  }

  if(not arguments.is_array()) {
    return tl::unexpected("request malformed: arguments is not an array");
  }

  const std::string predicate = request["predicate"];
  const std::vector<std::string> args = arguments;

  return std::make_pair(predicate, args);
}

std::string
runQuery (const std::string &query)
{
  const auto result = parseQuery(query);

  if(not result.has_value()) {
    return result.error();
  }

  return query;
}

predicate_t
constructPredicateFromQuery(const PrologQuery &query, term_t a0) {
  const predicate_t p = PL_predicate(query.getPredicateNameAsCString(), query.getArity(), NULL);

  for(size_t counter = 0; counter < query.getParemeters().size();
    counter++) {
    const PrologQuery::ArgType& currentParemeter = query.getParemeters().at(counter);

    if(std::holds_alternative<std::string>(currentParemeter)) {
      const char* const currentParameterText = std::get<std::string>(currentParemeter).c_str();
      PL_put_atom_chars(a0 + counter, currentParameterText);
    }
  }

  return p;
}

std::vector<PrologQuery::ArgType>
runQuery (const PrologQuery &query) 
{
  const term_t a0 = PL_new_term_refs(query.getArity());
  const predicate_t p = constructPredicateFromQuery(query, a0);
  const qid_t qid = PL_open_query(NULL, PL_Q_PASS_EXCEPTION, p, a0);

  std::vector<PrologQuery::ArgType> arguments;

  while(PL_next_solution(qid) != FALSE)
    {
      // we found a solution, save it in the PrologQuery
      
    }
  
  PL_close_query(qid);

  return arguments;
}

void
stopPrologVM (void)
{
  if (PL_is_initialised (nullptr, nullptr))
    {
      std::cerr << "shutting down SWI Prolog" << std::endl;
      PL_halt (0);
    }
}

} // namespace looe::LogicKitC