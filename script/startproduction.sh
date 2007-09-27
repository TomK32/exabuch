rake db:migrate RAILS_ENV="production"
rake log:clear
rake tmp:clear
rake tmp:cache:clear
./script/server -e production

