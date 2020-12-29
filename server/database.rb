require 'sequel'

DB = Sequel.connect('sqlite://controller.db')

unless DB.run('SELECT name FROM sqlite_master WHERE type=\'table\' AND name=\'sensors\';')
  DB.create_table :sensors do
    primary_key :id
    String :type, null: false
    Float :value, null: false, default: 0.0
  end
  %w[temperature humidity].each { |type| DB[:sensors].insert(type: type) }
end
