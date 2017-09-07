require "bundler/gem_tasks"

require 'rdoc/task' # ensure this file is also required in order to use `RDoc::Task`
RDoc::Task.new do |rdoc|
  rdoc.rdoc_dir = 'doc/rdoc'
  rdoc.generator = 'hanna'
  rdoc.main = 'README.md'
  rdoc.rdoc_files.include('README.md', 'LICENSE.txt', 'lib/')
end
