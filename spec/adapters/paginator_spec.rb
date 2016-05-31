require_relative '../../app/adapters/paginator'

RSpec.describe Paginator do
  subject { Paginator.new([]) }

  it { is_expected.to respond_to :each }
  it { is_expected.to respond_to :page }
  it { is_expected.to respond_to :paginate }
  it { is_expected.to respond_to :pagination_info }

  describe '#page' do
    let(:relation) { double(page: nil) }
    let(:paginator) { Paginator.new(relation) }

    it 'returns a new paginator' do
      expect(paginator.page).to be_a Paginator
    end
  end

  describe '#paginate' do
    let(:view) { double(paginate: nil).as_null_object }
    let(:paginator) { subject }

    it 'initializes the view context' do
      expect(view).to receive(:extend).once
      paginator.paginate(view)
    end

    context 'with an already initialized view context' do
      before { paginator.paginate(view) }

      it 'does not reinitialize the view context' do
        expect(view).not_to receive(:extend)
        paginator.paginate(view)
      end
    end

    it 'paginates the relation' do
      relation = []
      paginator = Paginator.new(relation)

      expect(view).to receive(:paginate).with(relation)
      paginator.paginate(view)
    end
  end

  describe '#pagination_info' do
    let(:view) { double(page_entries_info: nil).as_null_object }
    let(:paginator) { subject }

    it 'handles view context initialization' do
      expect(paginator).to receive(:initialize_context).with(view)
      paginator.pagination_info(view)
    end

    it 'gets pagination info for the relation' do
      relation = []
      paginator = Paginator.new(relation)

      expect(view).to receive(:page_entries_info).with(relation)
      paginator.pagination_info(view)
    end
  end
end
