#include "foo.hpp"

using namespace foo;

auto Foo::hello() -> std::string {
	return "Hello, foo!\n";
}
