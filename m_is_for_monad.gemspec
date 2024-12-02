# frozen_string_literal: true

require_relative "lib/m/version"

Gem::Specification.new do |spec|
  spec.name = "m_is_for_monad"
  spec.version = M::VERSION
  spec.authors = ["Anton Semenov"]
  spec.email = ["anton.estum@gmail.com"]

  spec.summary = "M is for Monad"
  spec.description = "Shorthand `M` module with injected dry-monads."
  spec.homepage = "https://github.com/estum/m_is_for_monad"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.7.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/estum/m_is_for_monad"
  spec.metadata["changelog_uri"] = "https://github.com/estum/m_is_for_monad/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "dry-monads", ">= 1.4.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end