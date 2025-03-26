#include <assert.h>

#include <string>
#include <iostream>

#include <assets.h>

int
main(int argc, const char *argv[])
{
  init_program_root();

  for(const std::string &file : list_all())
    {
      auto i = fetch(file);

      if(!i.has_value())
        {
          std::cerr << "Could not open file: " << file << std::endl;
          return 1;
        }

      std::cout << "Succeeded to open: " << file << "(" << i.value().size()
                << ")" << std::endl;
    }

  return 0;
}