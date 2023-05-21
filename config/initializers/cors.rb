Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'http://localhost:4200' 
    
    resource '/real-estates',
      headers: :any,
      methods: [:get]
  
    resource '/real-estates/*',
      headers: :any,
      methods: [:get]

    resource '/real-estates/add',
      headers: :any,
      methods: [:post]

    resource '/real-estates/update/*',
      headers: :any,
      methods: [:put]

    resource '/real-estates/delete/*',
      headers: :any,
      methods: [:delete]

    resource '/real-estates/content/*',
      headers: :any,
      methods: [:get]

    resource '/real-estates/types',
      headers: :any,
      methods: [:get]
  end
end
