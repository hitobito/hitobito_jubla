
require 'spec_helper'

describe Subscriber::GroupController do

  let(:group) { groups(:be) }
  let(:list) {  MailingList.create!(group: group, name: 'be') }

  subject { response.body }

  before do
    Group::StateAgency::Leader.create!(group: groups(:be_agency), person: people(:top_leader))
    sign_in(people(:top_leader))
    get :query, q: 'Nor', group_id: group.id, mailing_list_id: list.id
  end

  context 'GET query' do

    it 'does  include sister group or their descendants' do
      should =~ /Nordostschweiz/
      should =~ /Nordostschweiz \\u0026gt; AST/
      should =~ /Nordostschweiz \\u0026gt; Kalei/
    end

  end
end
