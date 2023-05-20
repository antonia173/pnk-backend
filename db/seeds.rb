# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

apartment = RealEstateType.create(typeName: "Apartman")
house = RealEstateType.create(typeName: "Kuća")
work_space = RealEstateType.create(typeName: "Poslovni prostor")

apartment_ana = RealEstate.create(price: 140000.0, realEstateName: "Apartman Ana", realEstateCountry: "Hrvatska", realEstateCity: "Split", real_estate_type: apartment, yearBuilt: 2015, squareSize: 98)
villa_marina = RealEstate.create(price: 890000.0, realEstateName: "Villa Marina", realEstateCountry: "Hrvatska", realEstateCity: "Dubrovnik", real_estate_type: house, yearBuilt: 2018, squareSize: 363)
work_space_kvatric = RealEstate.create(price: 80000.0, realEstateName: "Ured", realEstateCountry: "Hrvatska", realEstateCity: "Zagreb", real_estate_type: work_space, yearBuilt: 2013, squareSize: 278)

RealEstateContent.create(contentName: "Kupaonice", description: "Broj kupaonica u objektu.", quantity: 2, real_estate: apartment_ana)
RealEstateContent.create(contentName: "Kuhinje", description: "Broj kuhinja u objektu.", quantity: 1, real_estate: apartment_ana)

RealEstateContent.create(contentName: "Kupaonice", description: "Broj kupaonica u objektu.", quantity: 4, real_estate: villa_marina)
RealEstateContent.create(contentName: "Kuhinje", description: "Broj kuhinja u objektu.", quantity: 2, real_estate: villa_marina)

RealEstateContent.create(contentName: "Parking", description: "Posotji parking uz objekt.", real_estate: work_space_kvatric)
