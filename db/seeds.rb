puts "Creating seed data..."

# Create demo user
user = User.find_or_create_by!(email: "demo@example.com") do |u|
  u.password = "password123"
  u.password_confirmation = "password123"
  u.display_name = "山田太郎"
  u.career_stage = :actively_looking
end
puts "Created user: #{user.email}"

# Create resumes
resume1 = user.resumes.find_or_create_by!(title: "Webエンジニア 職務経歴書") do |r|
  r.personal_summary = "Web系企業にてバックエンドエンジニアとして5年間の実務経験があります。Ruby on Railsを中心に、設計から実装、テスト、運用まで一貫して担当してきました。"
  r.work_history = "■ 株式会社テックカンパニー（2020年4月〜現在）\nバックエンドエンジニア\n- Ruby on Railsを用いたECサイトの開発・運用\n- APIの設計・実装（RESTful API）\n- パフォーマンス改善（レスポンスタイム30%改善）\n- チームリーダーとして3名のメンバーを指導\n\n■ 株式会社スタートアップ（2018年4月〜2020年3月）\nジュニアエンジニア\n- PHPを用いたWebアプリケーション開発\n- データベース設計・チューニング"
  r.skills = "Ruby, Ruby on Rails, PostgreSQL, Redis, Docker, AWS (EC2, RDS, S3), GitHub, CI/CD, RSpec"
  r.self_promotion = "チーム開発において、コードレビューを通じた品質向上とメンバー育成に注力してきました。また、パフォーマンス改善では、ボトルネックの特定から解決まで主体的に取り組み、ユーザー体験の向上に貢献しました。"
  r.target_industry = "IT・Web"
  r.target_role = "バックエンドエンジニア"
  r.status = :completed
end
puts "Created resume: #{resume1.title}"

resume2 = user.resumes.find_or_create_by!(title: "プロジェクトマネージャー 職務経歴書") do |r|
  r.personal_summary = "エンジニアとしてのバックグラウンドを活かし、プロジェクトマネジメントへのキャリアチェンジを志望しています。"
  r.target_industry = "IT・コンサルティング"
  r.target_role = "プロジェクトマネージャー"
  r.status = :draft
end
puts "Created resume: #{resume2.title}"

puts "Seed data created successfully!"
