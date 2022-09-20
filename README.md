API desenvolvida com Ruby 3.1.2, Sinatra e MongoDB

- Para executar usando docker
  
  `docker-compose up --build`
  
- Para executar o pry

  `docker-compose run app bundle exec pry -I . -r application.rb`
  
- Para executar os testes

  `docker-compose run app rspec spec/`
  
