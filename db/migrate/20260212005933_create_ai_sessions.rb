class CreateAiSessions < ActiveRecord::Migration[8.0]
  def change
    create_table :ai_sessions do |t|
      t.references :user, null: false, foreign_key: true
      t.string :sessionable_type
      t.integer :sessionable_id
      t.integer :session_type, default: 0
      t.string :title
      t.text :system_prompt
      t.integer :status, default: 0

      t.timestamps
    end

    add_index :ai_sessions, [ :sessionable_type, :sessionable_id ]
  end
end
