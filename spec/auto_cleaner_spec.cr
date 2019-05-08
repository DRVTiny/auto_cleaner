require "./spec_helper"
require "../src/auto_cleaner"
describe Auto::Cleaner do
	describe "auto cleaning on exit" do
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
    it "should automa(g|t)ically remove temporary file after exit" do
      File.exists?(tmp_f_path.not_nil!).should be_false
    end
  end
  
  describe "#make_mrproper" do
  	ac = Auto::Cleaner.new
  	count = 0
  	ac.add_proc(2) {|to_add| count += to_add }
  	ac.make_mrproper
  	it "should run user-defined proc as a result #make_mrproper method call" do
	  	count.should eq(2)
	  end
	  ac.make_mrproper
	  it "should NOT run user-defined cleaning proc twice (and should not do anything) if make_mrproper call followed by another call to the same method without any add_* methods invocations between this calls" do
	  	count.should eq(2)
	  end
	  ac.add_file(tmp_f_path = File.tempfile.path)
	  ac.make_mrproper
	  it "should remove temporary files added using add_file method after call to make_mrproper" do
	  	File.exists?(tmp_f_path.not_nil!).should be_false
	  end
  end
end
