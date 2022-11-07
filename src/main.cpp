#include <iostream>

#include <bar.hpp>
#include <foo.hpp>

using namespace foo;
using namespace bar;

auto main() -> int
{
    std::cout << "Hello, world!\n";

    std::cout << Foo::hello();
    std::cout << Foo::hello();

    // A nice little comment

    return 0;
}
