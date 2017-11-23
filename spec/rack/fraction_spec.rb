# frozen_string_literal: true

RSpec.describe Rack::Fraction do
  let(:app) { proc { |env| ['200', { 'Content-Type' => 'text/html' }, ['Test app', *env]] } }

  let(:test_env) { ['Hello!'] }

  let(:disabled) do
    Rack::Fraction.new(app, modify: nil) do |_|
    end
  end

  let(:change_env) do
    Rack::Fraction.new(app, modify: :env, percent: 100) do |env|
      env << '👋'
    end
  end

  let(:change_response) do
    Rack::Fraction.new(app, modify: :response, percent: 100) do |*response|
      response = response.dup
      response.last << 'Bonjour!'
      response
    end
  end

  context 'Isolated Middleware' do
    it 'instantiates Fraction' do
      expect(change_env).to be_a(Rack::Fraction)
    end

    it 'should modify env' do
      expect(change_env.call(test_env)).to eq(
        ['200', { 'Content-Type' => 'text/html' }, ['Test app', 'Hello!', '👋']]
      )
    end

    it 'should modify response' do
      expect(change_response.call(test_env)).to eq(
        ['200', { 'Content-Type' => 'text/html' }, ['Test app', 'Hello!', 'Bonjour!']]
      )
    end

    it 'should be disabled by default' do
      expect(disabled.call(test_env)).to eq(
        ['200', { 'Content-Type' => 'text/html' }, ['Test app', 'Hello!']]
      )
    end
  end
end
