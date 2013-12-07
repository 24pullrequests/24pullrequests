module CapybaraHelpers

  def select_from field_id, position
    select(all("##{field_id} option")[position].text, from: field_id)
  end
end

RSpec.configure do |config|
  config.include CapybaraHelpers, type: :request
end
