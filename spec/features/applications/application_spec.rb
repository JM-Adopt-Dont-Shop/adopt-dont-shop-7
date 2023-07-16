require "rails_helper"

RSpec.describe "application" do
  it "displays a link to all pets" do
    visit "/"
    expect(page).to have_content("Adopt, don't shop!")
    expect(page).to have_link("Pets")
    click_link("Pets")
    expect(page).to have_current_path("/pets")
  end

  it "displays a link to all shelters" do
    visit "/"

    expect(page).to have_link("Shelters")
    click_link("Shelters")
    expect(page).to have_current_path("/shelters")
    expect(page).to have_link("Shelters")
    expect(page).to have_link("Pets")
    expect(page).to have_link("Veterinarians")
    expect(page).to have_link("Veterinary Offices")
  end

  it "displays a link to all veterinary offices" do
    visit "/"

    expect(page).to have_link("Veterinary Offices")
    click_link("Veterinary Offices")
    expect(page).to have_current_path("/veterinary_offices")
    expect(page).to have_link("Shelters")
    expect(page).to have_link("Pets")
    expect(page).to have_link("Veterinarians")
    expect(page).to have_link("Veterinary Offices")
  end

  it "displays a link to all veterinarians" do
    visit "/"

    expect(page).to have_link("Veterinarians")
    click_link("Veterinarians")
    expect(page).to have_current_path("/veterinarians")
    expect(page).to have_link("Shelters")
    expect(page).to have_link("Pets")
    expect(page).to have_link("Veterinarians")
    expect(page).to have_link("Veterinary Offices")
  end

  it "displays a link to specfic pets" do
    @shelter_1 = Shelter.create!(foster_program: true, name: "Denver Animal Shelter", city: "Denver", rank: 1)
    @pet_1 = Pet.create!(adoptable: true, age: 1, breed: "sphynx", name: "Lucille Bald", shelter_id: @shelter_1.id)
    @application_1 = Application.create!(name_of_applicant: "Matt Lim", street_address: "1234 Example St", city: "Denver", state: "CO", zip_code: 80202, description: "I love animals", application_status: "Pending", shelter_id: @shelter_1.id)
    @application_2 = Application.create!(name_of_applicant: "Jorja Fleming", street_address: "5678 Sample St", city: "Denver", state: "CO", zip_code: 80202, description: "I am lonely and need cats", application_status: "Pending", shelter_id: @shelter_1.id)
    @application_1.pets << @pet_1

    visit "/applications/#{@application_1.id}"

    expect(page).to have_content("Matt Lim")

    click_link 'Lucille Bald'
    expect(page).to have_current_path("/applications/pets/#{@pet_1.id}")
  end

  # [ ] done
  # 3. Starting an Application, Form not Completed
  describe "As a visitor" do
    describe "When I visit the new application page" do
      describe "And I fail to fill in any of the form fields" do
        describe "And I click submit" do
          describe "Then I am taken back to the new applications page" do
            it "And I see a message that I must fill in those fields" do
              @shelter_1 = Shelter.create!(foster_program: true, name: "Denver Animal Shelter", city: "Denver", rank: 1)
              # require 'pry'; binding.pry
              visit "/applications"
              click_link "Start an Application"
              click_button "Submit Application"

              expect(current_path).to eq("/applications/new")
              expect(page).to have_content("Error: Name of applicant can't be blank, Street address can't be blank, City can't be blank, State can't be blank, Zip code can't be blank, Description can't be blank, Name of applicant Please provide the name of the applicant., Street address Please provide the street address., City Please provide the city., State Please provide the state., Zip code Please provide the zip code., Description Please provide a description.")
            end
          end
        end
      end
    end
  end

  #6. Submit an Application
  # As a visitor
  describe "When I visit an application's show page" do
    describe "And I have added one or more pets to the application" do
      it "Then I see a section to submit my application" do

        visit "/applications"

        

      end
    end
  end

  describe "And in that section I see an input to enter why I would make a good owner for these pet(s)" do
    describe "When I fill in that input" do
      describe "And I click a button to submit this application" do
        it "Then I am taken back to the applications show page" do

        end
      end
    end
  end

  describe "And I see an indicator that the application is Pending" do
    describe "And I see all the pets that I want to adopt" do
      it "And I do not see a section to add more pets to this application" do


      end
    end
  end
end
