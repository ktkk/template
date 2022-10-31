#include <iostream>

#include <foo.hpp>
#include <bar.hpp>

using namespace foo;
using namespace bar;

auto main() -> int {
	std::cout << "Hello, world!\n";

	std::cout << Foo::hello();
	std::cout << Foo::hello();

	return 0;
}
