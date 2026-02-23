class CreateInterviewQuestions < ActiveRecord::Migration[8.0]
  def change
    create_table :interview_questions do |t|
      t.references :interview_prep, null: false, foreign_key: true
      t.text :question_text
      t.text :suggested_answer
      t.integer :category
      t.integer :difficulty

      t.timestamps
    end
  end
end
