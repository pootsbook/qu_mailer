require 'spec_helper'

class FakeQu
  def self.enqueue(*args); end
end

class Rails3Mailer < ActionMailer::Base
  include Qu::Mailer
  default :from => 'sender@example.org', :subject => 'Subject'
  MAIL_PARAMS = { :to => 'recipient@example.org' }

  def test_mail(*params)
    Qu::Mailer.success!
    mail(*params)
  end
end

describe Qu::Mailer do
  let(:qu) { FakeQu }
  
  before do
    Qu::Mailer.default_queue_target = qu
    Qu::Mailer.stub(:success!)
    Rails3Mailer.stub(:current_env => :test)
  end

  describe "qu" do
    it "allows overriding of the default queue target (for testing)" do
      Qu::Mailer.default_queue_target = FakeQu
      Rails3Mailer.qu.should == FakeQu
    end
  end

  describe "queue" do
    it "defaults to the 'mailer' queue" do
      Rails3Mailer.queue.should == "mailer"
    end

    it "allows overriding of the default queue name" do
      Qu::Mailer.default_queue_name = "postal"
      Rails3Mailer.queue.should == "postal"
    end

    describe "#deliver" do
      before(:all) do
        @delivery = -> {
          Rails3Mailer.test_mail(Rails3Mailer::MAIL_PARAMS).deliver
        }
      end

      it "delivers the email synchronously" do
        -> { @delivery.call }.should_not change(ActionMailer::Base.deliveries, :size)
      end

      it "places the deliver action on the Qu 'mailer' queue" do
        qu.should_receive(:enqueue).with(Rails3Mailer, :test_mail, Rails3Mailer::MAIL_PARAMS)
        @delivery.call
      end

      it "does not invoke the method body more than once" do
        Qu::Mailer.should_not_receive(:success!)
        Rails3Mailer.test_mail(Rails3Mailer::MAIL_PARAMS).deliver
      end

      context "when current environment is excluded" do
        it "does not deliver through Qu for excluded environments" do
          Qu::Mailer.stub(:excluded_environments => [:custom])
          Rails3Mailer.should_receive(:current_env).and_return(:custom)
          qu.should_not_receive(:enqueue)
          @delivery.call
        end
      end
    end
  end

  describe "#deliver!" do
    it "delivers the email synchronously" do
      -> { 
        Rails3Mailer.test_mail(Rails3Mailer::MAIL_PARAMS).deliver! 
      }.should change(ActionMailer::Base.deliveries, :size).by(1)
    end
  end

  describe "perform" do
    it "performs a queued mailer job" do
      -> { 
        Rails3Mailer.perform(:test_mail, Rails3Mailer::MAIL_PARAMS)
      }.should change(ActionMailer::Base.deliveries, :size).by(1)
    end
  end

  describe "original mail methods" do
    it "is preserved" do
      Rails3Mailer.test_mail(Rails3Mailer::MAIL_PARAMS).subject.should == 'Subject'
      Rails3Mailer.test_mail(Rails3Mailer::MAIL_PARAMS).from.should include('sender@example.org') 
      Rails3Mailer.test_mail(Rails3Mailer::MAIL_PARAMS).to.should include('recipient@example.org')
    end

    it "requires execution of the method body prior to queuing" do
      Qu::Mailer.should_receive(:success!).once
      Rails3Mailer.test_mail(Rails3Mailer::MAIL_PARAMS).subject
    end
  end
end
