require 'spec_helper'

describe Invitation do
  describe "#create" do
    it "generates a code automatically" do
      i = Invitation.new
      i.code.should_not be_nil
      i.code.length.should == 6
    end
    
  end
  
  describe "#use" do
    it "reduces usages left by one" do
      i = Factory(:invitation)
      i.usages_left.should == 1
      i.save!
      Invitation.find(i.id).usages_left.should == 1
      i.should be_usable
      #i.use_once!
      i.update_attribute(:usages_left, i.usages_left - 1)
      i.usages_left.should == 0
      i.save!
      Invitation.find(i.id).usages_left.should == 0
      i.should_not be_usable
      i.usages_left = 3
      i.use_once!
      i.usages_left.should == 2
      i.should be_usable
      
    end
  end
end
