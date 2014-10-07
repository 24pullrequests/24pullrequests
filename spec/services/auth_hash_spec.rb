require 'rails_helper'

describe AuthHash do

  describe "#user_info" do
    it "it extracts the user's information" do
      auth = AuthHash.new(user_hash)

      expect(auth.user_info[:token]).to eq('some-token')
    end
  end

end

def user_hash
  { "provider" => 'github',
    "uid" => "uid",
    "info" => { "nickname" => "jane-doe" },
    "credentials" => { "token" => 'some-token' } }
end
