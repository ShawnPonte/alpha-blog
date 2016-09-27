require 'test_helper'

class CreateArticleTest < ActionDispatch::IntegrationTest
  
  def setup
     @user = User.create(username: "john", email: "john@example.com", password: "password", admin: false)
  end

  test "get new article form and create new article" do 
    sign_in_as(@user, "password")
    get new_article_path
    assert_template 'articles/new'
    assert_difference 'Article.count', 1 do
      post_via_redirect articles_path, article: {title: "Test article for auto-test", description: "Blah blahh blahh", user_id: @user.id}
    end
    assert_template 'articles/show'
    assert_match "Test article for auto-test", response.body
  end
  
  test "get new article form and fail to create new article without title" do 
    sign_in_as(@user, "password")
    get new_article_path
    assert_template 'articles/new'
    assert_no_difference 'Article.count' do
      post_via_redirect articles_path, article: {title: " ", description: "Blah blahh blahh", user_id: @user.id}
    end
    assert_template 'articles/new'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end
  
  test "get new article form and fail to create new article without description" do 
    sign_in_as(@user, "password")
    get new_article_path
    assert_template 'articles/new'
    assert_no_difference 'Article.count' do
      post_via_redirect articles_path, article: {title: "Test article for auto-test", description: " ", user_id: @user.id}
    end
    assert_template 'articles/new'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end
  
  test "get new article form and fail to create new article without user ID" do 
    sign_in_as(@user, "password")
    get new_article_path
    assert_template 'articles/new'
    assert_no_difference 'Article.count' do
      post_via_redirect articles_path, article: {title: "Test article for auto-test", description: " "}
    end
    assert_template 'articles/new'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end
end