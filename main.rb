require 'pathname'
require 'json'
require_relative './lib/tree_builder.rb'

entrypoint = ARGV[0]
throw Exception.new("No entrypoint provided") unless entrypoint
throw Exception.new("'#{entrypoint}' is not an absolute path") unless Pathname.new(entrypoint).absolute?
throw Exception.new("'#{entrypoint}' does not exist.") unless File.exist?(entrypoint)

puts TreeBuilder.call(entrypoint).to_h.to_json
