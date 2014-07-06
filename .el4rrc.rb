@lisp_object_gc_trigger_count = 100
@lisp_object_gc_trigger_increment = 100
@ruby_gc_trigger_count = 100
@ruby_gc_trigger_increment = 100
@log_buffer = "*el4r:log*"
@output_buffer = "*el4r:output*"
@unittest_lisp_object_gc_trigger_count = 5000
@unittest_lisp_object_gc_trigger_increment = 5000
@unittest_ruby_gc_trigger_count = 5000
@unittest_ruby_gc_trigger_increment = 5000
@temp_file = "/var/folders/66/3h81t2y913vf344z6fb2cks00000gn/T/el4r-#{ENV['USER'] || ENV['USERNAME'] || 'me'}.tmp"

# New paths
el4r_gem = "/Users/andr6283/.rvm/gems/ruby-1.9.3-p448@xiki/gems/trogdoro-el4r-1.0.10"
# el4r_gem = "/Users/craig/.rvm/gems/ruby-1.9.3-p194/gems/trogdoro-el4r-1.0.7"
@stdlib_dir = "#{el4r_gem}/lib/el4r/emacsruby"
@autoload_dir = "#{el4r_gem}/lib/el4r/emacsruby/autoload"
@el_program = "#{el4r_gem}/data/emacs/site-lisp/el4r.el"
@instance_program = "#{el4r_gem}/bin/el4r-instance"

# $: << File.join(ENV['EL4R_ROOT'], "lib")
# This has the el4r dir
# Deleting this should be fine
# $: << "/Users/craig/.rvm/rubies/ruby-1.9.3-p194/lib/ruby/site_ruby/1.9.1"

### El4r bootstrap code
def __conf__
  if ENV['EL4R_ROOT']
    $: << File.join(ENV['EL4R_ROOT'], "lib")
  end
  require 'el4r/el4r-sub'
  ConfigScript.new(__FILE__)
end

def __elisp_init__
  $> << "(setq \n"
  instance_variables.map{|iv| [iv[1..-1], instance_variable_get(iv)]}.each {|k,v|  $> << "el4r-#{k.gsub(/_/,'-')} #{v.inspect}\n" if Numeric === v or String === v}
  $> << ')' << "
"
end

at_exit { __elisp_init__  if __FILE__==$0 }

### Customizable variables
### You can override these variables in User-setting area.
# directory containing EmacsRuby scripts
@home_dir = ENV['EL4R_HOME'] || File.expand_path("~/.el4r")
# startup EmacsRuby script
@init_script = "init.rb"
# EmacsRuby search path
@el4r_load_path = [ @home_dir, @site_dir, @stdlib_dir, "." ]
# End of the el4r block.
# User-setting area is below this line.

# Ruby interpreter name used by el4r

@ruby_program = "ruby"
# Probably rvm ENV vars will handle this
# @ruby_program = "/Users/craig/.rvm/rubies/ruby-1.9.3-p194/bin/ruby"
# @ruby_program = "/Users/craig/.rvm/rubies/ruby-1.9.3-p327/bin/ruby"

# Probably need to set this redundantly

# Emacs program name used by el4r / el4r-runtest.rb
@emacs_program = "emacs"
