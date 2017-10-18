  def create_navigation
    let!(:widget)     { create(:information_widget, title: 'openingstijden',
                                                    information: 'van vroeg tot laat') }
    let!(:home)       { create(:page, id: 1,
                                      link: 'home',
                                      opening_times_widget: widget) }
    let!(:facilities) { create(:page, id: 2,
                                      link: 'facilities',
                                      opening_times_widget: widget) }
    let!(:expo)       { create(:page, id: 3,
                                      link: 'expo',
                                      opening_times_widget: widget) }
    let!(:route)      { create(:page, id: 4,
                                      link: 'route',
                                      opening_times_widget: widget) }
    let!(:extras)     { create(:page, id: 5,
                                      link: 'extras',
                                      opening_times_widget: widget) }
  end
