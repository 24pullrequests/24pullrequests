require "rails_helper"

describe PopularityScorer do
  let(:nickname) { "nickname" }
  let(:token) { "token" }
  let(:project) { FactoryGirl.create(:project) }
  subject(:popularity_scorer) { PopularityScorer.new(nickname, token, project) }

  describe "#score" do
    it "returns an integer score of project popularity" do
      expect(project).to receive(:commits).and_return([])
      expect(project).to receive(:issues).and_return([])
      expect(popularity_scorer.score).to be(0)
    end

    it "returns a score of 5 if there are 50 recent commits" do
      commit = double(:commit)
      expect(project).to receive(:commits).and_return([commit] * 50)
      expect(project).to receive(:issues).and_return([])
      expect(popularity_scorer.score).to eq(5)
    end

    it "returns a score of 3 if there are 5 recent issues" do
      issue = double(:issue)
      expect(project).to receive(:commits).and_return([])
      expect(project).to receive(:issues).and_return([issue] * 5)
      expect(popularity_scorer.score).to eq(3)
    end

    it "does not give more than the maximum points" do
      commit = double(:commit)
      expect(project).to receive(:commits).and_return([commit] * 200)
      expect(project).to receive(:issues).and_return([])
      expect(popularity_scorer.score).to eq(10)
    end
  end

end
