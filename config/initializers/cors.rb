Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*' 

    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
    end

    # resource '/real-estates',
    #   headers: :any,
    #   methods: [:get, :options]
  
    # resource '/real-estates/*',
    #   headers: :any,
    #   methods: [:get, :options]

    # resource '/real-estates/add',
    #   headers: :any,
    #   methods: [:post, :options]

    # resource '/real-estates/update/*',
    #   headers: :any,
    #   methods: [:put, :options]

    # resource '/real-estates/delete/*',
    #   headers: :any,
    #   methods: [:delete, :options]

    # resource '/real-estates/content/*',
    #   headers: :any,
    #   methods: [:get, :options]

    # resource '/real-estates/types',
    #   headers: :any,
    #   methods: [:get, :options]

    # resource '/real-estates/types/add',
    #   headers: :any,
    #   methods: [:post, :options]

    # resource '/real-estates/types/update/*',
    #   headers: :any,
    #   methods: [:put, :options]

    # resource '/real-estates/types/delete/*',
    #   headers: :any,
    #   methods: [:delete, :options]
      
end
