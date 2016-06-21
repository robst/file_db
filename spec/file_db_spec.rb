require 'spec_helper'

describe FileDb do
  it 'has a version number' do
    expect(FileDb::VERSION).not_to be nil
  end

  describe 'classes acting as FileDb::Model' do
     
    let(:user) { User.new name: 'Tester' }
    it 'should have accessors' do
      expect(user.respond_to?(:name)).to be_truthy
      expect(user.respond_to?(:name=)).to be_truthy
      expect(user.respond_to?(:test)).to be_truthy
      expect(user.respond_to?(:test=)).to be_truthy
    end

    it 'should return user as table_name' do
      expect(User.table_name).to eq('user')
    end

    it 'set params hash to accessors' do
      expect(user.name).to eq('Tester')
    end

    describe '#where' do
      context 'no user found' do
#        it { expect(User.where(name: 'not existing')).to eq([]) }
      end
    end
  end
end
