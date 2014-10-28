require "rails_helper"

describe Event, type: :model do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:location) }
  it { is_expected.to validate_presence_of(:url) }
  it { is_expected.to validate_presence_of(:start_time) }
  it { is_expected.to validate_presence_of(:latitude) }
  it { is_expected.to validate_presence_of(:longitude) }
  it { is_expected.to validate_presence_of(:description) }

  context "validations" do
    let(:event) { FactoryGirl.build(:event) }

    it "should not pass with a start_at outside of 1st December - 24th December" do
      Timecop.freeze(Time.parse("1st January 1970")) do
        event.start_time = Time.parse("30th November")
        expect(event.valid?).not_to be true
        expect(event.errors[:start_time].include?("Events can only be created between 1st and 24th December")).to be true
      end
    end

    it "should not pass with a start_at in the past" do
      Timecop.freeze(Time.parse("15th December 2014")) do
        event.start_time = Time.parse("14th December 2014")
        expect(event.valid?).not_to be true
        expect(event.errors[:start_time].include?("Events can only be created in the past")).to be true
      end
    end

    it "should pass with a start_at on current date" do
      Timecop.freeze(Time.parse("15th December 2014 12:00")) do
        event.start_time = Time.parse("15th December 2014 13:00")
        expect(event.valid?).to be true
      end
    end

    context "after 1st December" do
      it "should not pass with a start_at within of 1st December - 24th December" do
        Timecop.freeze(Time.parse("1st December 2014")) do
          ["1st December", "15th December", "24th December"].each do |time|
            event.start_time = Time.parse(time)
            expect(event.valid?).to be true
          end
        end
      end
    end
  end

  context "start_time" do
    let(:event) { FactoryGirl.build(:event) }

    it "should be formatted correctly" do
      event.start_time = Time.parse("1st December 2014 15:30")
      expect(event.formatted_date).to eq "Monday 01 December 2014 at 03:30PM"
    end
  end
end
