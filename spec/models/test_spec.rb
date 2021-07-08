require 'test_helper'

RSpec.describe Test, type: :model do
  it { should validate_presence_of(:name) }
end
