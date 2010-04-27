require File.join(File.dirname(__FILE__), "./../spec_helper")


describe "Factory" do

  it "should have a name" do
    Factory.new("foo_factory").name.should == "foo_factory"
  end
  
  it "should have a default name of 'something here'" do
    Factory.new.name.should == "my_factory"
  end
  
  describe "ontology" do
    it "should have a master Instruction list" do
      Factory.new("foo").instruction_library.should == Instruction.all_instructions
    end
    
    it "should be possible to override the default with an option" do
      short_list = [IntAddInstruction, CodeNoopInstruction]
      Factory.new("foo", instruction_library:short_list).instruction_library.should ==
        short_list
    end
    
    it "should have a master NudgeType list" do
      Factory.new("foo").type_library.should == NudgeType.all_types
    end
    
    it "should be possible to override the default with an option" do
      short_list = [CodeType, BoolType]
      Factory.new("foo", type_library:short_list).type_library.should ==
        short_list
    end
    
    it "should save all the Hash options it was called with" do
      Factory.new("bar", my_option:1, my_other_option:[1,2,3]).original_options_hash.should ==
        {:my_option=>1, :my_other_option=>[1, 2, 3]}
    end
    
  end
  
  describe "workstations" do
    it "should have a list of extant workstation names" do
      Factory.new.workstation_names.should == []
    end
    
    describe "build_workstation" do
      it "should create a new workstation"
      it "should set up all the interior dynamics of the workstation"
      it "should use the master config for defaults of the new workstation"
      it "should suffice to create a pass-through workstation just to name it"
    end
  end
  
  describe "activate" do
    it "should have an #activate method"
  end
  
  describe "databases" do
    
    describe "#couch_available?" do
      it "should have a method to check that couchDB is accessible" do
        f1 = Factory.new("boo")
        lambda{f1.couch_available?}.should_not raise_error
      end
      
      it "should return true if the uri is reachable" do
        uri = "http://mycouch.db/boo"
        f1 = Factory.new("boo")
        f1.configatron.couchdb_uri = uri
        FakeWeb.register_uri(:any, uri, :body => "We are here!", :status => [200, "OK"])
        f1.couch_available?.should == true
      end
      
      it "should return false if the uri is offline or 404's out" do
        uri = "http://mycouch.db/boo"
        f1 = Factory.new("boo", couchdb_uri:uri)
        FakeWeb.register_uri(:any, uri, :body => "Go away!", :status => [404, "Not Found"])
        f1.couch_available?.should == false
        
        f1 = Factory.new("boo", couchdb_uri:"http://127.0.0.1:9991/place") # depends on this being wrong
        f1.couch_available?.should == false
      end
    end
  end
end