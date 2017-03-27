module DBHelper

  DB = Sequel.sqlite('treasure.db')

  def self.create_db_table
    DB.create_table(:map) do
      primary_key :id
      String :name
      Integer :pos_x
      Integer :pos_y
    end unless DB.table_exists? :map
    DB.create_table(:game) do
      primary_key :id
      String :name
      Integer :attempts, :default => 0
    end unless DB.table_exists? :game
  end

  def self.get_treasure
    DB[:map].where(:name => 'treasure')
  end

  def self.set_treasure(treasure_x, treasure_y)
    DB[:map].insert(:name => 'treasure', :pos_x => treasure_x, :pos_y => treasure_y)
  end

  def self.update_treasure(treasure_x, treasure_y)
    if get_treasure.first
      DB[:map].where(:name => 'treasure').update(:pos_x => treasure_x, :pos_y => treasure_y)
    else
      set_treasure(treasure_x, treasure_y)
    end
  end

  def self.reset_attempts
    if DB[:game].where(:name => 'number').first
      DB[:game].where(:name => 'number').update(:attempts => 0)
    else
      DB[:game].insert(:name => 'number')
    end
  end

  def self.get_attempts
    DB[:game].where(:name => 'number').first[:attempts]
  end

  def self.increment_attempts
    attempts = get_attempts + 1
    DB[:game].where(:name => 'number').update(:attempts => attempts)
  end
end