require 'json'
require_relative './lib/tree_builder.rb'

entrypoint = ARGV[0]
throw Exception.new("You must provide a valid entrypoint") unless entrypoint
throw Exception.new("File does not exist: #{entrypoint}") unless File.exist?(entrypoint)

puts TreeBuilder.call(entrypoint).to_h.to_json
