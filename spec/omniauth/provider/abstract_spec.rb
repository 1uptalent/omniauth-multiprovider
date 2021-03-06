require 'spec_helper'
require 'support/shared_examples_for_providers'

describe OmniAuth::Provider::Abstract do
  let(:controller) { double('a controller') }
  subject { described_class.new controller }

  it_behaves_like 'a provider'

  describe '#handle_request' do
    it 'raises since it is a template method' do
      expect{subject.handle_request double('controller')}.to raise_error "Should be defined by subclasses"
    end
  end
end
