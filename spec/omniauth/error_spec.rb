require 'spec_helper'

describe OmniAuth::MultiProvider::Error do
  it 'is a runtime error' do
    expect { raise OmniAuth::MultiProvider::Error }.to raise_error RuntimeError
  end
end

describe OmniAuth::MultiProvider::AlreadyBoundError do
  it 'provides the bound resource' do
    resource = double("resource")
    error = OmniAuth::MultiProvider::AlreadyBoundError.new(resource)
    expect(error.bound_to).to be resource
  end
end
