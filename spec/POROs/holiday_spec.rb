require 'rails_helper'

RSpec.describe Holiday do
  it 'can be initialized with a hash' do
    holiday = Holiday.new({localName: 'Christmas', date: '2022-12-25'})

    expect(holiday.name).to eq('Christmas')
    expect(holiday.date).to eq('2022-12-25')
  end
end
