namespace :teacher do
  desc 'TODO'
  task create_first_teacher: :environment do
    teacher = Teacher.create
    User.create(email: 'teacher@example.com', password: '12345678', authenticable: teacher, name: 'Cuong Nguyen')
  end
end
