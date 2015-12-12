require 'ostruct'
require_relative '../../app/services/project_filters'

module ProjectFilters
  describe Chain do
    it 'Default empty' do
      expect(Chain.new.array(:languages)).to eq([])
    end

    it 'Single hash' do
      data = { languages: %w(a b) }
      expect(Chain.new(data).array(:languages)).to eq(%w(a b))
    end

    it 'Multiple hashes, first hash takes precedence' do
      a = { languages: %w(a b) }
      b = { languages: %w(c d) }
      expect(Chain.new(a, b).array(:languages)).to eq(%w(a b))
    end

    it 'Multiple hashes, first hash empty, so try the next hash' do
      a = { languages: [] }
      b = { languages: %w(a b) }
      expect(Chain.new(a, b).array(:languages)).to eq(%w(a b))
    end

    it 'Objects with methods, not just hashes' do
      a = { languages: [] }
      o = OpenStruct.new({ languages: %w(a b) })
      expect(Chain.new(a, o).array(:languages)).to eq(%w(a b))
    end

    it 'Empty hashes' do
      o = OpenStruct.new({ languages: %w(a b) })
      expect(Chain.new({}, o).array(:languages)).to eq(%w(a b))
    end

    it 'All empty' do
      expect(Chain.new({}, {}, {}).array(:languages)).to eq([])
    end

    it 'All nil' do
      expect(Chain.new(nil, nil).array(:languages)).to eq([])
    end

    it 'Can be initialized with array as well as positional args' do
      data = { languages: %w(a b) }
      expect(Chain.new([data]).array(:languages)).to eq(%w(a b))
    end
  end
end
