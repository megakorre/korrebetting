class CreateSvspelMatches < ActiveRecord::Migration
  def self.up
    create_table :svspel_matches do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :svspel_matches
  end
end
