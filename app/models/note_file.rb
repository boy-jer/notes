require 'RMagick'
class NoteFile < ActiveRecord::Base
  belongs_to :note
  before_destroy :remove_file  

  attr_reader :error_message

  def add_file(file)
    begin  
      if file.length > 5.megabytes
        @error_message = "File exceeds maximum size of 5 megabytes"
        return false
      end
      self.filename = sanitize_filename(file.original_filename)
      self.systempath = self.note.user.login + "/" + self.note.id.to_s + "/"
      self.filetype = file.content_type      
      
      FileUtils.mkdir_p(RAILS_ROOT + "/files/" + self.systempath)
      if File.exists?(RAILS_ROOT + "/files/" + self.systempath + self.filename)
        @error_message = "A file with that name already exists."
        return false
      else
      File.open(RAILS_ROOT + "/files/" + self.systempath + self.filename, "wb") { |f| f.write(file.read) }
      end
      if file.content_type=~/image/
        img = Magick::Image::read(RAILS_ROOT + "/files/" + self.systempath + self.filename).first        
        yxratio = (img.rows.to_f/img.columns.to_f) * 32
        xyratio = (img.columns.to_f/img.rows.to_f) * 32
        yxratio > xyratio ? img.scale!(32, yxratio.to_i) : img.scale!(xyratio.to_i,32)
        begin
          img.crop!(Magick::CenterGravity,32,32)
        rescue 
          @error_message = "Error encountered creating thumbnail"
          return false
        end
        img.write RAILS_ROOT + "/files/" + self.systempath + "thumb_" + self.filename
      end
    rescue Exception => e
      puts e.message + "#{e.backtrace.join("\n")}"
      @error_message = "Error processing file"
      return false
    end  
    return true
  end

  def remove_file
    begin
      File.delete(RAILS_ROOT + "/files/" + self.systempath + self.filename)
      File.delete(RAILS_ROOT + "/files/" + self.systempath + "thumb_" + self.filename)
    rescue
    end
  end
  
  def sanitize_filename(name)
    File.basename(name.gsub('\\', '/')).gsub(/[^\w\.\-]/,'_') 
  end
  
end
