require 'test_helper'

RSpec.describe Question, type: :model do
  it { should validate_presence_of(:label) }
  it { should validate_presence_of(:question_content) }
end
