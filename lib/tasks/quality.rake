def qpath(filename)
  (Rails.root + 'quality' + filename).to_s
end

desc 'Run all quality metrics'
task quality: ['quality:rbp', 'quality:brakeman', 'quality:rubocop']

namespace :quality do

  task setup: :environment do
    FileUtils.mkdir_p(Rails.root + 'quality')
  end

  desc 'Run RuboCop'
  task rubocop: :setup do
    require 'rubocop'
    cli = RuboCop::CLI.new
    options = ['--rails',
               '--format', 'html', '--out', qpath('rubocop.html'),
               'app/', 'lib/', 'test/']
    cli.run(options)
    puts "RuboCop results in #{qpath('rubocop.html')}."
  end

  namespace :rubocop do
    desc 'Correct Rubocop errors'
    task :auto_correct do
      require 'rubocop'
      cli = RuboCop::CLI.new
      options = ['--rails', '--auto-correct',
                 'app/', 'lib/', 'test/']
      cli.run(options)
    end
  end

  desc 'Run Rails Best Practices'
  task rbp: :setup do
    require 'rails_best_practices'

    options = { 'format' => 'html',
                'with-git' => true,
                'output-file' => qpath('railsbp.html'),
                'silent' => true }
    if ENV['GITHUB_REPO']
      options['with-github'] = true
      options['github-name'] = ENV['GITHUB_REPO']
    end
    analyzer = RailsBestPractices::Analyzer.new(Rails.root.to_s, options)
    analyzer.analyze
    analyzer.output
    puts "Rails Best Practices results in #{qpath('railsbp.html')}."
  end

  desc 'Run Brakeman security scanner'
  task brakeman: :setup do
    require 'brakeman'
    options = { app_path: Rails.root.to_s,
                output_files: [qpath('brakeman.html')],
                format: 'html' }
    options[:github_repo] = ENV['GITHUB_REPO'] if ENV['GITHUB_REPO']

    Brakeman.run options
    puts "Brakeman results in #{qpath('brakeman.html')}."
  end
end
