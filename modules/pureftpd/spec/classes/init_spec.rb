require 'spec_helper'
describe 'pureftpd' do

  context 'with defaults for all parameters' do
    it { should contain_class('pureftpd') }
  end
end
