require 'rails_helper'

RSpec.describe PeerMark, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:assignment) }
    it { is_expected.to belong_to(:group) }
    it { is_expected.to belong_to(:giver).class_name('Student') }
    it { is_expected.to belong_to(:receiver).class_name('Student') }
  end

  describe 'validations' do
    subject { build(:peer_mark) }

    it { is_expected.to validate_presence_of(:assignment) }
    it { is_expected.to validate_presence_of(:group) }
    it { is_expected.to validate_presence_of(:giver) }
    it { is_expected.to validate_presence_of(:receiver) }
    it { is_expected.to validate_presence_of(:score) }

    it do
      is_expected.to validate_numericality_of(:score)
        .is_greater_than_or_equal_to(0)
        .is_less_than_or_equal_to(100)
    end

    # it do
    #   is_expected.to validate_uniqueness_of(:receiver_id)
    #     .scoped_to(:assignment_id, :giver_id)
    # end
  end

  describe 'custom validations' do
    let(:school)   { create(:school) }
    let(:teacher)   { create(:teacher, school: school) }
    let(:course)     { create(:course, teacher: teacher) }
    let(:assignment) { create(:assignment, course: course) }
    let(:group)      { create(:group, course: course) }
    let(:giver)      { create(:student, school: school) }
    let(:receiver)   { create(:student, school: school) }

    before do
      group.students << giver
      group.students << receiver
    end

    context 'when group course does not match assignment course' do
      let(:other_course) { create(:course, teacher: teacher) }
      let(:wrong_group)  { create(:group, course: other_course) }

      it 'is invalid' do
        peer_mark = build(
          :peer_mark,
          assignment: assignment,
          group: wrong_group,
          giver: giver,
          receiver: receiver
        )

        expect(peer_mark).to be_invalid
        expect(peer_mark.errors[:group])
          .to include('must belong to the same course as the assignment')
      end
    end

    context 'when giver or receiver is not in the group' do
      let(:outsider) { create(:student, school: school) }

      it 'is invalid if giver is not in group' do
        peer_mark = build(
          :peer_mark,
          assignment: assignment,
          group: group,
          giver: outsider,
          receiver: receiver
        )

        expect(peer_mark).to be_invalid
        expect(peer_mark.errors[:base])
          .to include('Giver and receiver must both be members of the group')
      end

      it 'is invalid if receiver is not in group' do
        peer_mark = build(
          :peer_mark,
          assignment: assignment,
          group: group,
          giver: giver,
          receiver: outsider
        )

        expect(peer_mark).to be_invalid
        expect(peer_mark.errors[:base])
          .to include('Giver and receiver must both be members of the group')
      end
    end
  end

  describe 'locked after submission' do
    let(:school)   { create(:school) }
    let(:teacher)   { create(:teacher, school: school) }
    let(:course)     { create(:course, teacher: teacher) }
    let(:assignment) { create(:assignment, course: course) }
    let(:group)      { create(:group, course: course) }
    let(:giver)      { create(:student, school: school) }
    let(:receiver)   { create(:student, school: school) }

    before do
      group.students << giver
      group.students << receiver
    end

    let!(:peer_mark) do
      create(
        :peer_mark,
        assignment: assignment,
        group: group,
        giver: giver,
        receiver: receiver,
        score: 70
      )
    end

    context 'when submission is submitted' do
      before do
        create(
          :peer_mark_submission,
          assignment: assignment,
          giver: giver,
          submitted: true
        )
      end

      it 'prevents score update' do
        peer_mark.score = 80
        expect(peer_mark).to be_invalid
        expect(peer_mark.errors[:base])
          .to include('Peer marks are locked after submission')
      end

      it 'prevents receiver change' do
        new_receiver = create(:student, school: school)
        group.students << new_receiver

        peer_mark.receiver = new_receiver
        expect(peer_mark).to be_invalid
        expect(peer_mark.errors[:base])
          .to include('Peer marks are locked after submission')
      end
    end

    context 'when submission is not submitted' do
      before do
        create(
          :peer_mark_submission,
          assignment: assignment,
          giver: giver,
          submitted: false
        )
      end

      it 'allows updates' do
        peer_mark.score = 90
        expect(peer_mark).to be_valid
      end
    end
  end
end
