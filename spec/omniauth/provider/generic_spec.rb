require 'spec_helper'
require 'support/shared_examples_for_providers'

describe OmniAuth::Provider::Generic do
  let(:controller) { double('a controller') }
  subject { described_class.new controller }

  it_behaves_like 'a provider'

  describe '#handle_request' do
  end

end
