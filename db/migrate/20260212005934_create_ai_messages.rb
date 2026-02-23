class CreateAiMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :ai_messages do |t|
      t.references :ai_session, null: false, foreign_key: true
      t.integer :role, default: 0
      t.text :content
      t.jsonb :metadata, default: {}

      t.timestamps
    end
  end
end
