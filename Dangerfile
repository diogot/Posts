def warning_important_file_changed(file)
  warn "Modified #{file}" if git.modified_files.include?(file)
end

# Warn when there is a big PR
warn 'Big PR' if git.lines_of_code > 600

warning_important_file_changed '.gitignore'
warning_important_file_changed 'Gemfile'
warning_important_file_changed 'Gemfile.lock'
warning_important_file_changed 'Podfile'
warning_important_file_changed 'Podfile.lock'

fail 'Please add labels to this PR' if github.pr_labels.empty?

if github.pr_body.length < 5
  fail 'Please provide a summary in the Pull Request description'
end

# Xcode
build_file = File.expand_path 'result.json'
system "rake xcode:generate_summary[#{build_file}]"
xcode_summary.report build_file
