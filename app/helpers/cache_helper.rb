# This is included to ApplicationController
# Contains helper methods for cache handling
module CacheHelper
  
  # Constants for expire times
  
  # used for things that are stored completely on Kassi db
  KASSI_DATA_CACHE_EXPIRE_TIME = 4.hours
  
  # used for things that are stored in COS db and can be changed without notice
  COS_DATA_CACHE_EXPIRE_TIME = 1.hours

  
  def self.favors_last_changed 
    Rails.cache.fetch("favors_last_changed", :expires_in => KASSI_DATA_CACHE_EXPIRE_TIME) {Time.now.to_i}
  end

  def self.update_favors_last_changed
    update_time_based_cache_key("favors_last_changed")
  end
  
  def self.items_last_changed 
    Rails.cache.fetch("items_last_changed", :expires_in => KASSI_DATA_CACHE_EXPIRE_TIME) {Time.now.to_i}
  end

  def self.update_items_last_changed 
    update_time_based_cache_key("items_last_changed")
  end
  
  def self.listings_last_changed 
    Rails.cache.fetch("listings_last_changed", :expires_in => KASSI_DATA_CACHE_EXPIRE_TIME) {Time.now.to_i}
  end
  
  def self.update_listings_last_changed 
    update_time_based_cache_key("listings_last_changed")
  end
  
  def self.frontpage_last_changed 
    Rails.cache.fetch("frontpage_last_changed", :expires_in => KASSI_DATA_CACHE_EXPIRE_TIME) {Time.now.to_i}
  end
  
  def self.update_kassi_events_last_changed 
    update_time_based_cache_key("kassi_events_last_changed")
  end
  
  def self.notifications_last_changed_for(id)
    Rails.cache.fetch("notifications_last_changed/for#{id}", :expires_in => KASSI_DATA_CACHE_EXPIRE_TIME) {Time.now.to_i}
  end
  
  def self.update_notifications_last_changed_for(id)
    Rails.cache.write("notifications_last_changed/for#{id}", Time.now.to_i, :expires_in => KASSI_DATA_CACHE_EXPIRE_TIME)
  end
  
  def self.people_last_changed
    Rails.cache.fetch("people_last_changed", :expires_in => COS_DATA_CACHE_EXPIRE_TIME) {Time.now.to_i}
  end
  
  def self.update_people_last_changed
    Rails.cache.write("people_last_changed", Time.now.to_i, :expires_in => COS_DATA_CACHE_EXPIRE_TIME)
  end
  
  def self.groups_last_changed
    Rails.cache.fetch("groups_last_changed", :expires_in => COS_DATA_CACHE_EXPIRE_TIME) {Time.now.to_i}
  end
  
  def self.update_groups_last_changed
    Rails.cache.write("groups_last_changed", Time.now.to_i, :expires_in => COS_DATA_CACHE_EXPIRE_TIME)
  end
  
  
  ### NOTE: If you add cache cache update that doesn't affect front page, change update_time_based_cache_key method accordincly
  ### so that front_page cache doesn't get expired unnecessarily
   
  def update_caches_dependent_on_friendship(person1, person2)
    # [person1, person2].each do |person|
    #   unless person.nil?
    #     I18n.available_locales.each do |locale|
    #       puts "items_list/#{locale.to_s}/#{CacheHelper.items_last_changed}/#{person.id}"
    #       Rails.cache.delete("items_list/#{locale.to_s}/#{CacheHelper.items_last_changed}/#{person.id}")
    #       # expire_action :controller => :items, :action => :index, :cache_path => "items_list/#{locale.to_s}/#{items_last_changed}/#{person.id}"
    #     end
    #   end
    # end
    
    # TODO SHOULD USE SOMETHING LIKE ABOVE
    # this one below clears all the caches, so it slows the system down unnecessarily.
    
    CacheHelper.update_favors_last_changed
    CacheHelper.update_items_last_changed
    CacheHelper.update_listings_last_changed
  end
  
  def update_caches_dependent_on_groups(person)
    # I18n.available_locales.each do |locale|
    #   Rails.cache.delete("items_list/#{locale.to_s}/#{items_last_changed}/#{person.id}")
    #  end
    
    # SHOULD USE SOMETHING LIKE ABOVE
    # this one below clears all the caches, so it slows the system down unnecessarily.
    
     CacheHelper.update_favors_last_changed
     CacheHelper.update_items_last_changed
     CacheHelper.update_listings_last_changed
  end
  
  
  
  # * people_last_changed (Time.now.to_i) tästä ei voi olla varmaa tietoa, joten oltava myös expire-aika
  # * groups_last_changed (Time.now.to_i) tästä ei voi olla varmaa tietoa, joten oltava myös expire-aika
  
  private
  
  def self.update_time_based_cache_key(key)
        
     new_value = Time.now.to_f
       
      Rails.cache.write(key, new_value, :expires_in => KASSI_DATA_CACHE_EXPIRE_TIME)
      
      # Because currently every update in cache control affects frontpage, update that value too
      #puts  "Clearing the front page cache, because: #{key}, NEW VALUE IS #{new_value}"
      Rails.cache.write("frontpage_last_changed", new_value, :expires_in => KASSI_DATA_CACHE_EXPIRE_TIME)
    
  end
end