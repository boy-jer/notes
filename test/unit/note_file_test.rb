require File.dirname(__FILE__) + '/../test_helper'

class NoteFileTest < Test::Unit::TestCase

  fixtures :notes
  
  def setup
    begin
    FileUtils.remove_dir(RAILS_ROOT + "/files/bob/")
    rescue
    end
  end  
  
  def test_add_file
    note = User.find("1000001").notes.create(:date=>Time.now,:description=>"test note")
    note.save
    note_file = note.note_files.create
    note_file.add_file(uploaded_jpeg(RAILS_ROOT + "/test/fixtures/me.jpg"))
    assert(File.exists?(RAILS_ROOT + "/files/bob/#{note.id}/me.jpg"))
    assert(File.exists?(RAILS_ROOT + "/files/bob/#{note.id}/thumb_me.jpg"))
  end

  def test_remove_file
    note = User.find("1000001").notes.create(:date=>Time.now,:description=>"test note")    
    note.save
    note_file = note.note_files.create
    note_file.add_file(uploaded_jpeg(RAILS_ROOT + "/test/fixtures/me.jpg"))
    assert(File.exists?(RAILS_ROOT + "/files/bob/#{note.id}/me.jpg"))
    assert(File.exists?(RAILS_ROOT + "/files/bob/#{note.id}/thumb_me.jpg"))
    note_file.destroy
    assert(!File.exists?(RAILS_ROOT + "/files/bob/#{note.id}/me.jpg"))
    assert(!File.exists?(RAILS_ROOT + "/files/bob/#{note.id}/thumb_me.jpg"))    
  end
  
  def test_sanitize_filename
    clean=NoteFile.new.sanitize_filename("test\\directory\\file name.txt")
    assert_equal(clean,"file_name.txt")
  end

end
