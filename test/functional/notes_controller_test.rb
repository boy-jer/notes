require File.dirname(__FILE__) + '/../test_helper'
require 'notes_controller'

# Re-raise errors caught by the controller.
class NotesController; def rescue_action(e) raise e end; end

class NotesControllerTest < Test::Unit::TestCase

  fixtures :users, :notes, :tags, :taggings  

  def setup
    @controller = NotesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    begin
    FileUtils.remove_dir(RAILS_ROOT + "/files/bob/")
    rescue
    end
  end
  
  def test_must_login
    get :index
    assert_response :redirect
    assert_redirected_to :controller=>"account", :action=>"login"
    login_as "bob"
    get :index
    assert_response :success
  end
  
  def test_index
    login_as "bob"
    get :index
    assert_response :success
    assert assigns(:notes)
  end
  
  def test_get_descr
    login_as "bob"
    get :get_descr, :id=>1
    assert_response :success
    assert assigns(:note)
    assert_equal "A sample Note", @response.body
  end

  def test_update_position
    login_as "bob"
    get :update_position, :id=>1, :x=>"50", :y=>"60", :z=>"70"
    assert assigns(:note)
    assert_equal assigns(:note).x.to_s, @request.query_parameters[:x]
    assert_response :success
  end
  
  def test_destroy
    login_as "bob"
    get :destroy, :id=>notes(:first)
    assert assigns(:note)
    assert assigns(:notes)
    assert_response :success
    assert assigns(:note).frozen?
    assert !Note.exists?(assigns(:note).id)
    assert_select_rjs do
        assert_select "a#tag_urgent", true
        assert_select "a.cloud_link", "urgent"
        assert_select "a#tag_important", false
    end
  end
  
  def test_add_tag
    login_as "bob"
    get :add_tag, :id=>2, :value=>"cool travel"
    assert assigns(:notes)
    assert assigns(:note)
    assert_equal assigns(:note).tags.length, 2
    assert_select_rjs do
      assert_select "a#tag_cool", true
      assert_select "a#tag_travel", true
      assert_select "a#tag_urgent", true
    end
  end
  
  def test_search_by_tag
    login_as "bob"
    assert_generates("/tag/cool", :controller=>"notes", :action=>"search_by_tag", :tag_search=>"cool")
    get :search_by_tag, :tag_search=>"cool"
    assert assigns(:notes)
    assert_equal assigns(:notes).length, 1
    assert_select "a#tag_cool", true
    assert_select "a#tag_travel", false
  end
  
  def test_add_file
    login_as "bob"
    post :add_file, :id=>1, :note_file=>{:file => uploaded_jpeg(RAILS_ROOT + "/test/fixtures/me.jpg")}
    assert assigns(:note_file)
    assert assigns(:note)
    assert File.exists? RAILS_ROOT + "/files/bob/1/me.jpg"
  end
  
  def test_delete_file
    login_as "bob"
    post :add_file, :id=>1, :note_file=>{:file => uploaded_jpeg(RAILS_ROOT + "/test/fixtures/me.jpg")}
    assert assigns(:note_file)
    assert assigns(:note)
    file_id = assigns(:note_file).id
    get :delete_file, :id=>1, :note_file_id=>file_id
    assert !File.exists?(RAILS_ROOT + "/files/bob/1/me.jpg")
  end
  
end
