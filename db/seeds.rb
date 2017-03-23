# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

unless User.exists?(email: 'admin@shop.com')
  User.create!(email: 'admin@shop.com', password: 'password', first_name: 'Imkerij Poppendamme', last_name: 'Meester', admin: true)
end

if false
descr = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."

Picture.delete_all
Product.delete_all
Category.delete_all

# CATEGORIEEN
c1 = Category.create!(name: 'Honing', position: 1 )
c1.pictures.create(position: 1, image: File.new("#{Rails.root}/app/assets/images/sellables/selectie\ imker\ prod\ klein.jpg"))
c1.pictures.create(position: 2, image: File.new("#{Rails.root}/app/assets/images/sellables/selectie\ imker\ prod\ groot.jpg"))
c1.pictures.create(position: 3, image: File.new("#{Rails.root}/app/assets/images/sellables/selectie\ imker\ prod\ krat.jpg"))

c2 = Category.create!(name: 'Andere Etenswaren', position: 2 )
c2.pictures.create(position: 1, image: File.new("#{Rails.root}/app/assets/images/sellables/selectie\ jam\ piramide.jpg"))
c2.pictures.create(position: 2, image: File.new("#{Rails.root}/app/assets/images/sellables/selectie\ jam\ bessen\ aardbei.jpg"))
c2.pictures.create(position: 3, image: File.new("#{Rails.root}/app/assets/images/sellables/selectie\ jam\ bes\ aardbei\ fram.jpg"))
c2.pictures.create(position: 4, image: File.new("#{Rails.root}/app/assets/images/sellables/selectie\ mosterd\ dil\ boer\ grove.jpg"))
c2.pictures.create(position: 5, image: File.new("#{Rails.root}/app/assets/images/sellables/selectie\ mosterd\ knof\ boerin.jpg"))

c3 = Category.create!(name: 'Kaarsen', position: 3 )
c3.pictures.create(position: 1, image: File.new("#{Rails.root}/app/assets/images/sellables/selectie\ kaarsen.jpg"))
c3.pictures.create(position: 2, image: File.new("#{Rails.root}/app/assets/images/sellables/selectie\ kaarsen\ dik\ boven.jpg"))
c3.pictures.create(position: 3, image: File.new("#{Rails.root}/app/assets/images/sellables/selectie\ kaarsen\ dik.jpg"))
c3.pictures.create(position: 4, image: File.new("#{Rails.root}/app/assets/images/sellables/selectie\ kaarsen\ punt.jpg"))

c4 = Category.create!(name: 'Verzorging', position: 4 )
c4.pictures.create(position: 1, image: File.new("#{Rails.root}/app/assets/images/sellables/selectie\ zeep\ artistiek\ 1.jpg"))
c4.pictures.create(position: 2, image: File.new("#{Rails.root}/app/assets/images/sellables/selectie\ zeep\ artistiek\ 2.jpg"))
c4.pictures.create(position: 3, image: File.new("#{Rails.root}/app/assets/images/sellables/selectie\ zeep\ artistiek\ 3.jpg"))
c4.pictures.create(position: 4, image: File.new("#{Rails.root}/app/assets/images/sellables/selectie\ zeep\ doeken.jpg"))
c4.pictures.create(position: 5, image: File.new("#{Rails.root}/app/assets/images/sellables/selectie\ zeep\ gestapeld.jpg"))
c4.pictures.create(position: 6, image: File.new("#{Rails.root}/app/assets/images/sellables/selectie\ zeep\ handdoek\ erop.jpg"))
c4.pictures.create(position: 7, image: File.new("#{Rails.root}/app/assets/images/sellables/selectie\ zeep\ handdoek\ zoom.jpg"))
c4.pictures.create(position: 8, image: File.new("#{Rails.root}/app/assets/images/sellables/selectie\ zeep\ handdoek.jpg"))
c4.pictures.create(position: 9, image: File.new("#{Rails.root}/app/assets/images/sellables/selectie\ zeep\ thee\ handdoek.jpg"))
c4.pictures.create(position: 10, image: File.new("#{Rails.root}/app/assets/images/sellables/selectie\ zeep\ theedoek.jpg"))

c5 = Category.create!(name: 'Propolis', position: 5 )
c5.pictures.create(position: 1, image: File.new("#{Rails.root}/app/assets/images/sellables/selectie\ medicinaal.jpg"))
c5.pictures.create(position: 2, image: File.new("#{Rails.root}/app/assets/images/sellables/selectie\ propolis\ lucht\ 1.jpg"))
c5.pictures.create(position: 3, image: File.new("#{Rails.root}/app/assets/images/sellables/selectie\ propolis\ lucht\ 2.jpg"))
c5.pictures.create(position: 4, image: File.new("#{Rails.root}/app/assets/images/sellables/selectie\ olie\ inctuur.jpg"))

c6 = Category.create!(name: 'Geneeskrachtig', position: 6 )
c6.pictures.create(position: 1, image: File.new("#{Rails.root}/app/assets/images/sellables/selectie\ medicinaal\ groen.jpg"))
c6.pictures.create(position: 2, image: File.new("#{Rails.root}/app/assets/images/sellables/selectie\ medicinaal\ piram.jpg"))
c6.pictures.create(position: 3, image: File.new("#{Rails.root}/app/assets/images/sellables/selectie\ medicinaal\ piram\ achter.jpg"))
c6.pictures.create(position: 4, image: File.new("#{Rails.root}/app/assets/images/sellables/selectie\ medicinaal\ steen.jpg"))
c6.pictures.create(position: 5, image: File.new("#{Rails.root}/app/assets/images/sellables/selectie\ medicinaal\ twee\ steen.jpg"))
c6.pictures.create(position: 6, image: File.new("#{Rails.root}/app/assets/images/sellables/selectie\ medicinaal\ twee\ steen\ achter.jpg"))

# PRODUCTEN
# honing
p1 = Product.create(name: 'Nederlandse Koolzaadhoning', description: descr, price: '4,99', sales_tax: '21,0', mail_weight: 460, category: c1, position: 1 )
p1.pictures.create(position: 1, image: File.new("#{Rails.root}/app/assets/images/sellables/honing\ koolzaad\ 450gr\ 1.jpg"))
p1.pictures.create(position: 2, image: File.new("#{Rails.root}/app/assets/images/sellables/honing\ koolzaad\ 450gr\ 2.jpg"))
p2 = Product.create(name: 'Honing van het Veerse Meer', description: descr, price: '4,99', sales_tax: '21,0', mail_weight: 260, category: c1, position: 2 )
p2.pictures.create(position: 1, image: File.new("#{Rails.root}/app/assets/images/sellables/honing\ veerse\ meer\ 250gr\ 1.jpg"))
p2.pictures.create(position: 2, image: File.new("#{Rails.root}/app/assets/images/sellables/honing\ veerse\ meer\ 250gr\ 2.jpg"))
p2.pictures.create(position: 3, image: File.new("#{Rails.root}/app/assets/images/sellables/honing\ veerse\ meer\ 250gr\ 3.jpg"))
p3 = Product.create(name: 'Honing uit Veere - Oranjezon', description: descr, price: '4,99', sales_tax: '21,0', mail_weight: 260, category: c1, position: 3 )
p3.pictures.create(position: 1, image: File.new("#{Rails.root}/app/assets/images/sellables/honing\ oranjezon\ 250gr.jpg"))
p3.pictures.create(position: 2, image: File.new("#{Rails.root}/app/assets/images/sellables/honing\ oranjezon\ 250gr\ data.jpg"))
p4 = Product.create(name: 'Gegarandeerd Zeeuwse Bloemenhoning', description: descr, price: '4,99', sales_tax: '21,0', mail_weight: 460, category: c1, position: 4 )
p4.pictures.create(position: 1, image: File.new("#{Rails.root}/app/assets/images/sellables/honing\ bloemenhoning.jpg"))
p5 = Product.create(name: 'Acaciahoning met Gelee Royale', description: descr, price: '4,99', sales_tax: '21,0', mail_weight: 260, category: c1, position: 5 )
p5.pictures.create(position: 1, image: File.new("#{Rails.root}/app/assets/images/sellables/honing\ acacia\ g\ r\ 250ml.jpg"))
# creme
p6 = Product.create(name: 'Dag en Nacht Propolis Creme', description: descr, price: '5,99', sales_tax: '21,0', mail_weight: 100, category: c5, position: 1 )
p6.pictures.create(position: 1, image: File.new("#{Rails.root}/app/assets/images/sellables/creme\ propolis\ dag\ nacht\ 2.jpg"))
p7 = Product.create(name: 'Gelee Royale Hand Creme', description: descr, price: '5,99', sales_tax: '21,0', mail_weight: 100, category: c5, position: 2 )
p7.pictures.create(position: 1, image: File.new("#{Rails.root}/app/assets/images/sellables/creme\ hand\ royale\ 1.jpg"))
p7.pictures.create(position: 2, image: File.new("#{Rails.root}/app/assets/images/sellables/creme\ hand\ royale\ 2.jpg"))
p7.pictures.create(position: 3, image: File.new("#{Rails.root}/app/assets/images/sellables/creme\ hand\ royale\ 3.jpg"))
p7.pictures.create(position: 4, image: File.new("#{Rails.root}/app/assets/images/sellables/creme\ hand\ royale\ 4.jpg"))
p8 = Product.create(name: 'Gelee Royale Creme', description: descr, price: '5,99', sales_tax: '21,0', mail_weight: 100, category: c5, position: 3)
p8.pictures.create(position: 1, image: File.new("#{Rails.root}/app/assets/images/sellables/creme\ gelee\ royale.jpg"))
# medisch
p9 = Product.create(name: 'Gelee Royale Capsules', description: descr, price: '2,99', sales_tax: '21,0', mail_weight: 80, category: c6, position: 1 )
p9.pictures.create(position: 1, image: File.new("#{Rails.root}/app/assets/images/sellables/gelee\ royale\ caps\ voor\ groen.jpg"))
p9.pictures.create(position: 2, image: File.new("#{Rails.root}/app/assets/images/sellables/gelee\ royale\ caps\ achter\ groen.jpg"))
# jam
p10 = Product.create(name: 'Zeeuwse Aardbeienjam', description: descr, price: '2,99', sales_tax: '21,0', mail_weight: 230, category: c2, position: 1 )
p10.pictures.create(position: 1, image: File.new("#{Rails.root}/app/assets/images/sellables/jam\ aardbeien.jpg"))
p11 = Product.create(name: 'Zeeuwse Frambozenjam', description: descr, price: '2,99', sales_tax: '21,0', mail_weight: 230, category: c2, position: 2 )
p11.pictures.create(position: 1, image: File.new("#{Rails.root}/app/assets/images/sellables/jam\ frambozen.jpg"))
p12 = Product.create(name: 'Zeeuwse Zwarte bessenjam', description: descr, price: '2,99', sales_tax: '21,0', mail_weight: 230, category: c2, position: 3 )
p12.pictures.create(position: 1, image: File.new("#{Rails.root}/app/assets/images/sellables/jam\ zwarte\ bessen.jpg"))
# kaarsen
p13 = Product.create(name: 'Dikke cilinder kaars', description: descr, price: '3,69', sales_tax: '21,0', mail_weight: 220, category: c3, position: 1 )
p13.pictures.create(position: 1, image: File.new("#{Rails.root}/app/assets/images/sellables/kaars\ cilinder\ dik.jpg"))
p14 = Product.create(name: 'Lange dikke cilinder kaars', description: descr, price: '3,69', sales_tax: '21,0', mail_weight: 200, category: c3, position: 2 )
p14.pictures.create(position: 1, image: File.new("#{Rails.root}/app/assets/images/sellables/kaars\ cilinder\ lang\ dik.jpg"))
p15 = Product.create(name: 'Duo lange dunne cilinder kaarsen', description: descr, price: '3,69', sales_tax: '21,0', mail_weight: 150, category: c3, position: 3 )
p15.pictures.create(position: 1, image: File.new("#{Rails.root}/app/assets/images/sellables/kaars\ cilinder\ lang\ dun\ duo.jpg"))
p16 = Product.create(name: 'Kaars in vorm van een korf', description: descr, price: '3,69', sales_tax: '21,0', mail_weight: 120, category: c3, position: 4 )
p16.pictures.create(position: 1, image: File.new("#{Rails.root}/app/assets/images/sellables/kaars\ korf\ klein.jpg"))
p17 = Product.create(name: 'Kaars in vorm van een middellange korf', description: descr, price: '3,69', sales_tax: '21,0', mail_weight: 140, category: c3, position: 5 )
p17.pictures.create(position: 1, image: File.new("#{Rails.root}/app/assets/images/sellables/kaars\ korf\ middel.jpg"))
p18 = Product.create(name: 'Kaars in vorm van een lange korf', description: descr, price: '3,69', sales_tax: '21,0', mail_weight: 160, category: c3, position: 6 )
p18.pictures.create(position: 1, image: File.new("#{Rails.root}/app/assets/images/sellables/kaars\ korf\ lang.jpg"))
p19 = Product.create(name: 'Lange puntvormige kaars', description: descr, price: '3,69', sales_tax: '21,0', mail_weight: 220, category: c3, position: 7 )
p19.pictures.create(position: 1, image: File.new("#{Rails.root}/app/assets/images/sellables/kaars\ punt\ lang.jpg"))
p20 = Product.create(name: 'Middellange puntvormige kaars', description: descr, price: '3,69', sales_tax: '21,0', mail_weight: 200, category: c3, position: 8 )
p20.pictures.create(position: 1, image: File.new("#{Rails.root}/app/assets/images/sellables/kaars\ punt\ middel.jpg"))
p21 = Product.create(name: 'Korte puntvormige kaars', description: descr, price: '3,69', sales_tax: '21,0', mail_weight: 140, category: c3, position: 9 )
p21.pictures.create(position: 1, image: File.new("#{Rails.root}/app/assets/images/sellables/kaars\ punt\ klein.jpg"))
p22 = Product.create(name: 'Pakket van vijf kaarsen', description: descr, price: '12,69', sales_tax: '21,0', mail_weight: 480, category: c3, position: 10 )
p22.pictures.create(position: 1, image: File.new("#{Rails.root}/app/assets/images/sellables/kaarsen\ pakket\ van\ vijf\ boven\ 1.jpg"))
p22.pictures.create(position: 2, image: File.new("#{Rails.root}/app/assets/images/sellables/kaarsen\ pakket\ van\ vijf\ boven\ 2.jpg"))
p22.pictures.create(position: 3, image: File.new("#{Rails.root}/app/assets/images/sellables/kaarsen\ pakket\ van\ vijf\ voor.jpg"))
# ladopakket
p23 = Product.create(name: 'Kadopakket honing kaars', description: descr, price: '8,99', sales_tax: '21,0', mail_weight: 350, category: c3, position: 11 )
p23.pictures.create(position: 1, image: File.new("#{Rails.root}/app/assets/images/sellables/kadopakket\ honing\ kaars.jpg"))
p23.pictures.create(position: 2, image: File.new("#{Rails.root}/app/assets/images/sellables/kadopakket\ honing\ kaars\ uit.jpg"))
# lipbalsem
p24 = Product.create(name: 'Lipbalsem', description: descr, price: '2,45', sales_tax: '21,0', mail_weight: 30, category: c4, position: 1 )
p24.pictures.create(position: 1, image: File.new("#{Rails.root}/app/assets/images/sellables/lipbalsem.jpg"))
# pollen
p25 = Product.create(name: 'Pollen', description: descr, price: '12,50', sales_tax: '21,0', mail_weight: 500, category: c6, position: 2 )
p25.pictures.create(position: 1, image: File.new("#{Rails.root}/app/assets/images/sellables/pollen\ 1.jpg"))
p25.pictures.create(position: 2, image: File.new("#{Rails.root}/app/assets/images/sellables/pollen\ 2.jpg"))
p25.pictures.create(position: 3, image: File.new("#{Rails.root}/app/assets/images/sellables/pollen\ 3.jpg"))
p25.pictures.create(position: 4, image: File.new("#{Rails.root}/app/assets/images/sellables/pollen\ zoom.jpg"))
p25.pictures.create(position: 5, image: File.new("#{Rails.root}/app/assets/images/sellables/pollen\ in\ schaal\ gras.jpg"))
p25.pictures.create(position: 6, image: File.new("#{Rails.root}/app/assets/images/sellables/pollen\ in\ schaal\ hout.jpg"))
p25.pictures.create(position: 7, image: File.new("#{Rails.root}/app/assets/images/sellables/pollen\ in\ schaal\ marmer\ boven.jpg"))
p25.pictures.create(position: 8, image: File.new("#{Rails.root}/app/assets/images/sellables/pollen\ in\ schaal\ marmer.jpg"))
p25.pictures.create(position: 9, image: File.new("#{Rails.root}/app/assets/images/sellables/pollen\ in\ schaal\ met\ zak.jpg"))
# propolis
p26 = Product.create(name: 'Propolis granulaat', description: descr, price: '2,99', sales_tax: '21,0', mail_weight: 200, category: c5, position: 4 )
p26.pictures.create(position: 1, image: File.new("#{Rails.root}/app/assets/images/sellables/propolis\ granulaat\ voor\ groen.jpg"))
p26.pictures.create(position: 2, image: File.new("#{Rails.root}/app/assets/images/sellables/propolis\ granulaat\ achter\ groen.jpg"))
p27 = Product.create(name: 'Propoliscapsules', description: descr, price: '3,60', sales_tax: '21,0', mail_weight: 200, category: c5, position: 5 )
p27.pictures.create(position: 1, image: File.new("#{Rails.root}/app/assets/images/sellables/propoliscapsules\ voor\ groen.jpg"))
p27.pictures.create(position: 2, image: File.new("#{Rails.root}/app/assets/images/sellables/propoliscapsules\ voor\ steen.jpg"))
p27.pictures.create(position: 3, image: File.new("#{Rails.root}/app/assets/images/sellables/propoliscapsules\ achter\ groen\ 2.jpg"))
p27.pictures.create(position: 4, image: File.new("#{Rails.root}/app/assets/images/sellables/propoliscapsules\ achter\ steen.jpg"))
p28 = Product.create(name: 'Propolisinctuur', description: descr, price: '3,89', sales_tax: '21,0', mail_weight: 150, category: c5, position: 6 )
p28.pictures.create(position: 1, image: File.new("#{Rails.root}/app/assets/images/sellables/propolisinctuur.jpg"))
p29 = Product.create(name: 'Propolisolie', description: descr, price: '3,50', sales_tax: '21,0', mail_weight: 150, category: c5, position: 7 )
p29.pictures.create(position: 1, image: File.new("#{Rails.root}/app/assets/images/sellables/propolisolie.jpg"))
p30 = Product.create(name: 'Propolissiroop 200ml', description: descr, price: '5,70', sales_tax: '21,0', mail_weight: 220, category: c5, position: 8 )
p30.pictures.create(position: 1, image: File.new("#{Rails.root}/app/assets/images/sellables/propolissiroop\ 200ml.jpg"))
p31 = Product.create(name: 'Propolistabletten', description: descr, price: '3,40', sales_tax: '21,0', mail_weight: 150, category: c5, position: 9 )
p31.pictures.create(position: 1, image: File.new("#{Rails.root}/app/assets/images/sellables/propolistabletten\ voor\ groen.jpg"))
p31.pictures.create(position: 2, image: File.new("#{Rails.root}/app/assets/images/sellables/propolistabletten\ voor\ steen.jpg"))
p31.pictures.create(position: 3, image: File.new("#{Rails.root}/app/assets/images/sellables/propolistabletten\ achter\ groen.jpg"))
p31.pictures.create(position: 4, image: File.new("#{Rails.root}/app/assets/images/sellables/propolistabletten\ achter\ steen.jpg"))
p32 = Product.create(name: 'Propoliszalf', description: descr, price: '4,50', sales_tax: '21,0', mail_weight: 180, category: c5, position: 10 )
p32.pictures.create(position: 1, image: File.new("#{Rails.root}/app/assets/images/sellables/propoliszalf\ doos.jpg"))
p32.pictures.create(position: 2, image: File.new("#{Rails.root}/app/assets/images/sellables/propoliszalf\ tube.jpg"))
# shampoo
p33 = Product.create(name: 'Honing Shampoo', description: descr, price: '4,65', sales_tax: '21,0', mail_weight: 430, category: c4, position: 2 )
p33.pictures.create(position: 1, image: File.new("#{Rails.root}/app/assets/images/sellables/shampoo\ honing.jpg"))
p34 = Product.create(name: 'Shampoo Propolis', description: descr, price: '4,10', sales_tax: '21,0', mail_weight: 430, category: c4, position: 3 )
p34.pictures.create(position: 1, image: File.new("#{Rails.root}/app/assets/images/sellables/shampoo\ propolis.jpg"))
# tandpasta
p35 = Product.create(name: 'Propodent', description: descr, price: '3,80', sales_tax: '21,0', mail_weight: 220, category: c4, position: 4 )
p35.pictures.create(position: 1, image: File.new("#{Rails.root}/app/assets/images/sellables/tandpasta\ propodent.jpg"))
# uiercreme
p36 = Product.create(name: 'Uiercreme met koninginnebrij', description: descr, price: '3,55', sales_tax: '21,0', mail_weight: 300, category: c6, position: 3 )
p36.pictures.create(position: 1, image: File.new("#{Rails.root}/app/assets/images/sellables/uiercreme\ 350ml.jpg"))
# zeep
p37 = Product.create(name: 'Miel zeep met blok', description: descr, price: '4,80', sales_tax: '21,0', mail_weight: 400, category: c4, position: 5 )
p37.pictures.create(position: 1, image: File.new("#{Rails.root}/app/assets/images/sellables/zeep\ miel\ blok\ 1.jpg"))
p37.pictures.create(position: 2, image: File.new("#{Rails.root}/app/assets/images/sellables/zeep\ miel\ blok\ 2.jpg"))
p37.pictures.create(position: 3, image: File.new("#{Rails.root}/app/assets/images/sellables/zeep\ miel\ blok\ licht.jpg"))
p37.pictures.create(position: 4, image: File.new("#{Rails.root}/app/assets/images/sellables/selectie\ zeep\ plus\ blok.jpg"))
p38 = Product.create(name: 'Miel zeep', description: descr, price: '3,80', sales_tax: '21,0', mail_weight: 360, category: c4, position: 6 )
p38.pictures.create(position: 1, image: File.new("#{Rails.root}/app/assets/images/sellables/zeep\ miel\ voor.jpg"))
p38.pictures.create(position: 2, image: File.new("#{Rails.root}/app/assets/images/sellables/zeep\ miel\ gras.jpg"))
end

pages = Page.all
pages.each do |page|
  page.pictures.delete_all
end
Page.delete_all

home        = Page.create(   id: 1,
                           link: "De Imkerij",
                          title: "Welkom op de website van Imkerij Poppendamme",
                   introduction: "Imkerij Poppendamme is al 25 jaar een begrip op Walcheren. Aan een van die mooie binnenwegen vindt u onze imkerijwinkel, expositieruimte en terras. De ideale plek om even uit te rusten na een fietstocht over het Walcherse platteland.",
                          story: %{
                            Op ons groene en rustige terras kunt u genieten van koffie met gebak, een kopje honingthee of een heerlijk honingijsje. In de imkerijwinkel vindt u, naast onze honing, een keur aan produkten die met bijen en honing te maken hebben. Zo hebben we kaarsen, honingwijn, snoepgoed, propolisprodukten en tal van leuke kadoartikelen.

                            In de expositieruimte ziet u onze bijen aan het werk. Veilig achter glas natuurlijk. Ook is er een kleine tentoonstelling over de bijenhouderij en draait er een leuke en informatieve film over de wondere wereld van de honingbij.

                            Zoals u misschien al weet zijn we eind 2011 verhuisd naar de schuur in de tuin bij het woonhuis. Dit is ongeveer 50 meter van de oude locatie. Wanneer u de Poppendamseweg in rijdt ziet u aan de borden langs de weg precies waar de nieuwe inrit is.

                            Hopelijk is onze webwinkel binnenkort online. Hierin vindt u een groot gedeelte van onze producten die u gemakkelijk kunt bestellen en laten thuis bezorgen. Tot die tijd kunt u altijd telefonisch of per email bestellingen plaatsen.

                            Heeft u vragen? Bel of mail gerust, we staan u graag te woord.

                            Arjen de Meester

                            Imkerij Poppendamme
                            })
home.pictures.create(position: 1, image: File.new("#{Rails.root}/app/assets/images/pages/carrousel1.jpeg"))
home.pictures.create(position: 2, image: File.new("#{Rails.root}/app/assets/images/pages/carrousel2.jpeg"))
home.pictures.create(position: 3, image: File.new("#{Rails.root}/app/assets/images/pages/carrousel3.jpeg"))
home.pictures.create(position: 4, image: File.new("#{Rails.root}/app/assets/images/pages/carrousel4.jpeg"))
home.pictures.create(position: 5, image: File.new("#{Rails.root}/app/assets/images/pages/carrousel5.jpeg"))

facilities  = Page.create(   id: 2,
                           link: "Bij ons op het erf",
                          title: "Onze natuurwinkel en ons terras",
                   introduction: "Het terras van Imkerij Poppendamme is al sinds jaar en dag een populaire pleisterplaats voor fietsers en wandelaars. Midden in onze drachtplantentuin schenken we koffie, thee en diverse andere versnaperingen. Voor wie de drukte aan de Zeeuwse kusten soms een beetje teveel wordt is dit een uitgelezen gelegenheid even helemaal tot rust te komen.",
                          story: %{
Mocht u ons met een grotere groep willen bezoeken dan kan dat uiteraard altijd. Stuurt u ons een emailtje om te informeren naar de mogelijkheden.

Wie op zoek is naar bijzondere bijenprodukten of een leuk en uniek kadootje komt in de imkerijwinkel goed aan zijn trekken. Wij verkopen er uiteraard onze honing, maar daarnaast ook vanalles dat met bijen te maken heeft. Zo hebben we (handgemaakte) bijenwaskaarsen, allerlei honingsnoep, propolis en gelee royale produkten, diverse soorten honingwijn (die u uiteraard ook proeven kunt) en leuke kleinigheidjes voor de kinderen om of een vriend of familielid eens mee te verrassen.

We zijn nog steeds bezig aan onze webwinkel die u later dit jaar op deze website zult terugvinden. Tot die tijd kunt u voor uw bestellingen bellen of emailen. Of u komt gewoon even langs natuurlijk.
                            })
facilities.pictures.create(position: 1, image: File.new("#{Rails.root}/app/assets/images/pages/winkelenterras.jpeg"))
facilities.pictures.create(position: 2, image: File.new("#{Rails.root}/app/assets/images/pages/imkerij.jpeg"))
expo        = Page.create(   id: 3,
                           link: "Expo",
                          title: "Zie onze bijen van dichtbij aan het werk",
                   introduction: "De honingbij is het kleinste landbouwhuisdier van de mens. Maar zeker een van de belangrijkste. De bij is onmisbaar voor de wereldwijde voedselproduktie. In onze expositieruimte krijgt u een kort en interessant overzicht van wat er allemaal komt kijken bij het houden van bijen. Zo hebben we een mooie collectie imkermaterialen van over de hele wereld en kunt u de bijen natuurlijk ook zien. Achter glas uiteraard",
                          story: %{
U ziet vanaf een paar centimeter afstand de werksters bezig aan het maken van nieuwe raten, u ziet de bijen af en aan vliegen met klontjes stuifmeel aan de poten en met een beetje geluk bent u getuige van een bijenzwerm of de bruidsvlucht van de koningin.

In de expo draait ook een informatieve film die het leven van de honingbij duidelijk maakt voor jong en oud. En mocht u daarna nog vragen hebben over alles wat met bijen te maken heeft dan beantwoorden we die graag.

De expositie is vrij toegangkelijk. Reserveren o.i.d. is niet nodig.
                            })
expo.pictures.create(position: 1, image: File.new("#{Rails.root}/app/assets/images/pages/expo.jpeg"))
route       = Page.create(   id: 4,
                           link: "Route",
                          title: "Routebeschrijving",
                   introduction: "Hoe komt u op de imkerij?",
                          route: true,
                          story: %{
**Met de fiets** vind je Imkerij Poppendamme centraal gelegen op Walcheren op een knooppunt van een aantal fiets- en wandelroutes. U vindt ons op een steenworp afstand van Grijpskerke in de Poppendamseweg. De imkerij staat aangegeven op de bekende fietsrouteborden van de ANWB.

**Met de auto** bent u uiteraard ook welkom op de imkerij. Komende vanaf Middelburg richting Grijpskerke neemt u vlak voor Grijpskerke de eerste weg links, dit is na het tankstation. Komende vanaf Domburg/Zoutelande/Veere neemt u in Grijpskerke de Middelburgseweg richting Middelburg. U slaat na ongeveer 1 kilometer rechtsaf de Poppendamseweg in.
                            })
extras      = Page.create(   id: 5,
                           link: "Zie ook",
                          title: "Hier vind je ons ook",
                   introduction: "In de omgeving verspreiden wij onze streekproducten en hiernaast zijn wij ook in de wereld van bijenhouders actief betrokken.",
                          story: %{
#### [Peper & Zout](http://www.peperenzout.com)

in dit restaurant kun je gezellig eten onder het genot van goede wijn, terwijl je bedient wordt door een keuken welke veelvuldig gebruik maakt van verse streekprodructen. Prachtig gelokaliseerd pal naast het mooie oude stadhuis in het al even betoverende historische centrum van Middelburg.

#### [Domburgsche Bier en Melksalon](http://www.bierenmelksalon.nl)

een mooie plaats in Domburg waar je kunt ontbijten, lunchen of gewoon even lekker een kopje versgemalen koffie kunt komen drinken. Naast een vaste menukaart vind je hier een regelmatig wisselende kaart die op de muur staat geschreven. Alle gerechten en taarten maken ze zelf met gebruik van biologische ingredienten aangevuld met producten uit de streek.

### Andere nuttige links

####[Nederlandse Bijenhoudersvereniging](http://www.bijenhouders.nl)

Heeft u altijd al imker willen worden of bent u op zoek naar specifieke informatie over de bijenteelt? Kijk dan op de website van de Nederlandse Bijenhoudersvereniging.

#### [Walcherse afdeling NBV](http://walcheren.bijenhouders.nl/)

Heeft u een bijenzwerm in de tuin? De afdeling walcheren van de NBV heeft een scheplijst met contactgegevens van imkers in de buurt.

#### [Logeren bij een imker](https://www.airbnb.nl/rooms/2842335?guests=1&s=z3Aob7Nu)

Logeren in het huis van de imker? Dat kan!
                            })
