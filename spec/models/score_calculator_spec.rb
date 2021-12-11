require 'rails_helper'

describe ScoreCalculator do
  let(:token) { 'token' }
  let(:project) { FactoryBot.create(:project) }
  subject(:score_calculator) { ScoreCalculator.new(project, token) }

  describe '#popularity_score' do
    it 'returns an integer score of project popularity' do
      expect(project).to receive(:repository).and_return(double(updated_at: 6.months.ago))
      expect(project).to receive(:issues).and_return([])
      expect(score_calculator.popularity_score).to be(0)
    end

    it 'returns a score of 5 if there are recent commits' do
      expect(project).to receive(:repository).and_return(double(updated_at: Time.now))
      expect(project).to receive(:issues).and_return([])
      expect(score_calculator.popularity_score).to eq(5)
    end

    it 'returns a score of 3 if there are 5 recent issues' do
      issue = double(:issue)
      expect(project).to receive(:repository).and_return(double(updated_at: 6.months.ago))
      expect(project).to receive(:issues).and_return([issue] * 5)
      expect(score_calculator.popularity_score).to eq(3)
    end

    it 'does not give more than the maximum points' do
      issue = double(:issue)
      expect(project).to receive(:repository).and_return(double(updated_at: 6.months.ago))
      expect(project).to receive(:issues).and_return([issue] * 40)
      expect(score_calculator.popularity_score).to eq(10)
    end
  end

  describe '#score' do
    it 'returns an integer score of project score' do
      expect_any_instance_of(Octokit::Client).to receive(:contents).and_return(JSON.parse(file_fixture("contents.json").read))
      expect_any_instance_of(Octokit::Client).to receive(:releases).and_return(JSON.parse(file_fixture("releases.json").read))
      expect_any_instance_of(Octokit::Client).to receive(:issues).and_return(JSON.parse(file_fixture("issues.json").read))
      expect_any_instance_of(Octokit::Client).to receive(:commits).and_return(JSON.parse(file_fixture("commits.json").read))
      expect_any_instance_of(Octokit::Client).to receive(:repo).and_return(JSON.parse(file_fixture("repo.json").read))
      
      expect(score_calculator.score).to be(18)
    end
  end
end
