shared_examples "API Authenticable" do
  context "unauthorized" do
    it "return 401 if there not have access_token" do
      do_request
      expect(response.status).to eq 401
    end

    it "return 401 if access_token invalid" do
      do_request(access_token: "123456")
      expect(response.status).to eq 401
    end
  end
end
