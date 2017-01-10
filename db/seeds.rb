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

descr = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."

# unless Category.exists?(name: 'Snoep')
# end
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
