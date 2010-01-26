require File.dirname(__FILE__) + '/spec_helper'

class SubdomainTest
  include CustomerSubdomain::Helper

  public :current_customer
end

class TestModel
end

describe SubdomainTest do

  describe "current customer" do
    let(:subdomain) { SubdomainTest.new }

    before do
      subdomain.stub_chain(:request, :subdomains).and_return ["my", "application"]

      CustomerSubdomain.model_name = :test_model
      CustomerSubdomain.field_name = :test_field

      TestModel.stub! :find_by_test_field
    end

    it "should try to find the model with the matching field value of the class in use" do
      TestModel.should_receive :find_by_test_field
      subdomain.current_customer
    end

    [["sub"], ["sub1", "sub2"], ["www"]].each do |subs|
      it "should provide the first part ('#{subs.first}') of the subdomains ('#{subs}') to the find method" do
        subdomain.stub_chain(:request, :subdomains).and_return subs
        TestModel.should_receive(:find_by_test_field).with subs.first
        subdomain.current_customer
      end
    end

    it "should return nil if the customer was not found" do
      TestModel.stub!(:find_by_test_field).and_return nil
      subdomain.current_customer.should be_nil
    end

    it "should not raise an error if no subdomains are found" do
      subdomain.stub_chain(:request, :subdomains).and_return []
      lambda { subdomain.current_customer }.should_not raise_error
    end
  end
end
