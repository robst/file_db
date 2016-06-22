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

    describe 'collection' do
      it { expect(User.all.map(&:name).join(',')).to eq('max,tester') }
      it { expect(User.last.name).to eq('tester') }
      it { expect(User.first.name).to eq('max') }
    end

    describe '#where' do
      context 'when no user found' do
        it { expect(User.where(name: 'not existing')).to eq([]) }
      end
      context 'when a valid user found, name of first user' do
        it { expect(User.where(name: 'max').first.name).to eq('max') }
      end
    end

    describe '#find' do
      context 'when no user found' do
        it { expect(User.find(1)).to eq(nil) }
      end
      context 'when a valid user found, name' do
        it { expect(User.find(1386757680).name).to eq('max') }
      end
    end
  end
end
