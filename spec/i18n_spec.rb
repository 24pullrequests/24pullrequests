require "yaml"

RSpec.describe 'I18n' do

  it "has consistent locale files" do
    test_translations
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
