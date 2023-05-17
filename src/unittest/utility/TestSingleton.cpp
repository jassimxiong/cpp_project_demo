#include "utility/Singleton.h"
#include <catch2/catch.hpp>

#include <type_traits>

class MyClass {
  public:
    MyClass() {}
    MyClass(const MyClass &) = delete;
    MyClass &operator=(const MyClass &) = delete;
};
TEST_CASE("测试Singleton", "[Singleton]") {
    SECTION("返回一个单例") {
        auto &instance1 = Singleton<MyClass>::GetInstance();
        auto &instance2 = Singleton<MyClass>::GetInstance();
        REQUIRE(&instance1 == &instance2);
    }
    SECTION("禁止拷贝构造") {
        REQUIRE(std::is_copy_constructible<Singleton<MyClass>>::value == false);
        REQUIRE(std::is_copy_assignable<Singleton<MyClass>>::value == false);
    }
}