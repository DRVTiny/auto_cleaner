require "./spec_helper"
require "../src/auto_cleaner"
describe Auto::Cleaner do
  in_p, out_p = IO.pipe
  child_p = Process.fork do
  	ac = Auto::Cleaner.new
  	tmp_f = File.tempfile("ac-test", ".tst")
  	ac.add_file tmp_f.path
  	tmp_f.puts "Auto::Cleaner glad to test itself again!"
  	tmp_f.close
  	out_p.puts tmp_f.path
  	exit 0  	
  end
  child_p.wait
  tmp_f_path = in_p.gets
  tmp_f_path.class.should eq(String)
  if tmp_f_path
  	STDERR.puts "temp file path: #{tmp_f_path}"
	  File.exists?(tmp_f_path).should eq(false)
	end
end
