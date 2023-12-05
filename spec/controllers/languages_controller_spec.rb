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
      end

      context 'when there are no active projects' do
        it 'sets the @projects instance variable to empty' do
          show

          expect(assigns(:projects)).to eq([])
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
