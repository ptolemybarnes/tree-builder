require './lib/tree_builder.rb'

entrypoint = ARGV[0]
throw Exception.new('You must provide an entrypoint to the application') unless entrypoint && File.exists?(entrypoint)

puts TreeBuilder.call(File.read(entrypoint));
