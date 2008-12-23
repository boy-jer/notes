module ActiveRecord
  module Acts #:nodoc:
    module Taggable #:nodoc:
      def self.included(base)
        base.extend(ClassMethods)  
      end
      
      module ClassMethods
        def acts_as_taggable(options = {})
          write_inheritable_attribute(:acts_as_taggable_options, {
            :taggable_type => ActiveRecord::Base.send(:class_name_of_active_record_descendant, self).to_s,
            :from => options[:from]
          })
          
          class_inheritable_reader :acts_as_taggable_options

          has_many :taggings, :as => :taggable, :dependent => :destroy
          has_many :tags, :through => :taggings

          include ActiveRecord::Acts::Taggable::InstanceMethods
          extend ActiveRecord::Acts::Taggable::SingletonMethods          
        end
      end
      
      module SingletonMethods
        
        # Finds objects tagged with any of a list of tags, tagged by a specific user
        def find_tagged_with_by_user(list, user)
          find_by_sql([
          "SELECT #{table_name}.* FROM #{table_name}, tags, taggings " +
          "WHERE #{table_name}.#{primary_key} = taggings.taggable_id " +
          "AND taggings.user_id = ? " +
          "AND taggings.taggable_type = ? " +
          "AND taggings.tag_id = tags.id AND tags.name IN (?)",
          user.id, acts_as_taggable_options[:taggable_type], list
          ])
        end
                
        # Finds objects tagged with any of a list of tags.
        def find_tagged_with(list)
          find_by_sql([
            "SELECT #{table_name}.* FROM #{table_name}, tags, taggings " +
            "WHERE #{table_name}.#{primary_key} = taggings.taggable_id " +
            "AND taggings.taggable_type = ? " +
            "AND taggings.tag_id = tags.id AND tags.name IN (?)",
            acts_as_taggable_options[:taggable_type], list
          ])
        end
      end
      
      module InstanceMethods
        def tag_with(list, user)
          Tag.transaction do
            Tagging.destroy_all(" taggable_id = #{self.id}" +
            " and taggable_type = '#{acts_as_taggable_options[:taggable_type]}'" +
            " and user_id = #{user.id}")
            Tag.parse(list).each do |name|
              if acts_as_taggable_options[:from]
                send(acts_as_taggable_options[:from]).tags.find_or_create_by_name_and_user_id(name, user.id).on(self, user)
              else
                Tag.find_or_create_by_name_and_user_id(name, user.id).on(self, user)
              end
            end
          end
        end

        def tag_list
          tags.collect { |tag| tag.name.include?(" ") ? "'#{tag.name}'" : tag.name }.join(" ")
        end
      end
    end
  end
end