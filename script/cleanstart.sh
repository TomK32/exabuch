rake db:migrate VERSION=0
rake db:migrate
rake db:fixtures:load
rake log:clear
rake tmp:clear
rake tmp:cache:clear
./script/server

