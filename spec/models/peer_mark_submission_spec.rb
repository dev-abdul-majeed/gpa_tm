require 'rails_helper'

RSpec.describe PeerMarkSubmission, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:assignment) }
    it { is_expected.to belong_to(:giver).class_name('Student') }
  end

  describe 'validations' do
    subject { build(:peer_mark_submission) }

    it { is_expected.to validate_presence_of(:assignment) }
    it { is_expected.to validate_presence_of(:giver) }

    it do
      is_expected.to validate_inclusion_of(:submitted)
        .in_array([true, false])
    end
  end

  describe 'total score validation on submit' do
    let(:school)     { create(:school) }
    let(:teacher)     { create(:teacher, school: school) }
    let(:course)     { create(:course, teacher: teacher) }
    let(:assignment) { create(:assignment, course: course, assignment_type: assignment_type) }
    let(:group)      { create(:group, course: course) }
    let(:giver)      { create(:student, school: school) }
    let(:giver2)      { create(:student, school: school) }
    let(:group_membership)  { create(:group_membership, group: group, student: giver)}
    let(:group_membership1) { create(:group_membership, group: group,  student: giver2)}

    before do
      create(:group_membership, group: group, student: giver)
      create(:group_membership, group: group,  student: giver2)
    end

    subject do
      build(
        :peer_mark_submission,
        assignment: assignment,
        giver: giver,
        submitted: true
      )
    end

    context 'when assignment type is webavalia' do
      let(:assignment_type) { 'webavalia' }

      context 'and total peer marks != 100' do
        before do
          create(
            :peer_mark,
            assignment: assignment,
            group: group,
            giver: giver,
            receiver: giver2,
            score: 90
          )
        end

        it 'is invalid' do
          expect(subject).to be_invalid
          expect(subject.errors[:base])
            .to include('Total score must equal 100')
        end
      end

      context 'and total peer marks == 100' do
        before do
          create(
            :peer_mark,
            assignment: assignment,
            group: group,
            giver: giver,
            receiver: giver2,
            score: 100
          )
        end

        it 'is valid' do
          expect(subject).to be_valid
        end
      end
    end

    context 'when assignment type is qass' do
      let(:assignment_type) { 'qass' }

      before do
        create(
          :peer_mark,
          assignment: assignment,
          group: group,
          giver: giver,
          receiver: giver2,
          score: 40
        )
      end

      it 'skips total score validation' do
        expect(subject).to be_valid
      end
    end
  end

  describe 'cannot unsubmit once submitted' do
    let(:school)     { create(:school) }
    let(:teacher)     { create(:teacher, school: school) }
    let(:course)     { create(:course, teacher: teacher) }
    let(:assignment) { create(:assignment, course: course, assignment_type: 'qass') }
    let(:group)      { create(:group, course: course) }
    let(:giver)      { create(:student, school: school) }
    let(:giver2)      { create(:student, school: school) }
    let(:group_membership) { create(:group_membership, group: group, student: giver)}
    let(:group_membership1) { create(:group_membership, group: group, student: giver2)}
    let(:submission) { create(:peer_mark_submission, giver: giver, assignment: assignment, submitted: true) }

    it 'prevents changing submitted from true to false' do
      submission.submitted = false

      expect(submission).to be_invalid
      expect(submission.errors[:submitted])
        .to include('cannot be reverted once submitted')
    end
  end

  describe 'submitted_at timestamp' do
    let(:school)     { create(:school) }
    let(:teacher)     { create(:teacher, school: school) }
    let(:course)     { create(:course, teacher: teacher) }
    let(:assignment) { create(:assignment, course: course, assignment_type: 'qass') }
    let(:group)      { create(:group, course: course) }
    let(:giver)      { create(:student, school: school) }
    let(:giver2)      { create(:student, school: school) }
    let(:group_membership) { create(:group_membership, student: giver)}
    let(:group_membership1) { create(:group_membership, student: giver2)}
    let(:submission) do
      create(
        :peer_mark_submission,
        giver: giver,
        assignment: assignment,
        submitted: false,
        submitted_at: nil
      )
    end

    it 'sets submitted_at when submitted changes to true' do
      freeze_time do
        submission.update(submitted: true)

        expect(submission.submitted_at).to eq(Time.current)
      end
    end

    it 'does not override submitted_at if already set' do
      time = 2.days.ago
      submission.update_column(:submitted_at, time)

      submission.update(submitted: true)

      expect(submission.submitted_at).to eq(time)
    end
  end

  describe '#lock!' do
    let(:school)     { create(:school) }
    let(:teacher)     { create(:teacher, school: school) }
    let(:course)     { create(:course, teacher: teacher) }
    let(:assignment) { create(:assignment, course: course, assignment_type: 'qass') }
    let(:group)      { create(:group, course: course) }
    let(:giver)      { create(:student, school: school) }
    let(:giver2)      { create(:student, school: school) }
    let(:group_membership) { create(:group_membership, student: giver)}
    let(:group_membership1) { create(:group_membership, student: giver2)}
    let(:submission) { create(:peer_mark_submission, giver: giver, assignment: assignment, submitted: false) }

    it 'marks submission as submitted' do
      submission.lock!

      expect(submission.submitted).to be true
    end
  end
end
