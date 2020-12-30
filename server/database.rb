require 'sequel'

DB = Sequel.connect('sqlite://controller.db')

unless DB.run('SELECT name FROM sqlite_master WHERE type=\'table\' AND name=\'sensors\';')
  DB.create_table :sensors do
    primary_key :id
    String :type, null: false
    Float :state, null: false, default: 0.0
  end
  %w[temperature humidity].each { |type| DB[:sensors].insert(type: type) }
end

unless DB.run('SELECT name FROM sqlite_master WHERE type=\'table\' AND name=\'lights\';')
  DB.create_table :lights do
    primary_key :id
    String :name, null: false
    String :state, null: false, default: 'off'
  end
  DB[:lights].insert(name: 'bedroom_light', state: 'off')
end

unless DB.run('SELECT name FROM sqlite_master WHERE type=\'table\' AND name=\'fans\';')
  DB.create_table :fans do
    primary_key :id
    String :name, null: false
    String :state, null: false, default: 'off'
    String :speed, null: false, default: 'low'
  end
  DB[:fans].insert(name: 'bedroom_fan')
end
