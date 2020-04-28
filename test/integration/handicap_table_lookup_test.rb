require 'test_helper'

class HandicapTableLookupTest < ActionDispatch::IntegrationTest  
  def setup
    @no_of_categories =     40
    @no_of_metric =         32
    @no_of_imperial =       33
    @no_of_indoor =         13
    @no_of_indoor_hidden =  12
    @no_of_rounds = @no_of_metric + @no_of_imperial + @no_of_indoor + @no_of_indoor_hidden
    # Clean the database (rounds, categories and handicaps only).
    require 'database_cleaner/active_record'
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean
    # Reseed the database.
    load "#{Rails.root}/db/seeds.rb"
  end
  
  test "should get category#show" do
    get category_path(1)
    assert_response :success
  end
  
  test "should get round#show" do
    get round_path(1)
    assert_response :success
  end
  
  test "total number of categories should be 40" do
    get category_path(@no_of_categories)
    assert_response :success
    assert_raises(ActiveRecord::RecordNotFound) do
      get category_path(@no_of_categories + 1)
    end
  end
  
  test "total number of rounds should be 90" do
    get round_path(@no_of_rounds)
    assert_response :success
    assert_raises(ActiveRecord::RecordNotFound) do
      get round_path(@no_of_rounds + 1)
    end
  end
  
  test "Count the number of rounds in each group on the rounds index" do 
    get rounds_path 
    assert_select "a.active",   count: 3 # Count of titles
    assert_select "a.indoor",   count: @no_of_indoor
    assert_select "a.imperial", count: @no_of_imperial
    assert_select "a.metric",   count: @no_of_metric
  end
  
  test "Count the number of categories in each group on the categories index" do 
    get categories_path 
    assert_select "a.active",   count: 4 # Count of titles
    assert_select "a.list-group-item",   count: @no_of_categories + 4
  end
  
  test "Count the number of achievable awards for sen gents recurve and <12 ladies recurve" do 
    get category_path(31) # Sen. Gents Recurve 
    assert_select "td.bold",   count: 94 # Number of achievable classes
    get category_path(40) # <12 Ladies Recurve 
    assert_select "td.bold",   count: 229 # Number of achievable classes
  end
  
  test "Count the number of achievable awards for York, Bristol 5, WA 1440 (Gents) & Frostbite" do 
    get round_path(47) # York 
    assert_select "td.bold",   count: @no_of_categories * 6
    assert_select "a.category",   count: @no_of_categories
    get round_path(53) # Bristol 5 
    assert_select "td.bold",   count: 68
    assert_select "a.category",   count: @no_of_categories
    get round_path(1) # WA 1440 (Gents) 
    assert_select "td.bold",   count: @no_of_categories * 6
    assert_select "a.category",   count: @no_of_categories
    get round_path(32) # Frostbite 
    assert_select "td.bold",   count: 0
    assert_select "a.category",   count: @no_of_categories
  end

  
  #test "DB has the correct number of objects" do
    # Total number of rounds should be 90
    # assert Round.count == 90
    # Total number of indoor rounds should be 25
    # Total number of outdoor rounds should be 65
    # Total number of WA rounds should be 46
    # Total number of AGB rounds should be 44
    # Total number of handicaps should be 9090
    # Total number of categories should be 40
    # Get 3 random handicaps
    # Get 3 random classifications
  #end
end
