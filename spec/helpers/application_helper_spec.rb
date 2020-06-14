require "rails_helper"

RSpec.describe ApplicationHelper, type: :helper do
  describe "#full_title" do
    context "when not passing any page title" do
      it "should return default page title" do
        expect(full_title).to eq(t("page_title"))
      end
    end

    context "when passing page title" do
      it "should return page title with default page title" do
        title = "Home"
        expect(full_title(title)).to eq("#{title} | #{t("page_title")}")
      end
    end
  end

  describe "#flash_message_prefix" do
    context "when alert type is success" do
      it "should return success alert prefix" do
        expect(flash_message_prefix("success")).to eq(t("alert_prefix.success"))
      end
    end

    context "when alert type is info" do
      it "should return info alert prefix" do
        expect(flash_message_prefix("info")).to eq(t("alert_prefix.info"))
      end
    end

    context "when alert type is warning" do
      it "should return warning alert prefix" do
        expect(flash_message_prefix("warning")).to eq(t("alert_prefix.warning"))
      end
    end

    context "when alert type is danger" do
      it "should return danger alert prefix" do
        expect(flash_message_prefix("danger")).to eq(t("alert_prefix.danger"))
      end
    end

    context "when alert type is others" do
      it "should return empty alert prefix" do
        expect(flash_message_prefix("others")).to eq("")
      end
    end
  end

  describe "#message_type" do
    context "when message type is notice" do
      it "should return info as message type" do
        expect(message_type("notice")).to eq(t("message_type.notice"))
      end
    end

    context "when message type is alert" do
      it "should return danger as message type" do
        expect(message_type("alert")).to eq(t("message_type.alert"))
      end
    end

    context "when message type is other than notice and alert" do
      it "should return same message type" do
        expect(message_type("success")).to eq("success")
      end
    end
  end

  describe "#archive_status" do
    context "when record is archived" do
      it "should return archived badge" do
        expect(archive_status(true)).to eq('<span class="badge badge-danger" title="Archived">Archived</span>')
      end
    end

    context "when record is not archived" do
      it "should return active badge" do
        expect(archive_status(false)).to eq('<span class="badge badge-success" title="Active">Active</span>')
      end
    end
  end

  describe "#active_class" do
    let(:controller_name) { "brands" }

    context "when controller name is same as parameter" do
      it "should return active" do
        expect(active_class("brands")).to eq(t("active"))
      end
    end

    context "when controller name is not same as parameter" do
      it "should return blank string" do
        expect(active_class("home")).to eq("")
      end
    end
  end
end
