require 'rails_helper'

describe ProjectSearch do
  context 'Attributes' do
    it '#language' do
      expect(described_class.new(languages: %w{Ruby Elixir}).languages).to eq(%w{ruby elixir})
      expect(described_class.new(languages: 'ruby').languages).to eq(%w{ruby})
      expect(described_class.new(languages: nil).languages).to eq([])
      expect(described_class.new(languages: [nil, '']).languages).to eq([])
    end

    it '#labels' do
      expect(described_class.new(labels: %w{tests refactoring}).labels).to eq(%w{tests refactoring})
      expect(described_class.new(labels: 'tests').labels).to eq(%w{tests})
      expect(described_class.new(labels: nil).labels).to eq([])
      expect(described_class.new(labels: [nil, '']).labels).to eq([])
    end

    it '#page' do
      expect(described_class.new(page: '1').page).to eq(1)
      expect(described_class.new(page: nil).page).to eq(1)
      expect(described_class.new(page: -1).page).to eq(1)
      expect(described_class.new(page: 2).page).to eq(2)
    end

    it '#per_page' do
      expect(described_class.new.per_page).to eq(Project.default_per_page)
      expect(described_class.new(per_page: 10).per_page).to eq(10)
    end
  end

  context 'Search' do
    let(:refactoring) do
      create(:label, name: 'refactoring')
    end

    let(:tests) do
      create(:label, name: 'tests')
    end

    let!(:rails) do
      create(:project, name: 'Rails',
                       main_language: 'Ruby',
                       labels: [refactoring])
    end

    let!(:phoenix) do
      create(:project, name: 'Phoenix',
                       main_language: 'Elixir',
                       labels: [tests])
    end

    let!(:inactive) do
      create(:project, name: 'Inactive',
                       main_language: 'JavaScript',
                       inactive: true)
    end

    it 'Default find all' do
      expect(described_class.new.call.map(&:name))
        .to match_array(%w{Rails Phoenix})
    end

    it 'Pagination' do
      expect(described_class.new(page: 1, per_page: 1).call.length).to eq(1)
      expect(described_class.new(page: 2, per_page: 1).call.length).to eq(1)
      expect(described_class.new(page: 3, per_page: 1).call.length).to eq(0)
    end

    it '#more?' do
      expect(described_class.new(page: 1, per_page: 1).more?).to eq(true)
      expect(described_class.new(page: 2, per_page: 1).more?).to eq(false)
      expect(described_class.new(page: 3, per_page: 1).more?).to eq(false)
    end

    it 'random order' do
      expect(described_class.new.call.to_sql).to match('ORDER BY random()')
    end

    it 'by_language' do
      expect(described_class.new(languages: []).call.length).to eq(2)
      expect(described_class.new(languages: 'Ruby').call.map(&:name)).to eq(%w{Rails})
    end

    it 'by_label' do
      expect(described_class.new(labels: []).call.length).to eq(2)
      expect(described_class.new(labels: 'refactoring').call.map(&:name)).to eq(%w{Rails})
    end

    it 'by_label and by_language' do
      expect(described_class.new(languages: 'Ruby', labels: 'tests').call.map(&:name)).to eq([])
      expect(described_class.new(languages: 'Ruby', labels: 'refactoring').call.map(&:name)).to eq(%w(Rails))
      expect(described_class.new(languages: %w(Ruby Elixir), labels: %w(refactoring tests)).call.map(&:name)).to match_array(%w(Rails Phoenix))
    end
  end
end
