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

  it "displays a link to specific pets" do
    @shelter_1 = Shelter.create!(foster_program: true, name: "Denver Animal Shelter", city: "Denver", rank: 1)
    @pet_1 = Pet.create!(adoptable: true, age: 1, breed: "sphynx", name: "Lucille Bald", shelter_id: @shelter_1.id)
    @application_1 = Application.create!(name_of_applicant: "Matt Lim", street_address: "1234 Example St", city: "Denver", state: "CO", zip_code: 80202, description: "I love animals", application_status: "Pending")
    @application_2 = Application.create!(name_of_applicant: "Jorja Fleming", street_address: "5678 Sample St", city: "Denver", state: "CO", zip_code: 80202, description: "I am lonely and need cats", application_status: "Pending")
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

  # [ ] done
  # 4. Searching for Pets for an Application

  describe "As a visitor" do
    describe "When I visit an application's show page" do
      describe "And that application has not been submitted," do
        describe "Then I see a section on the page to Add a Pet to this Application" do
          describe "In that section, I see an input where I can search for Pets by name" do
            describe "When I fill in this field with a Pet's name" do
              describe "And I click submit," do
                describe "Then I am taken back to the application show page" do
                  it "And under the search bar, I see any Pet whose name matches my search" do
                    @shelter_1 = Shelter.create!(foster_program: true, name: "Denver Animal Shelter", city: "Denver", rank: 1)
                    @application_1 = Application.create!(name_of_applicant: "Matt Lim", street_address: "1234 Example St", city: "Denver", state: "CO", zip_code: 80202, description: "I love animals", application_status: "In Progress")
                    @pet_1 = Pet.create!(adoptable: true, age: 1, breed: "sphynx", name: "Lucille Bald", shelter_id: @shelter_1.id)
                    @pet_2 = Pet.create!(adoptable: true, age: 3, breed: "doberman", name: "Max", shelter_id: @shelter_1.id)
                    @pet_3 = Pet.create!(adoptable: true, age: 2, breed: "labrador", name: "Molly", shelter_id: @shelter_1.id)
                    visit "/applications/#{@application_1.id}"

                    expect(page).to have_content('Add a Pet to this Application')

                    fill_in 'name', with: 'Lucille'
                    click_button 'Search'
                    click_button 'Adopt this Pet'

                    expect(page).to have_content(@pet_1.name)
                    expect(page).not_to have_content(@pet_2.name)
                    expect(page).not_to have_content(@pet_3.name)
                  end
                end
              end
            end
          end
        end
      end
    end
  end

  # 5. Add a Pet to an Application

  # As a visitor
  # When I visit an application's show page
  # And I search for a Pet by name
  # And I see the names of Pets that match my search
  # Then next to each Pet's name, I see a button to "Adopt this Pet"
  # When I click one of these buttons
  # Then I am taken back to the application show page
  # And I see the Pet I want to adopt listed on this application
  it "can add a pet to an application" do
    @shelter_1 = Shelter.create!(foster_program: true, name: "Denver Animal Shelter", city: "Denver", rank: 1)
    @application_1 = Application.create!(name_of_applicant: "Matt Lim", street_address: "1234 Example St", city: "Denver", state: "CO", zip_code: 80202, description: "I love animals", application_status: "In Progress")
    @pet_1 = Pet.create!(adoptable: true, age: 1, breed: "sphynx", name: "Lucille Bald", shelter_id: @shelter_1.id)
    @pet_2 = Pet.create!(adoptable: true, age: 3, breed: "doberman", name: "Max", shelter_id: @shelter_1.id)
    @pet_3 = Pet.create!(adoptable: true, age: 2, breed: "labrador", name: "Molly", shelter_id: @shelter_1.id)
    visit "/applications/#{@application_1.id}"

    fill_in 'name', with: 'Lucille Bald'
    click_button 'Search'

    expect(page).to have_content(@pet_1.name)
    expect(page).to have_button('Adopt this Pet')

    click_button 'Adopt this Pet'
    expect(page).to have_current_path("/applications/#{@application_1.id}")
    expect(page).to have_content(@pet_1.name)
  end

  #[ ] done
  # 6. Submit an Application
  describe "As a visitor" do
    describe "When I visit an application's show page" do
      describe "And I have added one or more pets to the application" do
        describe "Then I see a section to submit my application" do
          describe "And in that section, I see an input to enter why I would make a good owner for these pet(s)" do
            describe "When I fill in that input" do
              describe "And I click a button to submit this application" do
                describe "Then I am taken back to the application's show page" do
                  describe "And I see an indicator that the application is Pending" do
                    describe "And I see all the pets that I want to adopt" do
                      it "And I do not see a section to add more pets to this application" do
                        @shelter_1 = Shelter.create!(foster_program: true, name: "Denver Animal Shelter", city: "Denver", rank: 1)
                        @application_1 = Application.create!(name_of_applicant: "Matt Lim", street_address: "1234 Example St", city: "Denver", state: "CO", zip_code: 80202, description: "I love animals", application_status: "In Progress")

                        @pet_1 = Pet.create!(adoptable: true, age: 1, breed: "sphynx", name: "Lucille Bald", shelter_id: @shelter_1.id)
                        @application_1.pets << @pet_1
                        visit "/applications/#{@application_1.id}"

                        fill_in "Description", with: "I am excited to adopt my pet"

                        click_button "Submit"

                        expect(page).to have_current_path("/applications/#{@application_1.id}")
                        expect(page).to have_content ("I am excited to adopt my pet")
                        expect(page).to have_content ("Application Status: Pending")
                        expect(page).not_to have_content("Add a Pet to this Application")
                        expect(page).not_to have_content("Submit Application")
                        expect(page).not_to have_content("Adopt this Pet")
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
