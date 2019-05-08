# TODO: Write documentation for `AutoCleaner`
require "file_utils"
module Auto
  class Cleaner
    VERSION = "0.7.3"
    
    @fl_on_exit_handled : Bool
    
    def initialize
      @clean_procs = [] of Proc(Nil)
      @fl_on_exit_handled = false
      @fs_objects = {files: [] of String, dirs: [] of String}
    end
		
    def add_proc(args : T, &block : T -> Int32) forall T
      @clean_procs.push(
        ->{
          block.call(args)
        })
      unless @fl_on_exit_handled
	      at_exit { make_mrproper }
	      @fl_on_exit_handled = true
	    end
    end

    {% for subst in ["file", "dir"] %}
      def add_{{subst.id}}(path : (Array(String)|String))
        if path.is_a?(Array(String))
          @fs_objects[:{{subst.id}}s].concat(path)
        else
          @fs_objects[:{{subst.id}}s].push(path)
        end
        unless @fl_on_exit_handled
          at_exit { make_mrproper }
          @fl_on_exit_handled = true
        end
      end
    {% end %}

    def make_mrproper
    	return if @clean_procs.empty? && @fs_objects[:files].empty? && @fs_objects[:dirs].empty?
      @clean_procs.each { |p| p.call }
      FileUtils.rm(   @fs_objects[:files].select { |f| File.exists?(f) } )
      FileUtils.rm_r( @fs_objects[:dirs].select  { |d| File.exists?(d) } )
      @clean_procs = [] of Proc(Nil)
      @fs_objects = {files: [] of String, dirs: [] of String}
    end    
  end
end
