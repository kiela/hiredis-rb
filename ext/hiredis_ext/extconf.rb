require 'mkmf'

RbConfig::MAKEFILE_CONFIG['CC'] = ENV['CC'] if ENV['CC']

hiredis_dir = File.expand_path(File.join(File.dirname(__FILE__), %w{.. .. vendor hiredis}))
make_command = RUBY_PLATFORM.downcase =~ /bsd|solaris/ ? 'gmake' : 'make'

unless File.directory?(hiredis_dir)
  STDERR.puts "vendor/hiredis missing, please checkout its submodule..."
  exit 1
end

# Make sure hiredis is built...
system("cd #{hiredis_dir} && #{make_command} static")

# Statically link to hiredis (mkmf can't do this for us)
$CFLAGS << " -I#{hiredis_dir}"
$LDFLAGS << " #{hiredis_dir}/libhiredis.a"
create_makefile('hiredis/ext/hiredis_ext')
