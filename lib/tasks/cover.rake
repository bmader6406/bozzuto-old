require 'vendor/plugins/cover/init'

# Basic task to enable checking for code coverage
Cover::Task.new('db:migrate') do |t|
  t.threshold = 90
  t.exclude << ['.gem',
    '.bundle',
    'vendor',
    'lib/typus',
    'app/controllers/admin',
    'app/helpers/admin_helper',
    'app/models/asset',
    'app/models/picture'
  ]
end

namespace :test do
  Rcov::RcovTask.new(:rcov => ["db:test:prepare"]) do |t|
    t.libs << 'test'
    t.test_files = FileList['test/functional/**/*_test.rb'] + FileList['test/unit/**/*_test.rb']
    t.rcov_opts = %w[--sort coverage -T --only-uncovered --rails]
    ['.gem', '.rvm', '/System/Library/', '/Library/Ruby/', '.bundle', 'vendor',
      'lib/typus', 'app/controllers/admin', 'app/helpers/admin_helper', 'app/models/asset',
      'app/models/picture'
    ].each do |exclude_dir|
      t.rcov_opts << "-x '#{exclude_dir}'"
    end
  end

  desc "Generate code Coverage with rcov and open report"
  task :coverage => "test:rcov" do
    system "open coverage/index.html" if PLATFORM['darwin']
  end
end

# If you need to configure the task further, you can:
#
# * Add task dependencies to the constructor that get run each time
# * Enable verbosity
# * Change the enforcement threshold
# 
#   Cover::Task.new('db:migrate:reset', 'db:seed') do |t|
#     t.verbose = false
#     t.threshold = 100
#     t.exclude << ['some/path', 'another/path']
#   end
#
# See the README file for more information
#
