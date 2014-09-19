namespace :test do
  task :prepare_for_coverage do
    ENV['COV'] = '1'
  end

  desc "Run tests and ensure coverage threshold is met"
  Rake::TestTask.new(:coverage => ['test:prepare_for_coverage', 'test:prepare']) do |t|
    t.libs << "test"
    t.pattern = 'test/**/*_test.rb'
  end
end
