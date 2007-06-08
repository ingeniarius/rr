dir = File.dirname(__FILE__)
require "#{dir}/../example_helper"

describe RR::Double, "#override", :shared => true do
  it "creates a new method" do
    override_with = proc {:baz}
    @double.override &override_with
    @object.send(@method_name).should == :baz
  end
  
  it "passes in arguments and block into proc" do
    arg1, arg2, block = nil, nil, nil
    override_with = proc {|arg1, arg2, block| arg1 = arg1; arg2 = arg2; block = block}

    @double.override &override_with
    @object.send(@method_name, 1, 2) {:passed_in_proc}

    arg1.should == 1
    arg2.should == 2
    block.call.should == :passed_in_proc
  end
end

describe RR::Double, "#override where method does not exist" do
  it_should_behave_like "RR::Double#override"

  before do
    @space = RR::Space.new
    @object = Object.new
    @method_name = :foobar
    @object.methods.should_not include(@method_name.to_s)
    @double = RR::Double.new(@space, @object, @method_name)
  end
end

describe RR::Double, "#override where method exists" do
  it_should_behave_like "RR::Double#override"

  before do
    @space = RR::Space.new
    @object = Object.new
    @method_name = :to_s
    @object.methods.should include(@method_name.to_s)
    @double = RR::Double.new(@space, @object, @method_name)
  end
end
