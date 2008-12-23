module NotesHelper
  
  def generate_tag_cloud
    cloud_hash = Hash.new
    @notes.each do | user_note |
      if user_note.tags.blank?
      else
        user_note.tags.collect do | tag |
          if not cloud_hash.has_key?(tag.name)
            cloud_hash[tag.name] = 1
          else
            cloud_hash[tag.name] = cloud_hash[tag.name].to_i + 1
          end
       end  
      end 
    end
    cloud=""
    begin
      max = cloud_hash.values.collect.max
      min = cloud_hash.values.collect.min
      distrib = ((max - min)/5)
      cloud_hash.sort.each do | pair |
        tag_key = pair[0]
        count = pair[1]  
        size = if count == max 
          1.5
        elsif count == min  
          1
        elsif count > distrib * 2
          1.36
        elsif count > distrib
          1.24
        else
          1.12
        end
          cloud += link_to(tag_key, {:controller=>'notes', :action=>'search_by_tag', :tag_search=>tag_key},{:id=>"tag_#{tag_key}", :class=>"cloud_link", :style=>"font-size:#{size}em;"}) + " "
      end
    rescue
    end      
    cloud
  end
  
  def GetFileIcon(file)
    begin
    if File.exists?(RAILS_ROOT + "/public/images/icon_#{file.filename.match(/\.(...)$/)[1].upcase}_big.gif")
      return "/images/icon_#{file.filename.match(/\.(...)$/)[1].upcase}_big.gif"
    else  
      return "/images/icon_Generic_big.gif"
    end  
    rescue
      return "/images/icon_Generic_big.gif"
    end
  end

end
