require 'rails_helper'

describe LanguagesController, type: :controller do
  describe 'GET show' do
    subject(:show) { get :show, params: }

    let!(:project) { FactoryBot.create(:project, inactive:, main_language: language) }
    let(:inactive) { true }
    let(:language) { 'Ruby' }

    let(:params) { { id: language_params } }
    let(:language_params) { language }

    context 'when the language is valid' do
      # PROJECTS
      context 'when there are active projects' do
        let(:inactive) { false }

        context 'when there are projects with the language' do
          it 'sets the @projects instance variable to the projects with the language' do
            show

            expect(assigns(:projects)).to match_array([project])
          end
        end

        context 'when there are no projects with the language' do
          before { project.update(main_language: 'JavaScript') }

          it 'sets the @projects instance variable to empty' do
            show

            expect(assigns(:projects)).to eq([])
          end
        end

        context 'when there are more than 20 projects with the language' do
          let!(:active_projects) { FactoryBot.create_list(:project, 21, inactive:, main_language: language) }

          it 'sets the @projects instance variable to the first 20 projects' do
            show

            expect(assigns(:projects).count).to eq(20)
          end
        end
      end

      context 'when there are no active projects' do
        it 'sets the @projects instance variable to empty' do
          show

          expect(assigns(:projects)).to eq([])
        end
      end

      # USERS
      context 'when there exists contributors for the language' do
        let(:user1) { FactoryBot.create(:user, contributions_count: 200) }
        let!(:skill1) { FactoryBot.create(:skill, user: user1, language:) }

        let(:user2) { FactoryBot.create(:user, contributions_count: 230) }
        let!(:skill2) { FactoryBot.create(:skill, user: user2, language:) }

        it 'sets the @users instance variable sorted by contributions_count' do
          show

          expect(assigns(:users)).to match_array([user2, user1])
        end

        it 'uses valid date range counts with aggregation filters applied' do
          create :aggregation_filter, user: user1, title_pattern: 'Excluded title'
          create :contribution,
                 user: user1,
                 language:,
                 title: 'Excluded title',
                 created_at: Date.new(Tfpullrequests::Application.current_year, 12, 24)
          create :contribution,
                 user: user1,
                 language:,
                 created_at: Date.new(Tfpullrequests::Application.current_year, 12, 25)
          create :contribution,
                 user: user2,
                 language:,
                 created_at: Date.new(Tfpullrequests::Application.current_year, 12, 10)

          show

          users = assigns(:users).index_by(&:id)
          expect(users[user1.id].attributes['scoped_contributions_count'].to_i).to eq(0)
          expect(users[user2.id].attributes['scoped_contributions_count'].to_i).to eq(1)
        end
      end

      context 'when there exists more than 45 contributors for the language' do
        let!(:users) do
          FactoryBot.build_list(:user, 46).each_with_index do |user, _index|
            FactoryBot.create(:skill, user:, language:)
            user.save
          end
        end

        it 'sets the @users instance variable to a random sample of 45 users' do
          show

          expect(assigns(:users).count).to eq(45)
        end
      end

      context 'when there are no contributors for the language' do
        it 'sets the @users instance variable to empty' do
          show

          expect(assigns(:users)).to eq([])
        end
      end

      # CONTRIBUTIONS
      context 'when there exists contributions for the language' do
        let!(:contribution1) { FactoryBot.create(:contribution, language:) }

        context 'when the contribution is during the current year' do
          it 'sets the @contributions instance variable sorted by contributions_count' do
            show

            expect(assigns(:contributions)).to match_array([contribution1])
          end
        end

        context 'when the contribution is done during the previous year' do
          before { contribution1.update(created_at: 2.year.ago) }

          it 'sets the @contributions instance variable to empty' do
            show

            expect(assigns(:contributions)).to eq([])
          end
        end
      end

      context 'when there exists more than 5 contributions for the language' do
        let!(:contributions) { FactoryBot.create_list(:contribution, 6, language:) }

        it 'sets the @contributions instance variable to a latest 5 contributions' do
          show

          expect(assigns(:contributions).count).to eq(5)
        end
      end

      context 'when there are no contributions for the language' do
        it 'sets the @contributions instance variable to empty' do
          show

          expect(assigns(:contributions)).to eq([])
        end
      end
    end

    context 'when the language is invalid' do
      let(:language_params) { 'invalid' }

      it 'raises ActionController::RoutingError' do
        expect { show }.to raise_error(ActionController::RoutingError, 'invalid is not a valid language')
      end
    end
  end
end
