# frozen_string_literal: true

require_relative 'm/version'
require 'dry/monads/all'

# # M is for {Dry::Monads}
# It is shorthand mixin and singleton for {Dry::Monads}.
# So it expands monad methods in module functions and also includes all the monad constructors in the single place.
module M
  include Dry::Monads
  include List::Mixin

  class << List
    # @return [Proc]
    def to_proc
      @to_proc ||= method(:coerce).to_proc
    end
  end

  # Prepared {Dry::Monads::Do} mixin for `call` instance method.
  DoForCall ||=
    Do.for(:call)

  # Creates a module that has two methods: `Success` and `Failure`.
  # `Success` is identical to {Result::Mixin::Constructors#Success} and Failure
  # rejects values that don't conform the value of the `error`
  # parameter. This is essentially a Result type with the `Failure` part
  # fixed.
  #
  # @example using dry-types
  #   module Types
  #     include Dry::Types.module
  #   end
  #
  #   class Operation
  #     # :user_not_found and :account_not_found are the only
  #     # values allowed as failure results
  #     Error =
  #       Types.Value(:user_not_found) |
  #       Types.Value(:account_not_found)
  #
  #     include M::Result(Error)
  #
  #     def find_account(id)
  #       account = acount_repo.find(id)
  #
  #       account ? Success(account) : Failure(:account_not_found)
  #     end
  #
  #     def find_user(id)
  #       # ...
  #     end
  #   end
  #
  # @param error [#===] the type of allowed failures
  # @return [Module]
  def Result(error, **options)
    Dry::Monads::Result::Fixed[error, **options]
  end

  # @see Dry::Monads::Do.call
  define_method :Do, Do.method(:call)

  # @see Dry::Monads::Do.bind
  define_method :bind, Do.method(:bind)

  # @!scope class

  # @!method self.Try(*exceptions, &f)
  #   A convenience wrapper for {Dry::Monads::Try.run}.
  #   If no exceptions are provided it falls back to StandardError.
  #   In general, relying on this behaviour is not recommended as it can lead to unnoticed
  #   bugs and it is always better to explicitly specify a list of exceptions if possible.
  #   @param exceptions [Array<Exception>]
  #   @return [Dry::Monads::Try]

  # @!method self.Success(value = Undefined, &block)
  #   Success constructor
  #   @overload Success(value)
  #     @param value [Object]
  #   @overload Success(&block)
  #     @param block [Proc] a block to be wrapped with Success
  #   @return [Dry::Monads::Result::Success]

  # @!method self.Failure(value = Undefined, &block)
  #   Failure constructor
  #   @overload Success(value)
  #     @param value [Object]
  #   @overload Success(&block)
  #     @param block [Proc] a block to be wrapped with Failure
  #   @return [Dry::Monads::Result::Failure]

  # @!method self.Maybe(value)
  #   @param value [Object] the value to be stored in the monad
  #   @return [Dry::Monads::Maybe::Some, Dry::Monads::Maybe::None]

  # @!method self.None()
  #   @return [Dry::Monads::Maybe::None]

  # @!method self.Some(value = Undefined, &block)
  #   Some constructor
  #   @overload Some(value)
  #     @param value [Object] any value except `nil`
  #   @overload Some(&block)
  #     @param block [Proc] a block to be wrapped with Some
  #   @return [Dry::Monads::Maybe::Some]

  # @!method self.Task(&block)
  #   Builds a new Task instance.
  #   @param block [Proc]
  #   @return [Dry::Monads::Task]

  # @!method self.Valid(value = Undefined, &block)
  #   Valid constructor
  #   @overload Valid(value)
  #     @param value [Object]
  #   @overload Valid(&block)
  #     @param block [Proc]
  #   @return [Dry::Monads::Valdated::Valid]

  # @!method self.Lazy(&block)
  #   Lazy computation contructor
  #   Lazy is a twin of Task which is always executed on the current thread.
  #   The underlying mechanism provided by concurrent-ruby ensures the given
  #   computation is evaluated not more than once (compare with the built-in
  #   lazy assignement ||= which does not guarantee this).
  #   @param block [Proc]
  #   @return [Dry::Monads::Lazy]

  instance_methods.then do |list|
    module_function *list
    public *list
  end
end