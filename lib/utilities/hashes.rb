module Utilities::Hashes

  # Pass two hashes, a and b, print out those
  # situations in which a.merge(b) would change
  # a value assigned in a to something different (assigned in b)
  def self.puts_collisions(a, b)
    a.each do |i,j|
      if b[i] && !j.blank? && b[i] != j
        puts "#{i}: [#{j}] != [#{b[i]}]"
      end
    end
  end

  # Delete all matching keys in array from the hsh
  def self.delete_keys(hsh, array)
    hsh.delete_if{|k,v| array.include?(k)}
  end

  def self.tw_symbolize_keys(hash)
    hash.inject({}) do |h, (k, v)|
      h[k.is_a?(String) ? k.to_sym : k] = (v.is_a?(Hash) ? tw_symbolize_keys(v) : v)
      h
    end
  end

end
