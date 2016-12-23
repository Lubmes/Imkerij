require 'rails_helper'

RSpec.feature 'Gebruikers zien alleen links die van toepassing zijn:' do
  let!(:event) { FactoryGirl.create(:event)}
  let!(:category) { FactoryGirl.create(:category)}
  let!(:product) { FactoryGirl.create(:product, category: category )}
  let(:random_user) { FactoryGirl.create(:user) }
  let(:admin) { FactoryGirl.create(:user, :admin) }

  context 'ANONIEME GEBRUIKERS' do

    context '>>> in de winkel' do
      before { visit shop_path }
      scenario '- in de winkel - kunnen niet de "nieuwe categorie" link zien' do
        expect(page).not_to have_link 'nieuwe categorie'
      end
      context '>>> in een categorie >>>' do
        scenario 'kunnen niet de "verwijderen" link zien' do
          within('.category .cat-col') do
            expect(page).not_to have_link 'VERWIJDER'
          end
        end
        scenario 'kunnen niet de "bijwerken" link zien' do
          within('.category .cat-col') do
            expect(page).not_to have_link 'BIJWERKEN'
          end
        end
        scenario 'kunnen niet de "nieuwe product" link zien' do
          within('.category .cat-col') do
            expect(page).not_to have_link 'NIEUW PRODUCT'
          end
        end
      end
      context '>>> in een product >>>' do
        scenario 'kunnen niet de "verwijderen" link zien' do
          within('#products') do
            expect(product).not_to have_content 'VERWIJDER'
          end
        end
        scenario 'kunnen niet de "bijwerken" link zien' do
          within('.product') do
            expect(page).not_to have_link 'BIJWERKEN'
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
            expect(page).not_to have_link 'VERWIJDER'
          end
        end
        scenario 'kunnen niet de "bijwerken" link zien' do
          within('.event') do
            expect(page).not_to have_link 'BIJWERKEN'
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
          within('.category .cat-col') do
            expect(page).not_to have_link 'VERWIJDER'
          end
        end
        scenario 'kunnen niet de "bijwerken" link zien' do
          within('.category .cat-col') do
            expect(page).not_to have_link 'BIJWERKEN'
          end
        end
        scenario 'kunnen niet de "nieuw product" link zien' do
          within('.category .cat-col') do
            expect(page).not_to have_link 'NIEUW PRODUCT'
          end
        end
      end
      context '>>> in een product >>>' do
        scenario 'kunnen niet de "verwijderen" link zien' do
          within('.product') do
            expect(page).not_to have_link 'VERWIJDER'
          end
        end
        scenario 'kunnen niet de "bijwerken" link zien' do
          within('.product') do
            expect(page).not_to have_link 'BIJWERKEN'
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
            expect(page).not_to have_link 'VERWIJDER'
          end
        end
        scenario 'kunnen niet de "bijwerken" link zien' do
          within('.event') do
            expect(page).not_to have_link 'BIJWERKEN'
          end
        end
      end
    end
  end

  context 'ADMINISTRATORS' do
    before { login_as(admin) }

    xcontext '>>> in de winkel' do
      before { visit shop_path }
      scenario 'kunnen de "nieuwe categorie" link zien' do
        expect(page).to have_link 'nieuwe categorie'
      end
      context '>>> in een categorie >>>' do
        scenario 'kunnen de "verwijderen" link zien' do
          within('.category .cat-col') do
            expect(page).to have_link 'VERWIJDER'
          end
        end
        scenario 'kunnen de "bijwerken" link zien' do
          within('.category .cat-col') do
            expect(page).to have_link 'BIJWERKEN'
          end
        end
        scenario 'kunnen de "nieuw product" link zien' do
          within('.category .cat-col') do
            expect(page).to have_link 'NIEUW PRODUCT'
          end
        end
      end
      context '>>> in een product >>>' do
        scenario 'kunnen de "verwijderen" link zien' do
          within('.product') do
            expect(page).to have_link 'VERWIJDER'
          end
        end
        scenario 'kunnen de "bijwerken" link zien' do
          within('.product') do
            expect(page).to have_link 'BIJWERKEN'
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
            expect(page).to have_link 'VERWIJDER'
          end
        end
        scenario 'kunnen de "bijwerken" link zien' do
          within('.event') do
            expect(page).to have_link 'BIJWERKEN'
          end
        end
      end
    end
  end
end
