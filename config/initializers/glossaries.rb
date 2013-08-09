require Rails.root.join('lib', 'glossary.rb')
Dir[Rails.root.join('db', 'glossaries', '*.rb')].each { |file| require file }
