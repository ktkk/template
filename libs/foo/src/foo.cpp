#include "foo.hpp"

using namespace foo;

auto Foo::hello() -> std::string
{
    // A foo comment

    return "Hello, foo!\n";
}
