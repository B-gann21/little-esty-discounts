require 'rails_helper'

RSpec.describe BulkDiscount do
  context 'validations' do
    it { should validate_presence_of :quanity_threshold }
    it { should validate_numericality_of :quantity_threshold }

    it { should validate_presence_of :discount_percent }
    it { should validate_numericality_of :discount_percent }
  end

  context 'relationships' do
    it { should belong_to :merchant }
  end
end
