#ifndef __ANY_H__
#define __ANY_H__

#include <iostream>
#include <memory>
#include <typeindex>

class Any {
  private:
    struct HoldBase {
        virtual ~HoldBase() = default;
        virtual std::unique_ptr<HoldBase> Clone() const = 0;
    };

    template <typename T>
    struct Hold : public HoldBase {
        Hold(const T &value) : value_(value) {}
        Hold(T &&value) : value_(std::move(value)) {}
        inline std::unique_ptr<HoldBase> Clone() const override {
            return std::make_unique<Hold<T>>(value_);
        }
        T value_;

      private:
        Hold &operator=(const Hold &other) = delete;
        Hold(const Hold &other) = delete;
    };

  public:
    Any(void) : type_index_(typeid(void)) {}
    Any(const Any &other)
        : holdbase_(other.holdbase_ ? other.holdbase_->Clone() : nullptr),
          type_index_(other.type_index_) {}
    Any(Any &&other) : holdbase_(std::move(other.holdbase_)), type_index_(other.type_index_) {}
    template <typename T, class = typename std::enable_if<
                              !std::is_same<typename std::decay<T>::type, Any>::value, T>::type>
    Any(T &&value)
        : holdbase_(new Hold<typename std::decay<T>::type>(std::forward<T>(value))),
          type_index_(typeid(typename std::decay<T>::type)) {}
    Any &operator=(Any &&other) {
        holdbase_ = std::move(other.holdbase_);
        type_index_ = other.type_index_;
        return *this;
    }
    Any &operator=(const Any &other) {
        if (other.holdbase_) {
            holdbase_ = other.holdbase_->Clone();
            type_index_ = other.type_index_;
        }
        return *this;
    }
    Any &swap(Any &other) {
        std::swap(holdbase_, other.holdbase_);
        std::swap(type_index_, other.type_index_);
        return *this;
    }
    inline bool HasValue() const { return !!holdbase_; }
    inline void Reset() {
        holdbase_.reset();
        type_index_ = typeid(void);
    }

  private:
    template <class T>
    inline bool Is() const {
        return type_index_ == typeid(T);
    }
    template <class T>
    inline T &AnyCast() {
        if (!Is<T>()) {
            if (type_index_ != typeid(void)) {
                std::cout << "can not cast " << type_index_.name() << " to " << typeid(T).name()
                          << std::endl;
            }
            throw std::bad_cast();
        }
        auto hold = dynamic_cast<Hold<T> *>(holdbase_.get());
        return hold->value_;
    }

  private:
    template <class T>
    friend T &any_cast(Any &Value);
    template <class T>
    friend T &any_cast(Any &&Value);
    template <class T>
    friend bool is_type(Any &value);
    template <class T>
    friend bool is_type(Any &&value);
    std::unique_ptr<HoldBase> holdbase_;
    std::type_index type_index_;
};

template <class T>
T &any_cast(Any &value) {
    return value.AnyCast<T>();
}
template <class T>
T &any_cast(Any &&value) {
    return value.AnyCast<T>();
}
template <class T>
bool is_type(Any &&value) {
    return value.Is<T>();
}
template <class T>
bool is_type(Any &value) {
    return value.Is<T>();
}

#endif // __ANY_H__