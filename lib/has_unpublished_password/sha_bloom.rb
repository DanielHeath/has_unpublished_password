require 'bitfield'

module HasUnpublishedPassword

  class ShaBloom
    BITS_PER_HEX_CHAR=4
    class << self
      attr_accessor :hash_bits_per_filter, :filter_count, :filter_window, :filter_step
      def filter_window
        self.hash_bits_per_filter / BITS_PER_HEX_CHAR
      end
    end
    @hash_bits_per_filter = 24
    @filter_count = 34
    @filter_step = 1

    class DefaultConfig < ShaBloom
      @filter_count = 16
      @hash_bits_per_filter = 24
      @filter_step = 1
    end

    def initialize(filters=nil)
      unless filters
        filters = []
        self.class.filter_count.times do |i|
          filters[i] ||= Bitfield.new(2**self.class.hash_bits_per_filter)
        end
      end

      @bitfields = filters
    end

    def inspect
      to_s
    end

    def to_s
      "#{self.class} filter with #{self.class.filter_count} blocks of size #{2**self.class.hash_bits_per_filter / 8 / 1024}kb"
    end

    def add_value(value)
      add_shahash Digest::SHA1.hexdigest value
    end

    def check_value(value)
      check_shahash Digest::SHA1.hexdigest value
    end

    def add_shahash(hash)
      walk_hash(hash) do |row, idx|
        row.set(idx)
      end
    end

    def check_shahash(hash)
      walk_hash(hash) do |row, idx|
        return false unless row.get(idx)
      end
      return true
    end

    def serialize(pattern, verbose=false)
      self.class.filter_count.times do |i|
        fn = "#{pattern}-p#{i}.bloom"
        bitfields[i].serialize(fn)
        puts "wrote #{fn}" if verbose
        puts `du -h #{fn}` if verbose
      end
    end

    def self.deserialize(pattern)
      filters = []
      filter_count.times do |i|
        fn = "#{pattern}-p#{i}.bloom"
        filters << Bitfield.deserialize(fn, 2**hash_bits_per_filter)
      end
      new(filters)
    end

    private
    attr_reader :bitfields

    def walk_hash(hash)
      self.class.filter_count.times do |i|
        start  = i * self.class.filter_step
        finish = i * self.class.filter_step + self.class.filter_window - 1
        idx    = hash[start..finish].to_i(16)
        yield bitfields[i], idx
      end
    end
  end
end
