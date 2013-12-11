require 'rubygems'
require 'rake'
require 'rake/testtask'
require 'rdoc/task'
require 'rake/contrib/sshpublisher'

require "./lib/syntax/version"

PACKAGE_NAME = "syntax"
PACKAGE_VERSION = Syntax::Version::STRING

SOURCE_FILES = FileList.new do |fl|
  [ "lib", "test" ].each do |dir|
    fl.include "#{dir}/**/*"
  end
  fl.include "Rakefile"
end

PACKAGE_FILES = FileList.new do |fl|
  [ "api", "doc" ].each do |dir|
    fl.include "#{dir}/**/*"
  end
  fl.include "CHANGELOG", "LICENSE", "#{PACKAGE_NAME}.gemspec"
  fl.include "README.rdoc", "setup.rb"
  fl.include SOURCE_FILES
end

#Gem::manage_gems

def can_require( file )
  begin
    require file
    return true
  rescue LoadError
    return false
  end
end

desc "Default task"
task :default => [ :test ]

desc "Build documentation"
task :doc => [ :rdoc, :manual ]

task :rdoc => SOURCE_FILES

desc "Clean generated files"
task :clean do
  rm_rf "coverage"
  rm_rf "pkg"
  rm_rf "api"
  rm_rf "doc/manual-html"
end

Rake::TestTask.new do |t|
  t.test_files = [ "test/ALL-TESTS.rb" ]
  t.verbose = true
end

package_name = "#{PACKAGE_NAME}-#{PACKAGE_VERSION}"
package_dir = "pkg"
package_dir_path = "#{package_dir}/#{package_name}"

gz_file = "#{package_name}.tar.gz"
bz2_file = "#{package_name}.tar.bz2"
zip_file = "#{package_name}.zip"
gem_file = "#{package_name}.gem"

task :gzip => SOURCE_FILES + [ :rdoc, :manual, "#{package_dir}/#{gz_file}" ]
task :bzip => SOURCE_FILES + [ :rdoc, :manual, "#{package_dir}/#{bz2_file}" ]
task :zip  => SOURCE_FILES + [ :rdoc, :manual, "#{package_dir}/#{zip_file}" ]
task :gem  => SOURCE_FILES + [ :manual, "#{package_dir}/#{gem_file}" ]

desc "Build all packages"
task :package => [ :test, :gzip, :bzip, :zip, :gem ]

directory package_dir

file package_dir_path do
  mkdir_p package_dir_path rescue nil
  PACKAGE_FILES.each do |fn|
    f = File.join( package_dir_path, fn )
    if File.directory?( fn )
      mkdir_p f unless File.exist?( f )
    else
      dir = File.dirname( f )
      mkdir_p dir unless File.exist?( dir )
      rm_f f
      safe_ln fn, f
    end
  end
end

file "#{package_dir}/#{zip_file}" => package_dir_path do
  rm_f "#{package_dir}/#{zip_file}"
  chdir package_dir do
    sh %{zip -r #{zip_file} #{package_name}}
  end
end

file "#{package_dir}/#{gz_file}" => package_dir_path do
  rm_f "#{package_dir}/#{gz_file}"
  chdir package_dir do
    sh %{tar czvf #{gz_file} #{package_name}}
  end
end

file "#{package_dir}/#{bz2_file}" => package_dir_path do
  rm_f "#{package_dir}/#{bz2_file}"
  chdir package_dir do
    sh %{tar cjvf #{bz2_file} #{package_name}}
  end
end

file "#{package_dir}/#{gem_file}" => package_dir do
  spec = eval(File.read(PACKAGE_NAME+".gemspec"))
  Gem::Builder.new(spec).build
  mv gem_file, "#{package_dir}/#{gem_file}"
end

rdoc_dir = "api"

desc "Build the RDoc API documentation"
Rake::RDocTask.new( :rdoc ) do |rdoc|
  rdoc.rdoc_dir = rdoc_dir
  rdoc.title    = "Syntax -- A library for syntax highlighting source code"
  rdoc.options << '--line-numbers --inline-source --main README.rdoc'
  rdoc.rdoc_files.include 'README.rdoc'
  rdoc.rdoc_files.include 'lib/**/*.rb'

  if can_require( "rdoc/generators/template/html/jamis" )
    rdoc.template = "jamis"
  end
end

desc "Generate the manual"
task :manual => [ "doc/manual-html/index.html" ]

file "doc/manual-html/index.html" => [ "doc/manual/manual.yml" ] do
  cd( "doc/manual" ) { ruby "manual.rb ../manual-html" }
end

desc "Publish the API documentation"
task :pubrdoc => [ :rdoc ] do
  Rake::SshDirPublisher.new(
    "minam@rubyforge.org",
    "/var/www/gforge-projects/net-ssh/api",
    "api" ).upload
end

desc "Publish the user's manual"
task :pubman => [ :manual ] do
  Rake::SshDirPublisher.new(
    "minam@rubyforge.org",
    "/var/www/gforge-projects/syntax",
    "doc/manual-html" ).upload
end

desc "Publish the documentation"
task :pubdoc => [:pubrdoc, :pubman]
