module DBHelper

  DB = Sequel.sqlite('treasure.db')

  def self.create_db_table
    DB.create_table(:map) do
      primary_key :id
      String :name
      Integer :pos_x
      Integer :pos_y
    end unless DB.table_exists? :map
  end

  def self.get_treasure
    DB[:map].where(:name => 'treasure')
  end

  def self.set_treasure(treasure_x, treasure_y)
    DB[:map].insert(:name => 'treasure', :pos_x => treasure_x, :pos_y => treasure_y)
  end

  def self.update_treause(treasure_x, treasure_y)
    DB[:map].where(:name => 'treasure').update(:pos_x => treasure_x, :pos_y => treasure_y)
  end
end