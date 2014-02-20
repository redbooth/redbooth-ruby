require "spec_helper"

describe Redbooth::Request::Info do
  describe "#url" do
    it "constructs the url" do
      info = Redbooth::Request::Info.new(:get, nil, "random", {id: 1} )

      info.url.should =~ /random/
    end
  end

  describe "#path_with_params" do
    it "does nothing when no params" do
      info = Redbooth::Request::Info.new(:get, nil, "random", nil)
      path = "/path/to/someplace"

      info.path_with_params(path, {}).should eq path
    end

    it "constructs the path with params" do
      info = Redbooth::Request::Info.new(:get, nil, "random", nil)
      path = "/path/to/someplace"

      info.path_with_params(path, {random: "stuff"}).should eq "#{path}?random=stuff"
    end
  end
end
