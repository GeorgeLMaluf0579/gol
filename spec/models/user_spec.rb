require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    context "with valid attributes" do
      let(:user) { build(:user) }

      it "is valid" do
        expect(user).to be_valid
      end
    end

    describe "with invalid attributes" do
      context "with invalid email"  do
        let(:invalid_user) { build(:user, email: 'abdc.com') }
        it "is invalid" do
          expect(invalid_user).not_to be_valid
        end
      end

      context "with invalid password" do
        let(:invalid_user) { build(:user, password: '12345', password_confirmation: '12345') }
        it "is invalid" do
          expect(invalid_user).not_to be_valid
        end
      end

      context "with invalid confirmation_password" do
        let(:invalid_user) { build(:user, password_confirmation: '123abcd') }
        it "is invalid" do
          expect(invalid_user).not_to be_valid
        end
      end
    end
  end
end
