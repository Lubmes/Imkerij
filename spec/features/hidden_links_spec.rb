require 'rails_helper'

RSpec.feature 'Gebruikers zien alleen links die van toepassing zijn:' do
  let!(:category) { FactoryGirl.create(:category, name: 'Honing' )}
  let!(:product) { FactoryGirl.create(:product, name: 'Honingpot 200ml', 
                                                  description: 'Honing uit Veere.',
                                                  category: category )}
  let(:random_user) { FactoryGirl.create(:user) }
  let(:admin) { FactoryGirl.create(:user, :admin) }

  context 'anonieme gebruikers' do
    before { visit categories_path }

    scenario 'kunnen niet de "nieuwe categorie" link zien' do
      expect(page).not_to have_link 'nieuwe categorie'
    end
    context '- in een categorie -' do
      scenario 'kunnen niet de "verwijderen" link zien' do
        within('#category .cat-col') do
          expect(page).not_to have_link 'VERWIJDER'
        end
      end
      scenario 'kunnen niet de "bijwerken" link zien' do
        within('#category .cat-col') do
          expect(page).not_to have_link 'BIJWERKEN'
        end
      end
      scenario 'kunnen niet de "nieuwe product" link zien' do
        within('#category .cat-col') do
          expect(page).not_to have_link 'NIEUW PRODUCT'
        end
      end
    end
    context '- in een product -' do
      scenario 'kunnen niet de "verwijderen" link zien' do
        within('#products') do
          expect(product).not_to have_content 'VERWIJDER'
        end
      end
      scenario 'kunnen niet de "bijwerken" link zien' do
        within('#product') do
          expect(page).not_to have_link 'BIJWERKEN'
        end
      end
    end
  end

  context 'willekeurige gebruikers' do
    before do
      login_as(random_user) 
      visit categories_path
    end

    scenario 'kunnen niet de "nieuwe categorie" link zien' do
      expect(page).not_to have_link 'nieuwe categorie'
    end

    context '- in een categorie -' do
      scenario 'kunnen niet de "verwijderen" link zien' do
        within('#category .cat-col') do
          expect(page).not_to have_link 'VERWIJDER'
        end
      end
      scenario 'kunnen niet de "bijwerken" link zien' do
        within('#category .cat-col') do
          expect(page).not_to have_link 'BIJWERKEN'
        end
      end
      scenario 'kunnen niet de "nieuw product" link zien' do
        within('#category .cat-col') do
          expect(page).not_to have_link 'NIEUW PRODUCT'
        end
      end
    end
    context '- in een product -' do
      scenario 'kunnen niet de "verwijderen" link zien' do
        within('#product') do
          expect(page).not_to have_link 'VERWIJDER'
        end
      end
      scenario 'kunnen niet de "bijwerken" link zien' do
        within('#product') do
          expect(page).not_to have_link 'BIJWERKEN'
        end
      end
    end
  end

  context 'administrators' do
    before do 
      login_as(admin)
      visit categories_path
    end

    scenario 'kunnen de "nieuwe categorie" link zien' do
      expect(page).to have_link 'nieuwe categorie'
    end
    context '- in een categorie -' do
      scenario 'kunnen de "verwijderen" link zien' do
        within('#category .cat-col') do
          expect(page).to have_link 'VERWIJDER'
        end
      end
      scenario 'kunnen de "bijwerken" link zien' do
        within('#category .cat-col') do
          expect(page).to have_link 'BIJWERKEN'
        end
      end
      scenario 'kunnen de "nieuw product" link zien' do
        within('#category .cat-col') do
          expect(page).to have_link 'NIEUW PRODUCT'
        end
      end
    end
    context '- in een product -' do
      scenario 'kunnen de "verwijderen" link zien' do
        within('#product') do
          expect(page).to have_link 'VERWIJDER'
        end
      end
      scenario 'kunnen de "bijwerken" link zien' do
        within('#product') do
          expect(page).to have_link 'BIJWERKEN'
        end
      end
    end
  end
end