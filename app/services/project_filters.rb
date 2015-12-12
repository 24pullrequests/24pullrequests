module ProjectFilters
  class Chain
    attr_reader :objects

    def initialize(*objects)
      @objects = objects.flatten
    end

    def array(key)
      array_of_arrays(key).find { |e| !e.empty? } || []
    end

    def array_of_arrays(key)
      objects.map { |e| Extractor.new(e, key).to_a }
    end
  end

  class Extractor
    attr_reader :hash, :key

    def initialize(hash, key)
      @hash = hash
      @key  = key
    end

    def to_a
      Array(value)
    end

    def value
      case hash
      when Hash
        hash[key]
      else
        hash.send(key) if hash.respond_to?(key)
      end
    end
  end
end
