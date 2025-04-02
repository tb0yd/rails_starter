class UpdateActivityLogActionsToSymbols < ActiveRecord::Migration[7.1]
  def up
    # Map old abbreviated strings to new symbol values
    mapping = {
      'crt' => 'created',
      'upd' => 'updated',
      'del' => 'deleted',
      'viw' => 'viewed',
      'exp' => 'exported'
    }

    mapping.each do |old_value, new_value|
      execute <<-SQL
        UPDATE activity_logs 
        SET action = '#{new_value}' 
        WHERE action = '#{old_value}'
      SQL
    end
  end

  def down
    # Map new symbol values back to old abbreviated strings
    mapping = {
      'created' => 'crt',
      'updated' => 'upd',
      'deleted' => 'del',
      'viewed' => 'viw',
      'exported' => 'exp'
    }

    mapping.each do |new_value, old_value|
      execute <<-SQL
        UPDATE activity_logs 
        SET action = '#{old_value}' 
        WHERE action = '#{new_value}'
      SQL
    end
  end
end
