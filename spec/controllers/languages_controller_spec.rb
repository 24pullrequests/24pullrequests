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
    end

    context 'when the language is invalid' do
      let(:language_params) { 'invalid' }

      it 'raises ActionController::RoutingError' do
        expect { show }.to raise_error(ActionController::RoutingError, 'invalid is not a valid language')
      end
    end
  end
end
