class Redirectotron
  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, response = @app.call(env)

    if status >= 400
      [301, headers.merge('Location' => '/'), 'Redirect']
    else
      [status, headers, response]
    end
  end
end
