require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "rubocop/rake_task"

RSpec::Core::RakeTask.new(:spec).tap do |rspec_task|
  rspec_task.rspec_opts = "--tag ~slow" unless ENV["RUN_SLOW_SPECS"]
end

RuboCop::RakeTask.new(:rubocop)

task :run_all_checks do
  Rake::Task["spec"].invoke
  Rake::Task["rubocop"].invoke
end

task default: :run_all_checks
