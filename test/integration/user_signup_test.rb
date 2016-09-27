require 'test_helper'

class UserSignupTest < ActionDispatch::IntegrationTest
  
  test "get new user form and create new user" do 
    get signup_path
    assert_template 'users/new'
    assert_difference 'User.count', 1 do
      post_via_redirect users_path, user: {username: "ShawnP", email: "shawn@shawn.com", password: "Password"}
    end
    assert_template 'users/show'
    assert_match "ShawnP's", response.body
  end
  
   test "get new user form and fail to create new user without username" do 
    get signup_path
    assert_template 'users/new'
    assert_no_difference 'User.count' do
      post_via_redirect users_path, user: {username: " ", email: "shawn@shawn.com", password: "Password"}
    end
    assert_template 'users/new'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end
  
  test "get new user form and fail to create new user with short username" do 
    get signup_path
    assert_template 'users/new'
    assert_no_difference 'User.count' do
      post_via_redirect users_path, user: {username: "P", email: "shawn@shawn.com", password: "Password"}
    end
    assert_template 'users/new'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end
  
  test "get new user form and fail to create new user with duplicate username" do 
    get signup_path
    assert_template 'users/new'
    post_via_redirect users_path, user: {username: "ShawnP", email: "shawn@shawn.com", password: "Password"}
    get signup_path
    assert_template 'users/new'
    assert_no_difference 'User.count' do
      post_via_redirect users_path, user: {username: "ShawnP", email: "shawn@shawn.com", password: "Password"}
    end
    assert_template 'users/new'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end
  
  test "get new user form and fail to create new user without email" do 
    get signup_path
    assert_template 'users/new'
    assert_no_difference 'User.count' do
      post_via_redirect users_path, user: {username: "ShawnP", email: " ", password: "Password"}
    end
    assert_template 'users/new'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end
  
  test "get new user form and fail to create new user with invalid email" do 
    get signup_path
    assert_template 'users/new'
    assert_no_difference 'User.count' do
      post_via_redirect users_path, user: {username: "ShawnP", email: "Shawn", password: "Password"}
    end
    assert_template 'users/new'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end
  
  test "get new user form and fail to create new user with long email" do 
    get signup_path
    assert_template 'users/new'
    assert_no_difference 'User.count' do
      post_via_redirect users_path, user: {username: "ShawnP", email: "a" * 200 + "@x.com", password: "Password"}
    end
    assert_template 'users/new'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end
  
  test "get new user form and fail to create new user with no password" do 
    get signup_path
    assert_template 'users/new'
    assert_no_difference 'User.count' do
      post_via_redirect users_path, user: {username: "ShawnP", email: "shawn@shawn.com", password: ""}
    end
    assert_template 'users/new'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end
  
end