#include "catch2/catch.hpp"
#include "utility/Any.h"

TEST_CASE("测试万能容器Any", "[Any]") {
    SECTION("使用默认构造创建一个空对象") {
        Any any;
        REQUIRE_FALSE(any.HasValue());
        REQUIRE(is_type<void>(any));
    }
    SECTION("使用一个已有的对象复制构造一个新对象") {
        Any any1(42);
        Any any2(any1);
        REQUIRE(any2.HasValue());
        REQUIRE(is_type<int>(any1));
        REQUIRE(is_type<int>(any2));
        REQUIRE(any_cast<int>(any2) == 42);
    }
    SECTION("使用一个已有的对象移动构造一个新对象") {
        Any any1(3.14);
        Any any2(std::move(any1));
        REQUIRE_FALSE(any1.HasValue());
        REQUIRE(any2.HasValue());
        REQUIRE(is_type<double>(any2));
        REQUIRE(any_cast<double>(any2) == 3.14);
    }
    SECTION("使用任意类型赋值初始化") {
        Any any1 = 42;
        Any any2 = 3.14;
        Any any3 = std::string("hello");
        REQUIRE(any1.HasValue());
        REQUIRE(any_cast<int>(any1) == 42);
        REQUIRE(any2.HasValue());
        REQUIRE(any_cast<double>(any2) == 3.14);
        REQUIRE(any3.HasValue());
        REQUIRE(any_cast<std::string>(any3) == "hello");
    }
    SECTION("Any使用赋值运算符复制对象") {
        Any any1(42);
        Any any2;
        any2 = any1;
        REQUIRE(any2.HasValue());
        REQUIRE(any_cast<int>(any2) == 42);
        Any any3 = 38;
        const Any any4 = any3;
        Any any5 = any4;
        REQUIRE(any5.HasValue());
        REQUIRE(any_cast<int>(any5) == 38);
    }
    SECTION("使用赋值运算符移动给定对象") {
        Any any1(3.14);
        Any any2;
        any2 = std::move(any1);
        REQUIRE_FALSE(any1.HasValue());
        REQUIRE(any2.HasValue());
        REQUIRE(any_cast<double>(any2) == 3.14);
    }
    SECTION("清空容器") {
        Any any(42);
        REQUIRE(any.HasValue());
        any.Reset();
        REQUIRE_FALSE(any.HasValue());
    }
    SECTION("如果类型不正确, 函数将引发bad_cast异常") {
        Any any(42);
        // AnyCast返回对存储值的引用")
        REQUIRE_NOTHROW(any_cast<int>(any) == 42);
        //如果类型不正确，抛出异常
        REQUIRE_THROWS_AS(any_cast<double>(any), std::bad_cast);
    }
    SECTION("如果对象是指定的类型, is_type返回true否则返回false") {
        Any any(42);
        REQUIRE(is_type<int>(any));
        any = 3.14;
        REQUIRE_FALSE(is_type<int>(any));
        any = std::string("hello");
        REQUIRE(is_type<std::string>(any));
    }
}