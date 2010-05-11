require File.join(File.dirname(__FILE__), "./../spec_helper")

# CouchDB MUST BE RUNNING BEFORE YOU RUN THESE


describe "CouchDB stuff" do
  before(:each) do
    configatron.factory.couchdb.server = "http://127.0.0.1:5984"
    configatron.factory.couchdb.name = "integration_test_db"
    break("CouchDB is offline") unless Factory.couch_available?
    @db_uri = "#{configatron.factory.couchdb.server}/#{configatron.factory.couchdb.name}"
  end
  
  after(:all) do
    CouchRest.database!(@db_uri).delete!
  end
  
  describe "updating a Batch" do
    before(:each) do
      @batch = Batch.[](Answer.new("do a"), Answer.new("do b"))
    end
    
    describe "Batch#bulk_save!" do
      it "should capture the couch_id values in the Answers themselves" do
        old_ids = @batch.collect {|a| a.couch_id}
        @batch.bulk_save!(@db_uri)
        new_ids = @batch.collect {|a| a.couch_id}
        old_ids.should_not == new_ids
      end
      
      it "should capture the couch_rev values in the Answers themselves" do
        @batch.bulk_save!(@db_uri)
        new_revs = @batch.collect {|a| a.couch_rev}
        new_revs.each {|r| r.should_not == ""}
      end
    end
    
    
    it "should be possible to set the couchdb_id and have that be actually used" do
      @batch[0].couch_id = "001"
      @batch[1].couch_id = "002"
      ids = @batch.bulk_save!(@db_uri).collect {|r| r["id"]}
      ids.should == ["001", "002"]
    end
    
    it "should be possible to overwrite a document with new info" do
      @batch.bulk_save!(@db_uri)
      
      db = CouchRest.database!(@db_uri)
      as_saved = db.get(@batch[0].couch_id)["_rev"]
      @batch[0].scores[:wellness] = 0
      @batch.bulk_save!(@db_uri)
      and_now = db.get(@batch[0].couch_id)["_rev"]
      as_saved[0].should == "1"
      and_now[0].should == "2"
    end
    
  end
  
end