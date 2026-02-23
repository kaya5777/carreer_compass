class CreateMockAnswers < ActiveRecord::Migration[8.0]
  def change
    create_table :mock_answers do |t|
      t.references :interview_question, null: false, foreign_key: true
      t.references :ai_session, null: false, foreign_key: true
      t.text :user_answer
      t.text :ai_feedback
      t.integer :score
      t.jsonb :evaluation_details, default: {}

      t.timestamps
    end
  end
end
