#ifndef PROLOGVM_H
#define PROLOGVM_H

#include <vector>
#include <string>

namespace looe::logic_kit
{

class logic_vm
{
private:
  std::vector<std::string> errors;

public:
  logic_vm();
};

}

#endif