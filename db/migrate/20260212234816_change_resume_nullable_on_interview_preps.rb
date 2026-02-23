class ChangeResumeNullableOnInterviewPreps < ActiveRecord::Migration[8.0]
  def change
    change_column_null :interview_preps, :resume_id, true
  end
end
