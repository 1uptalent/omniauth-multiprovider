require 'spec_helper'

describe OmniAuth::MultiProvider::Error do
  it 'is a runtime error' do
    expect { raise OmniAuth::MultiProvider::Error }.to raise_error RuntimeError
  end
end

describe OmniAuth::MultiProvider::AlreadyBoundError do
  let(:current_resource) { double('current_resource') }
  let(:bound_resource) { double("bound_resource") }

  it 'provides the current and bound resources' do
    error = OmniAuth::MultiProvider::AlreadyBoundError.new(current_resource, bound_resource)
    expect(error.bound_to).to be bound_resource
    expect(error.current).to be current_resource
  end

  describe '#message' do
    it 'is "bound_to_same" for the same current and bound resource' do
      error = OmniAuth::MultiProvider::AlreadyBoundError.new(current_resource, current_resource)
      expect(error.message).to eq 'bound_to_same'
    end

    it 'is "bound_to_other" for different current and bound resources' do
      error = OmniAuth::MultiProvider::AlreadyBoundError.new(current_resource, bound_resource)
      expect(error.message).to eq 'bound_to_other'
    end
  end
end
