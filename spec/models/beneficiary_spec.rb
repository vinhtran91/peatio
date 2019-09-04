# encoding: UTF-8
# frozen_string_literal: true

# TODO: AASM tests.
# TODO: Event API tests.

describe Beneficiary, 'Attributes' do
  context 'attr_readonly pin' do
    subject { create(:beneficiary, pin: 123_456) }

    it 'doesn\'t allow to update' do
      subject.update!(pin: 654_321)
      expect(subject.reload.pin).to eq(123_456)
    end
  end
end

describe Beneficiary, 'Relationships' do
  context 'beneficiary build by factory' do
    subject { build(:beneficiary) }
    it { expect(subject.valid?).to be_truthy }
  end

  context 'belongs to member' do
    context 'null member_id' do
      subject { build(:beneficiary, member: nil) }
      it { expect(subject.valid?).to be_falsey }
    end
  end

  context 'belongs to currency' do
    context 'null currency_id' do
      subject { build(:beneficiary, currency: nil) }
      it { expect(subject.valid?).to be_falsey }
    end
  end
end

describe Beneficiary, 'Validations' do
  context 'pin presence' do
    context 'nil pin' do
      subject { build(:beneficiary) }
      before { Beneficiary.expects(:generate_pin).returns(nil) }
      it { expect(subject.valid?).to be_falsey }
    end
  end

  context 'pin numericality only_integer' do
    context 'float pin' do
      subject { build(:beneficiary) }
      before { Beneficiary.expects(:generate_pin).returns(3.14) }
      it { expect(subject.valid?).to be_falsey }
    end
  end

  context 'state inclusion' do
    context 'wrong state' do
      subject { build(:beneficiary, state: :wrong) }
      it { expect(subject.valid?).to be_falsey }
    end
  end
end

describe Beneficiary, 'Callback' do
  context 'before_validation on create' do
    subject { build(:beneficiary) }
    it 'generates pin' do
      expect(subject.pin).to be_nil
      subject.validate!
      expect(subject.pin).to_not be_nil
      pin = subject.pin
      subject.validate!
      expect(subject.pin).to eq(pin)
    end
  end
end
