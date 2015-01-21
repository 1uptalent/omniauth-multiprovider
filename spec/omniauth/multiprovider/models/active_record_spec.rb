require 'spec_helper'

describe OmniAuth::MultiProvider::ActiveRecord do
  before do
    ActiveRecord::Base.connection.create_table :cs, temporary: true
  end
  after do
    ActiveRecord::Base.connection.drop_table :cs
  end
  let!(:klass) do
    class C < ActiveRecord::Base
      omniauthenticable
    end
  end

  it 'can create instances' do
    klass.new
  end


end
