class CreateResumes < ActiveRecord::Migration[8.0]
  def change
    create_table :resumes do |t|
      t.string :title
      t.text :personal_summary
      t.text :work_history
      t.text :skills
      t.text :self_promotion
      t.text :raw_content
      t.string :target_industry
      t.string :target_role
      t.integer :status, default: 0
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
