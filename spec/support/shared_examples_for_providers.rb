
shared_examples "a provider" do
  context '#initialize' do
    it 'takes the controller as an argument' do
      controller = double('a controller')
      expect { described_class.new }.to raise_error ArgumentError
      expect { described_class.new controller }.not_to raise_error
    end

    it 'delegates to the controller' do
      controller = double('a controller')
      expect(controller).to receive :foo
      described_class.new(controller).foo
    end
  end
  context '#handle_request' do
    it 'is defined' do
      expect(subject).to respond_to :handle_request
    end

    it 'is overriden' do
      source_path = subject.method(:handle_request).source_location.first
      expect(source_path).to match %r{provider/}
      expect(source_path).not_to match %r{provider/abstract}
    end unless described_class == OmniAuth::Provider::Abstract
  end
end
