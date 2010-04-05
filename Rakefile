require 'rake'
require 'rake/clean'
#require 'rake/testtask'
require 'rake/rdoctask'
require 'rake/gempackagetask'

task :default => [:build, :download, :spec]

CLEAN.add "ext/geoip.{o,bundle,so,obj,pdb,lib,def,exp}"
CLOBBER.add ['ext/Makefile', 'ext/mkmf.log', 'doc']
URL = "http://geolite.maxmind.com/download/geoip/database"

Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_files.add ['README', 'ext/geoip.c']
  rdoc.main = "README" # page to start on
  rdoc.rdoc_dir = 'doc/' # rdoc output folder
end

# Rake::TestTask.new do |t|
#   t.test_files = ['test.rb']
#   t.verbose = true
# end

spec = Gem::Specification.new do |s|
  s.name              = 'geoip-c'
  s.version           = "0.7.0"

  s.authors           = ['Ryah Dahl', 'Matt Todd', 'Charles Brian Quinn', 'Michael Sheakoski', 'Silvio Quadri']
  s.email             = 'mtodd@highgroove.com'

  s.summary           = "A Binding to the GeoIP C library"
  s.description       = 'Generic GeoIP lookup tool. Based on the geoip_city RubyGem by Ryah Dahl'
  s.homepage          = "http://github.com/mtodd/geoip"

  s.files             = ["Rakefile", "extconf.rb", "test.rb", "geoip.c", "README.md"]
  s.test_files        = 'test.rb'
  s.extensions        = 'extconf.rb'
  s.require_path      = '.'
end

Rake::GemPackageTask.new(spec) do |p|
  p.need_tar = true
  p.gem_spec = spec
end

desc "Build the Native extension"
task :build do
  cd 'ext' do
    ruby 'extconf.rb'
    system 'make'
  end
end

# desc 'compile the extension'
# task(:compile => 'Makefile') { sh 'make' }
# file('Makefile' => "geoip.c") { ruby 'extconf.rb' }

desc "Downloads and uncompress GeoLiteCity"
task :download do
  unless File.exists?("GeoLiteCity.dat")
    puts "Downloading geoip city..."
    `wget #{URL}/GeoLiteCity.dat.gz`
    `uncompress GeoLiteCity.dat.gz`
  end
end


task :install => [:gem] do
  `env ARCHFLAGS="-arch i386" gem install pkg/geoip-c-0.5.0.gem -- --with-geoip-dir=/usr/local/GeoIP`
end

task(:webpage) do
  sh 'scp -r doc/* rydahl@rubyforge.org:/var/www/gforge-projects/geoip-city/'
end
