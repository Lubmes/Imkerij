require 'rails_helper'
require 'factory_girl_rails'

feature 'Gebruikers zien alleen links die van toepassing zijn:' do
  create_navigation
  let!(:event)      { create(:event)}
  let!(:category)   { create(:category)}
  let!(:product)    { create(:product, category: category )}
  let(:random_user) { create(:user) }
  let(:admin)       { create(:user, :admin) }

  context 'ANONIEME GEBRUIKERS' do

    context '>>> in de winkel' do
      before { visit shop_path }
      scenario '- in de winkel - kunnen niet de "nieuwe categorie" link zien' do
        expect(page).not_to have_link 'nieuwe categorie'
      end
      context '>>> in een categorie >>>' do
        scenario 'kunnen niet de "verwijderen" link zien' do
          within('.category .category-bar') do
            expect(page).not_to have_link 'verwijderen'
          end
        end
        scenario 'kunnen niet de "bijwerken" link zien' do
          within('.category .category-bar') do
            expect(page).not_to have_link 'bijwerken'
          end
        end
        scenario 'kunnen niet de "nieuwe product" link zien' do
          within('.category .category-bar') do
            expect(page).not_to have_link 'nieuw product'
          end
        end
      end
      context '>>> in een product >>>' do
        scenario 'kunnen niet de "verwijderen" link zien' do
          within('#products') do
            expect(product).not_to have_content 'verwijderen'
          end
        end
        scenario 'kunnen niet de "bijwerken" link zien' do
          within('.product') do
            expect(page).not_to have_link 'bijwerken'
          end
        end
      end
    end

    context '>>> in de agenda >>>' do
      before { visit events_path }
      scenario 'kunnen niet de "nieuw agendapunt" link zien' do
        expect(page).not_to have_link 'nieuw agendapunt'
      end
      context 'in een agendapunt >>>' do
        scenario 'kunnen niet de "verwijderen" link zien' do
          within('.event') do
            expect(page).not_to have_link 'verwijderen'
          end
        end
        scenario 'kunnen niet de "bijwerken" link zien' do
          within('.event') do
            expect(page).not_to have_link 'bijwerken'
          end
        end
      end
    end
  end

  context 'WILLEKEURIGE GEBRUIKERS' do
    before { login_as(random_user) }

    context '>>> in de winkel' do
      before { visit shop_path }
      scenario 'kunnen niet de "nieuwe categorie" link zien' do
        expect(page).not_to have_link 'nieuwe categorie'
      end
      context '>>> in een categorie >>>' do
        scenario 'kunnen niet de "verwijderen" link zien' do
          within('.category .category-bar') do
            expect(page).not_to have_link 'verwijderen'
          end
        end
        scenario 'kunnen niet de "bijwerken" link zien' do
          within('.category .category-bar') do
            expect(page).not_to have_link 'bijwerken'
          end
        end
        scenario 'kunnen niet de "nieuw product" link zien' do
          within('.category .category-bar') do
            expect(page).not_to have_link 'nieuw product'
          end
        end
      end
      context '>>> in een product >>>' do
        scenario 'kunnen niet de "verwijderen" link zien' do
          within('.product') do
            expect(page).not_to have_link 'verwijderen'
          end
        end
        scenario 'kunnen niet de "bijwerken" link zien' do
          within('.product') do
            expect(page).not_to have_link 'bijwerken'
          end
        end
      end
    end

    context '>>> in de agenda >>>' do
      before { visit events_path }
      scenario 'kunnen niet de "nieuw agendapunt" link zien' do
        expect(page).not_to have_link 'nieuw agendapunt'
      end
      context 'in een agendapunt >>>' do
        scenario 'kunnen niet de "verwijderen" link zien' do
          within('.event') do
            expect(page).not_to have_link 'verwijderen'
          end
        end
        scenario 'kunnen niet de "bijwerken" link zien' do
          within('.event') do
            expect(page).not_to have_link 'bijwerken'
          end
        end
      end
    end
  end

  context 'ADMINISTRATORS' do
    before { login_as(admin) }

    context '>>> in de winkel' do
      before { visit shop_path }
      scenario 'kunnen de "nieuwe categorie" link zien' do
        expect(page).to have_link 'nieuwe categorie'
      end
      context '>>> in een categorie >>>' do
        scenario 'kunnen de "verwijderen" link zien' do
          within('.category .category-bar') do
            expect(page).to have_link 'verwijderen'
          end
        end
        scenario 'kunnen de "bijwerken" link zien' do
          within('.category .category-bar') do
            expect(page).to have_link 'bijwerken'
          end
        end
        scenario 'kunnen de "nieuw product" link zien' do
          within('.category .category-bar') do
            expect(page).to have_link 'nieuw product'
          end
        end
      end
      context '>>> in een product >>>' do
        scenario 'kunnen de "verwijderen" link zien' do
          within('.product') do
            expect(page).to have_link 'verwijderen'
          end
        end
        scenario 'kunnen de "bijwerken" link zien' do
          within('.product') do
            expect(page).to have_link 'bijwerken'
          end
        end
      end
    end

    context '>>> in de agenda >>>' do
      before { visit events_path }
      scenario 'kunnen de "nieuw agendapunt" link zien' do
        expect(page).to have_link 'nieuw agendapunt'
      end
      context 'in een agendapunt >>>' do
        scenario 'kunnen de "verwijderen" link zien' do
          within('.event') do
            expect(page).to have_link 'verwijderen'
          end
        end
        scenario 'kunnen de "bijwerken" link zien' do
          within('.event') do
            expect(page).to have_link 'bijwerken'
          end
        end
      end
    end
  end
end
