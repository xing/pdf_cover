require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "rubocop/rake_task"

ENV["RAILS_ENV"] ||= "test"

RSpec::Core::RakeTask.new(:spec)

RuboCop::RakeTask.new(:rubocop)

task :run_all_checks do
  Rake::Task["spec"].invoke
  Rake::Task["rubocop"].invoke
end

task default: :run_all_checks
