require "rails_helper"
require 'logger'

describe FetchImagesService do
  let!(:subject){FetchImagesService.new}
  let!(:logger){subject.logger}

  before do
    allow(logger).to receive(:info)
    allow(logger).to receive(:error)
  end

  describe "#process_file" do

    context "if no path_to_file provided" do
      it "returns false and logs error" do
        expect(subject.process_file(nil)).to eq false
        expect(logger).to have_received(:error).with("Please provide a file path.").once
      end
    end

    context "if path_to_file can not be found" do
      let(:path_to_file){"not_found_path"}
      it "returns false and logs error" do
        expect(subject.process_file(path_to_file)).to eq false
        expect(logger).to have_received(:error).with("File not found: not_found_path").once
      end
    end  

    context "if path_to_file can be found" do
      let(:path_to_file){"spec/fixtures/files/valid_images.txt"}

      let(:vcr_cassette) { 'valid_images' }

      around do |example|
        VCR.use_cassette(vcr_cassette, match_requests_on: [:method, :host, :path]) do
          example.run
        end       
      end
           
      it "returns true and logs info" do
        expect(subject.process_file(path_to_file)).to eq true
        expect(logger).to have_received(:info).with("2 Files downloaded to: /Users/simonmeyborg/Documents/syborgstudios/projects/getsavechallange/images_store/").once
      end
    end 
  end

  describe "#download_image" do

    context "when url_to_image is redirecting" do
      let(:url_to_image){"http://mywebserver.com/images/271946.jpg"}
      let(:vcr_cassette) { 'redirecting_image' }

      around do |example|
        VCR.use_cassette(vcr_cassette, match_requests_on: [:method, :host, :path]) do
          example.run
        end
      end
           
      it "returns false and logs error" do
        expect(subject.download_image(url_to_image)).to eq false
        expect(logger).to have_received(:error).with("File not available: http://mywebserver.com/images/271946.jpg, Redirected to: https://goldnames.com/view/219").once
      end      
    end

    context "when url_to_image is not available" do
      let(:url_to_image){"http://somewebsrv.com/img/992147.jpg"}
      let(:vcr_cassette) { 'not_available_image' }

      around do |example|
        VCR.use_cassette(vcr_cassette, match_requests_on: [:method, :host, :path]) do
          example.run
        end
      end

      it "returns false and logs error" do
        expect(subject.download_image(url_to_image)).to eq false
        expect(logger).to have_received(:error).with("File not available: http://somewebsrv.com/img/992147.jpg").once
      end
    end 

    context "when url_to_image is available" do
      let(:url_to_image){"https://cdn.sanity.io/images/p4gom3ch/production/9bc0243f82b366630955d19990c0dcc0e5028275-960x560.png"}
      let(:vcr_cassette) { 'available_image' }

      around do |example|
        VCR.use_cassette(vcr_cassette, match_requests_on: [:method, :host, :path]) do
          example.run
        end
      end

      it "returns false and logs error" do
        expect(subject.download_image(url_to_image)).to eq true
        expect(logger).to have_received(:info).with("File downloaded: https://cdn.sanity.io/images/p4gom3ch/production/9bc0243f82b366630955d19990c0dcc0e5028275-960x560.png").once
      end
    end        
  end
end
