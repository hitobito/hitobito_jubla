#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

require "spec_helper"

describe InvoiceAbility do
  subject { Ability.new(role.person.reload) }

  [
    Group::FederalBoard, Group::FederalProfessionalGroup, Group::FederalWorkGroup, Group::OrganizationBoard
  ].each do |group_type|
    context group_type do
      let!(:layer_group) { groups(:ch) }
      let!(:group) { group_type.create!(name: group_type.to_s, parent: layer_group) }
      let(:person) { people(:top_leader) }
      let!(:role) { Fabricate(group_type::Treasurer.sti_name, person: person, group: group) }
      let!(:invoice) { Invoice.new(group: layer_group) }
      let!(:article) { InvoiceArticle.new(group: layer_group) }
      let!(:reminder) { invoice.payment_reminders.build }
      let!(:payment) { invoice.payments.build }
      let!(:invoice_config) { InvoiceConfig.create!(group: layer_group, payee: "Strasse \n Ort \n Land oder so") }

      it "may index" do
        is_expected.to be_able_to(:index, Invoice)
      end

      it "may not index InvoiceItem" do
        is_expected.not_to be_able_to(:index, InvoiceItem)
      end

      it "may not manage" do
        is_expected.not_to be_able_to(:manage, Invoice)
        is_expected.not_to be_able_to(:manage, InvoiceItem)
      end

      %w[create edit show update destroy].each do |action|
        it "may #{action} invoices" do
          is_expected.to be_able_to(action.to_sym, invoice)
        end
      end

      %w[create edit show update destroy].each do |action|
        it "may #{action} invoice_item" do
          is_expected.to be_able_to(action.to_sym, invoice.invoice_items.build)
        end
      end

      %w[create edit show update destroy].each do |action|
        it "may #{action} articles" do
          is_expected.to be_able_to(action.to_sym, article)
        end
      end

      [:reminder, :payment].each do |obj|
        it "may create #{obj}" do
          is_expected.to be_able_to(:create, send(obj))
        end
      end

      %w[edit show update].each do |action|
        it "may #{action} invoice_config" do
          is_expected.to be_able_to(action.to_sym, invoice_config)
        end
      end
    end
  end
end
