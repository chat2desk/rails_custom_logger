# frozen_string_literal: true

require_relative "lib/rails_custom_logger/version"

Gem::Specification.new do |spec|
  spec.name = 'rails_custom_logger'
  spec.summary = 'Rails custom logger'
  spec.version = RailsCustomLogger::VERSION
  spec.authors = ['C2D team']
  spec.description = 'Rails custom logger'
  spec.platform = Gem::Platform::RUBY
  spec.required_ruby_version = '>= 2.6.2'

  spec.require_paths = ['lib']

  spec.metadata['rubygems_mfa_required'] = 'true'
end
