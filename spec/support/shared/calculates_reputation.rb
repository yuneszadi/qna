RSpec.shared_examples_for "calculate reputation" do
  it 'should calculate reputation after create' do
    expect(CalculateReputationJob).to receive(:perform_later).with(subject)
    subject.save!
  end

  it 'should not calculate reputation after create' do
    subject.save!
    expect(CalculateReputationJob).to_not receive(:perform_later)
    subject.update(body: 'New title')
  end
end
