require 'spec_helper'

describe Lita::Handlers::Die, lita_handler: true do
  before do
    allow(robot).to receive(:shut_down)
  end

  context 'with an admin user' do
    before do
      allow(robot.auth).to receive(:user_is_admin?).with(user).and_return(true)
    end

    it 'restarts' do
      expect(robot).to receive(:shut_down)
      send_command('restart')
    end

    it 'sobs' do
      send_command('restart')
      expect(replies.last).to match(/as you wish/)
    end
  end

  context 'with a non-admin user' do
    it "doesn't restart" do
      expect(robot).not_to receive(:shut_down)
      send_command('restart')
    end

    it 'says nothing' do
      send_command('restart')
      expect(replies).to be_empty
    end
  end

  describe 'routes' do
    it { is_expected.to route_command('restart').with_authorization_for(:admins).to(:restart) }
    it { is_expected.not_to route_command('restart').with_authorization_for(:other) }
    it { is_expected.not_to route_command('restart') }
  end
end
