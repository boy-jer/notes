class Note < ActiveRecord::Base
  acts_as_taggable
  belongs_to :user
  has_many :note_files, :dependent => :destroy
  after_destroy  :remove_tags, :remove_folder
  after_save :create_folder
    
  def remove_tags   
    self.taggings.each{|n| n.destroy}
  end

  def create_folder   
      FileUtils.mkdir_p(RAILS_ROOT + "/files/" + self.user.login + "/" + self.id.to_s + "/")
  end

  def remove_folder
    begin
      Dir.rmdir(RAILS_ROOT + "/files/" + self.user.login + "/" + self.id.to_s + "/")
    rescue
    end
  end
    
end