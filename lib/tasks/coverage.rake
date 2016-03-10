namespace :test do

  task :coverage_on do |t|
    ENV['COV'] = '1'
  end

  desc "Run all tests"
  Rake::TestTask.new(:full => ['test:prepare']) do |t|
    t.libs << "test"
    t.test_files = FileList['test/**/*_test.rb']
  end

  desc "Run unit tests"
  Rake::TestTask.new(:unit => ['test:prepare']) do |t|
    t.libs << "test"
    t.test_files = FileList['test/unit/**/*_test.rb']
  end

  desc "Run functional tests"
  Rake::TestTask.new(:functional => ['test:prepare']) do |t|
    t.libs << "test"
    t.test_files = FileList['test/functional/**/*_test.rb']
  end

  desc "Run tests with coverage threshold"
  Rake::TestTask.new(:coverage => ['test:coverage_on']) do |t|
    t.libs << "test"
    t.test_files = FileList['test/**/*_test.rb']
  end
end
