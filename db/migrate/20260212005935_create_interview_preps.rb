class CreateInterviewPreps < ActiveRecord::Migration[8.0]
  def change
    create_table :interview_preps do |t|
      t.references :user, null: false, foreign_key: true
      t.references :resume, null: false, foreign_key: true
      t.string :company_name
      t.text :job_posting
      t.text :company_info
      t.integer :interview_type
      t.integer :status

      t.timestamps
    end
  end
end
