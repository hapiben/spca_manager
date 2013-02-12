require "spec_helper"

describe ParserVersionsController do

  let(:parser) { mock_model(Parser).as_null_object }
  let(:version) { mock_model(ParserVersion).as_null_object }

  before(:each) do
    controller.stub(:authenticate_user!) { true }
    Parser.stub(:find).with("1") { parser }
    parser.stub(:find_version) { version }
  end
  
  describe "GET Show" do
    it "finds the parser" do
      Parser.should_receive(:find).with("1") { parser }
      get :show, id: 1, parser_id: 1
      assigns(:parser).should eq parser
    end

    it "finds the version" do
      parser.should_receive(:find_version).with("1") { version }
      get :show, id: 1, parser_id: 1
      assigns(:version).should eq version
    end
  end

  describe "PUT update" do
    it "updates the version" do
      version.should_receive(:update_attributes).with({"tags" => ["staging"]})
      put :update, id: 1, parser_id: 1, version: {tags: ["staging"]}
    end

    it "redirects to the version path" do
      put :update, id: 1, parser_id: 1, version: {tags: ["staging"]}
      response.should redirect_to parser_parser_version_path(parser, version)
    end
  end
end