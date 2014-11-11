require "spec_helper"

describe RedboothRuby::Request::Collection, vcr: 'collection' do
  include_context 'authentication'
  let(:collection) { client.task(:index, per_page: 2) }

  describe "#initialize" do
    subject { collection }

    it { should be_a RedboothRuby::Request::Collection }
    it { expect(subject.response).to be_a(RedboothRuby::Request::Response) }
    it { expect(subject.params).to be_a(Hash) }
    it { expect(subject.method).to eql(:index) }
    it { expect(subject.session).to eql(client.session) }
    it { expect(subject.resource).to eql(RedboothRuby::Task) }
  end

  describe '#all' do
    subject { collection.all }

    it { should be_a Array }
    it { expect(subject.first).to be_a(RedboothRuby::Task) }
  end

  describe '#total_pages' do
    subject { collection.total_pages }

    it { should be_a Integer }

    context 'where endpoint is not paginated' do
      before { collection.response.headers.delete('PaginationTotalPages') }

      it { should be_nil }
    end
  end

  describe '#per_page' do
    subject { collection.per_page }

    it { should be_a Integer }

    context 'where endpoint is not paginated' do
      before { collection.response.headers.delete('PaginationPerPage') }

      it { should be_nil }
    end
  end

  describe '#current_page' do
    subject { collection.current_page }

    it { should be_a Integer }

    context 'where endpoint is not paginated' do
      before { collection.response.headers.delete('PaginationCurrentPage') }

      it { should be_nil }
    end
  end

  describe '#count' do
    subject { collection.count }

    it { should be_a Integer }
  end

  describe '#next_page' do
    subject { collection.next_page }

    it { should be_a RedboothRuby::Request::Collection }

    context 'where endpoint is not paginated' do
      before { collection.response.headers.delete('PaginationCurrentPage') }

      it { should be_nil }
    end

    context 'where is the last page' do
      before { collection.response.headers['PaginationCurrentPage'] = collection.total_pages.to_s }

      it { should be_nil }
    end
  end

  describe '#prev_page' do
    before { collection.response.headers['PaginationCurrentPage'] = 4 }
    subject { collection.prev_page }

    it { should be_a RedboothRuby::Request::Collection }

    context 'where endpoint is not paginated' do
      before { collection.response.headers.delete('PaginationCurrentPage') }

      it { should be_nil }
    end

    context 'where is the first page' do
      before { collection.response.headers['PaginationCurrentPage'] = 1 }

      it { should be_nil }
    end
  end

end
