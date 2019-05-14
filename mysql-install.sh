brew tap homebrew/services
brew install mysql@5.7
brew services start mysql@5.7
brew services list
brew link mysql@5.7 --force
mysql -V
mysqladmin -u root password 'password'