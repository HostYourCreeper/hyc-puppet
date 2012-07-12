module Puppet::Parser::Functions
  newfunction(:ip_transform) do |ip|
    ip_numbers = ip.split('.')
    ip_numbers[0...-1].join('.') + ".#{ip_numbers.last.to_i + 127}"
  end
end
