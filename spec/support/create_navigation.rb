  def create_navigation
    let!(:home)       { create(:page, id: 1, link: 'home') }
    let!(:facilities) { create(:page, id: 2, link: 'facilities') }
    let!(:expo)       { create(:page, id: 3, link: 'expo') }
    let!(:route)      { create(:page, id: 4, link: 'route') }
    let!(:extras)     { create(:page, id: 5, link: 'extras') }
  end
