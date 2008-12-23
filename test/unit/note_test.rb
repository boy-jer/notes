require File.dirname(__FILE__) + '/../test_helper'

class NoteTest < Test::Unit::TestCase
  fixtures :notes, :users

  # Replace this with your real tests.

  def test_add_tag
    bob = User.find("1000001")
    note = Note.new
    note.description = 'Sample text for your new note'
    note.date = Time.now
    bob.notes << note
    assert note.save
    note.tag_with('test', bob)
    assert note.save
    assert_not_nil note.tags.collect{ |tag| tag.name }.find{ |result| result == 'test'}
    assert_nil note.tags.collect{ |tag| tag.name }.find{ |result| result == 'test2'}
  end


  def test_add_note
      bob = User.find("1000001")
      note = bob.notes.build
      note.description = 'Sample text for your new note'
      note.date = Time.now
      assert note.save
      assert_equal 'Sample text for your new note', note.description
      assert File.exist?(RAILS_ROOT + "/files/" + note.user.login + "/" + note.id.to_s + "/")
  end

  def test_remove_note
    bob = User.find("1000001")
    note = bob.notes.build
    note.description = 'Sample text for your new note'
    note.date = Time.now
    assert note.save
    note.destroy
    assert !File.exist?(RAILS_ROOT + "/files/" + note.user.login + "/" + note.id.to_s + "/")
  end

end
