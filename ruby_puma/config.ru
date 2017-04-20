# frozen_string_literal: true

# ping-pong
class App
  def call(_env)
    [200, { 'content-type' => 'text/plain' }, ['pong']]
  end
end

run App.new
