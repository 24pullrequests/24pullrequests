require "yaml"
require "i18n/tasks"

RSpec.describe 'I18n' do

  it "has consistent locale files" do
    test_translations
  end

  it "uses the same interpolations as en in every locale" do
    inconsistent = I18n::Tasks::BaseTask.new.inconsistent_interpolations
    expect(inconsistent.leaves.to_a).to be_empty,
      "#{inconsistent.leaves.count} translations drop or rename a %{variable}, run `i18n-tasks check-consistent-interpolations`"
  end

  [
    ['fr', 'organisations.members', 0, '0 membre'],
    ['hi', 'organisations.members', 0, '0 सदस्य'],
    ['ru', 'organisations.members', 21, '21 Участник'],
    ['hi', 'dashboard.tweet_progress', 0,
     'I’ve sent 0 pull request in December! Join me in giving back to open source with @24pullrequests.']
  ].each do |locale, key, count, expected|
    it "interpolates #{count} in #{locale}.#{key} with its locale plural rule" do
      backend = I18n::Backend::Simple.new.extend(I18n::Backend::Pluralization)
      allow(I18n.config).to receive(:enforce_available_locales).and_return(false)
      allow(I18n.config).to receive(:backend).and_return(backend)
      pluralization_path = File.join(Gem::Specification.find_by_name('rails-i18n').gem_dir,
                                    'rails', 'pluralization', "#{locale}.rb")
      backend.load_translations(File.expand_path("../config/locales/#{locale}.yml", __dir__), pluralization_path)

      expect(I18n.t(key, locale: locale, count: count)).to eq(expected)
    end
  end

  def collect_combined_keys(hash, ns = nil)
    hash.collect do |k, v|
      keys = []
      keys << collect_combined_keys(v, "#{ns}.#{k}") if v.is_a?(Hash)
      keys << "#{ns}.#{k}"
    end.flatten
  end

  def test_translations
    locales_path = File.expand_path("../../config/locales", __FILE__)
    locales = Dir.glob("#{locales_path}/*.yml").collect do |file_path|
      File.basename(file_path, ".yml")
    end

    locales.reject!{|l| l == "simple_form.en"}

    # collecting all locales
    locale_keys = {}
    locales.sort.each do |locale|
      translations = YAML.load_file("#{locales_path}/#{locale}.yml")
      locale_keys[locale] = collect_combined_keys(translations[locale])
    end

    # Using en as reference
    reference = locale_keys[locales.delete("en")]
    expect(reference).not_to be_empty

    locale_keys.each do |locale, keys|
      missing = reference - keys

      expect(missing).to be_empty, "#{locale} locale is missing: #{missing.join(', ')}"
      extra = keys - reference
      expect(extra).to be_empty, "#{locale} locale has extra: #{extra.join(', ')}"
    end
  end

end
