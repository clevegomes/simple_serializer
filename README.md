# README


* Ruby version 
  * Rails 7.0.3


* System dependencies
  * Ruby 3.0.3
  * rvm 1.29.12
  

* Configuration
  * Installed using rvm 
  * create file "ruby-3.0.3" > .ruby-version
  

* Database creation
  * No Database
  

* Database initialization
  * No Database
  

* How to run the test suite
  * rspec
  

* Note
  * The project is build using rvm with ruby 3.0.3 and rails 7.0.3
  * I have build a custom serializer that will fetch all the specified fields in the object, transform them into the desired format if specified and return it in json format
  * All Models are in the models directory and serializers are in the serializers directory
  * class Api::V1::SimpleSerializer is the main class and every method is documented
  * Spec are in the spec directory
  * the Models and Spec file have been modified a little to match with my simple serializer
  * The Spec have been tested from my end and everything is green
  