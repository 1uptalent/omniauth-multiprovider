require 'spec_helper'

describe OmniAuth::MultiProvider::Error do
  it 'is a runtime error' do
    begin
      rescued = false
      raise OmniAuth::MultiProvider::Error
    rescue RuntimeError
      rescued = true
    end
    rescued.should be true
  end
end
