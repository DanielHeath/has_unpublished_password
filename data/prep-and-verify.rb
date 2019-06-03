# coding: utf-8

require 'digest/sha1'
require 'has_unpublished_password'

password_count = 560_000_000 # Faster
passwords_to_filter = (password_count / 50) # most popular 1/5th

# bloom = HasUnpublishedPassword::ShaBloom::DefaultConfig.new
# i = 0
# File.foreach(ARGV[0]) do |line|
#   bloom.add_shahash(line)

#   i += 1
#   puts "#{i} / #{passwords_to_filter} (used #{line[41..-1].strip} times)" if i % (passwords_to_filter / 1000) == 0
#   if i >= passwords_to_filter
#     puts "Reached iteration count at #{i}/#{passwords_to_filter}"
#     break
#   end
# end

# puts 'exporting'
# bloom.serialize("serialized-top-#{passwords_to_filter}", verbose: true)

bloom = HasUnpublishedPassword::ShaBloom::DefaultConfig.deserialize("serialized-top-#{passwords_to_filter}")
puts "has 'password' been found? #{bloom.check_value('password')}"
puts "has 'Password1' been found? #{bloom.check_value('Password1')}"
exit
i = 0
false_positives = []
failures = []
File.foreach(ARGV[0]) do |line|
  false_positives << i if bloom.check_shahash('a' + line[0..39] )
  failures << i unless bloom.check_shahash line[0..39]
  i += 1
  puts "#{i} / #{passwords_to_filter}" if i % (passwords_to_filter / 1000) == 0
  break if i >= passwords_to_filter
end

puts "Top #{passwords_to_filter}"
puts "#{100 * false_positives.length.to_f / passwords_to_filter}% false positive rate."
puts "#{100 * failures.length.to_f / passwords_to_filter}% false negative rate."
